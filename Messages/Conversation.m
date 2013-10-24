//
//  Conversation.m
//  Messages
//
//  Created by Jesse Stuart on 7/28/13.
//  Copyright (c) 2013 Boolean Cupcake, LLC. All rights reserved.
//

#import "Conversation.h"
#import "Contact.h"
#import "Message.h"
#import "AppDelegate.h"
#import "TCPost+CoreData.h"
#import "TentClient.h"
#import "NSArray+Filtering.h"

@implementation Conversation

@dynamic contacts;
@dynamic messages;
@dynamic latestMessage;
@dynamic conversationPost;

+ (void)persistObjectID:(NSManagedObjectID *)objectID {
    NSManagedObjectContext *context = [[self applicationDelegate] managedObjectContext];

    Conversation *conversation = (Conversation *)[context objectWithID:objectID];

    // Conversation doesn't exist
    if (!conversation) return;

    // Conversation doesn't contain any messages
    if ([conversation.messages count] == 0) return;

    TCAppPost *appPost = [self applicationDelegate].currentAppPost;

    // No authentication, abort!
    if (!appPost || !appPost.authCredentialsPost) return;

    TentClient *client = [TentClient clientWithEntity:appPost.entityURI];
    client.credentialsPost = appPost.authCredentialsPost;

    NSArray *conversationEntities = [[conversation.contacts allObjects] transposedArrayUsingBlock:^id(Contact *contact) {
            return [[contact.relationshipPost.mentions objectAtIndex:0] objectForKey:@"entity"];
    }];

    // Create conversation post if it doesn't exist already
    if (!conversation.conversationPost) {

        TCPost *conversationPost = [[TCPost alloc] init];
        conversationPost.typeURI = @"https://tent.io/types/conversation/v0#";
        conversationPost.mentions = [conversationEntities transposedArrayUsingBlock:^id(NSString *entity) {
            return @{ @"entity": entity };
        }];
        conversationPost.permissionsPublic = NO;
        conversationPost.permissionsEntities = conversationEntities;

        [client newPost:conversationPost successBlock:^(AFHTTPRequestOperation *operation, TCPost *post) {

            NSError *error;

            conversation.conversationPost = [MTLManagedObjectAdapter managedObjectFromModel:post insertingIntoContext:context error:&error];

            if (error) {
                NSLog(@"error translating conversation post into managed object: %@", error);
                return;
            }

            if (![context save:&error]) {
                NSLog(@"error saving context: %@", error);
                return;
            }

            [self persistObjectID:conversation.objectID];
        } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed to create conversation: %@", error);
        }];

        return;
    }

    // Create missing message posts
    [conversation.messages enumerateObjectsUsingBlock:^(Message *message, BOOL *stop) {
        if (message.messagePost) return;

        TCPost *messagePost = [[TCPost alloc] init];
        messagePost.typeURI = @"https://tent.io/types/message/v0#";

        messagePost.content = @{
                                @"text": message.body
                                };

        NSMutableArray *mentions = [NSMutableArray arrayWithArray:[conversationEntities transposedArrayUsingBlock:^id(NSString *entity) {
            return @{ @"entity": entity };
        }]];

        [mentions addObject:@{
                              @"entity": conversation.conversationPost.entityURI,
                              @"post": conversation.conversationPost.id
                              }];

        messagePost.mentions = [NSArray arrayWithArray:mentions];

        messagePost.refs = @[@{
                                @"entity": conversation.conversationPost.entityURI,
                                @"post": conversation.conversationPost.id
                             }];

        messagePost.permissionsPublic = NO;
        messagePost.permissionsEntities = conversationEntities;

        [client newPost:messagePost successBlock:^(AFHTTPRequestOperation *operation, TCPost *post) {

            NSError *error;
            message.messagePost = [MTLManagedObjectAdapter managedObjectFromModel:post insertingIntoContext:context error:&error];

            if (error) {
                NSLog(@"error translating messagePost into a managed object: %@", error);
                return;
            }

            if (![context save:&error]) {
                NSLog(@"error saving context: %@", context);
            }

        } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed to create message: %@", error);
        }];
    }];
}

+ (void)syncAllConversations {
    // Call +persistObjectID: for each conversation in db

    NSError *error;

    NSManagedObjectContext *context = [[self applicationDelegate] managedObjectContext];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Conversation"];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"latestMessage.timestamp" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"contacts.@count > 0"];
    [fetchRequest setPredicate:predicate];

    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];

    [fetchedResultsController performFetch:&error];

    [fetchedResultsController.fetchedObjects enumerateObjectsUsingBlock:^(Conversation *obj, NSUInteger idx, BOOL *stop) {
        // TODO: push this onto an NSOperationQueue
        [self persistObjectID:obj.objectID];
    }];

    // Fetch new messages for all conversations

    [self fetchNewMessages];
}

+ (void)fetchNewMessages {
    TCParams *feedParams = [[TCParams alloc] init];

    [feedParams addValue:@"https://tent.io/types/message/v0" forKey:@"types"];
    [feedParams addValue:@"1" forKey:@"max_refs"];

    Cursors *cursors = [self applicationDelegate].cursors;

    TCAppPost *appPost = [self applicationDelegate].currentAppPost;

    // No authentication, abort!
    if (!appPost || !appPost.authCredentialsPost) return;

    TentClient *client = [TentClient clientWithEntity:appPost.entityURI];
    client.credentialsPost = appPost.authCredentialsPost;

    // since cursor
    [feedParams addValue:[cursors stringFromTimestamp:cursors.messageCursorTimestamp version:cursors.messageCursorVersionID] forKey:@"since"];

    __block BOOL fetchMessagesComplete = NO;

    void (^completionBlock)() = ^{
        fetchMessagesComplete = YES;
    };

    [self fetchNewMessagesWithClient:client params:feedParams successBlock:^(AFHTTPRequestOperation *operation, TCResponseEnvelope *responseEnvelope) {

        if ([[responseEnvelope posts] count] == 0) return;

        NSManagedObjectContext *context = [[self applicationDelegate] managedObjectContext];


        // Enumerate conversation posts and find/create managed objects for them

        NSMutableDictionary *conversationManagedObjects = [[NSMutableDictionary alloc] init];

        [[responseEnvelope refs] enumerateObjectsUsingBlock:^(TCPost *postModel, NSUInteger idx, BOOL *stop) {
            if (![postModel.typeURI hasPrefix:@"https://tent.io/types/conversation/v0"]) return;

            // TODO: check if conversation is already in db (MTL may already do this, verify)

            NSError *error;

            TCPostManagedObject *conversationPostManagedObject = [MTLManagedObjectAdapter managedObjectFromModel:postModel insertingIntoContext:context error:&error];

            if (error) {
                NSLog(@"Error transposing conversation post into manged object: %@", error);
            }

            Conversation *conversationManagedObject = [[Conversation alloc] initWithEntity:[NSEntityDescription entityForName:@"Conversation" inManagedObjectContext:context] insertIntoManagedObjectContext:context];

            [postModel.mentions enumerateObjectsUsingBlock:^(NSDictionary *mention, NSUInteger idx, BOOL *stop) {
                if ([mention valueForKey:@"post"]) return; // Skip any mentioned posts
                if (![mention valueForKey:@"entity"]) return; // Skip mentions referencing conversation post entity

                NSError *contactLookupError;
                Contact *contact = [self contactForEntity:[mention valueForKey:@"entity"] error:&contactLookupError];

                if (contact) {
                    [conversationManagedObject addContactsObject:contact];
                } else {
                    NSLog(@"Error looking up Contact for <Entity %@>: %@", [mention valueForKey:@"entity"], error);
                }
            }];

            conversationManagedObject.conversationPost = conversationPostManagedObject;


            [conversationManagedObjects setObject:conversationManagedObject forKey:postModel.ID];
        }];

        // Enumerate all message posts and find/create managed objects for them

        [[responseEnvelope posts] enumerateObjectsUsingBlock:^(TCPost *postModel, NSUInteger idx, BOOL *stop) {
            // TODO: check if message is already in db (MTL may already do this, verify)

            NSString *conversationPostID = [[postModel.refs objectAtIndex:0] objectForKey:@"post"]; // TODO: find conversation ref as it's not garenteed to be the first
            Conversation *conversationManagedObject = [conversationManagedObjects objectForKey:conversationPostID];

            NSError *error;

            TCPostManagedObject *messagePostManagedObject = [MTLManagedObjectAdapter managedObjectFromModel:postModel insertingIntoContext:context error:&error];

            Message *messageManagedObject = [[Message alloc] initWithEntity:[NSEntityDescription entityForName:@"Message" inManagedObjectContext:context] insertIntoManagedObjectContext:context];

            messageManagedObject.messagePost = messagePostManagedObject;

            messageManagedObject.conversation = conversationManagedObject;
        }];

        NSError *error;

        if (![[self applicationDelegate] saveContext:context error:&error]) {
            NSLog(@"Error saving context: %@", error);
        } else {

            NSLock *saveCursorsLock = [[self applicationDelegate] saveCursorsLock];

            [saveCursorsLock lock];

            // TODO: Update cursor

            [saveCursorsLock unlock];

        }

    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {

        NSLog(@"failed to fetch message posts: %@ with request: %@ response: %@", error, [[NSString alloc] initWithData:[operation.request HTTPBody] encoding:NSUTF8StringEncoding], operation.responseString);

    } completionBlock:completionBlock];

    // Wait for all requests to finish
    [client.operationQueue addOperationWithBlock:^{
        while (!fetchMessagesComplete) {
            [NSThread sleepForTimeInterval:1];
        }
    }];

    [client.operationQueue waitUntilAllOperationsAreFinished];
}

+ (void)fetchNewMessagesWithClient:(TentClient *)client params:(TCParams *)feedParams successBlock:(void (^)(AFHTTPRequestOperation *, TCResponseEnvelope *))success failureBlock:(void (^)(AFHTTPRequestOperation *, NSError *))failure completionBlock:(void (^)())completion {

    [client postsFeedWithParams:feedParams successBlock:^(AFHTTPRequestOperation *operation, TCResponseEnvelope *responseEnvelope) {
       
        NSLog(@"fetchNewMessages <%@ %@>: %@", [operation.request HTTPMethod], operation.request.URL, responseEnvelope);

        if ([responseEnvelope isEmpty]) {
            completion();
        } else {

            success(operation, responseEnvelope);

            TCParams *prevPageParams = [responseEnvelope previousPageParams];

            [self fetchNewMessagesWithClient:client params:prevPageParams successBlock:success failureBlock:failure completionBlock:completion];

        }

    } failureBlock:failure];
}

+ (Contact *)contactForEntity:(NSString *)entity error:(NSError *__autoreleasing *)error {
    NSManagedObjectContext *context = [[self applicationDelegate] managedObjectContext];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Contact"];

    // Configure sort order
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"relationshipPost.entityURI == %@", entity];
    [fetchRequest setPredicate:predicate];

    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];

    [fetchedResultsController performFetch:error];

    if ([fetchedResultsController.fetchedObjects count] == 0) {
        return nil;
    }

    return [fetchedResultsController.fetchedObjects objectAtIndex:0];
}

+ (AppDelegate *)applicationDelegate {
    return (AppDelegate *)([UIApplication sharedApplication].delegate);
}

@end
