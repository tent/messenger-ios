//
//  Contact.m
//  Messages
//
//  Created by Jesse Stuart on 7/28/13.
//  Copyright (c) 2013 Boolean Cupcake, LLC. All rights reserved.
//

#import "Contact.h"
#import "Conversation.h"
#import "Message.h"
#import "AppDelegate.h"
#import "Cursors.h"
#import "TentClient.h"
#import "TCPost+CoreData.h"

@implementation Contact

@dynamic avatar;
@dynamic name;
@dynamic entityURI;
@dynamic conversations;
@dynamic messages;
@dynamic sectionName;
@dynamic relationshipPost;

+ (void)syncRelationships {
    [[self applicationDelegate] showNetworkActivityIndicator];

    Cursors *cursors = ((AppDelegate *)([UIApplication sharedApplication].delegate)).cursors;
    TCAppPost *appPost = [((AppDelegate *)([UIApplication sharedApplication].delegate)) currentAppPost];

    TCParams *feedParams = [TCParams paramsWithDictionary:@{
                                                            @"types": @[@"https://tent.io/types/relationship/v0"],
                                                            @"entities": [appPost.entityURI absoluteString],
                                                            @"profiles": @"mentions"
                                                            }];

    // since cursor
    [feedParams addValue:[cursors stringFromTimestamp:cursors.relationshipCursorTimestamp version:cursors.relationshipCursorVersionID] forKey:@"since"];

    TentClient *client = [TentClient clientWithEntity:appPost.entityURI];
    NSError *error;
    client.metaPost = [[self applicationDelegate] fetchMetaPostForEntity:[appPost.entityURI absoluteString] error:&error];
    client.credentialsPost = appPost.authCredentialsPost;

    NSOperationQueue *fetchAvatarsQueue = [[NSOperationQueue alloc] init];
    [fetchAvatarsQueue setSuspended:YES];

    __block BOOL relastionshipsSyncComplete = NO;
    __block int avatarsSyncRemaining = 0;

    NSLock *avatarsSyncRemainingLock = [[NSLock alloc] init];

    [self fetchRelationshipsWithClient:client feedParams:feedParams successBlock:^(__unused AFHTTPRequestOperation *operation, TCResponseEnvelope *responseEnvelope) {

        if ([[responseEnvelope posts] count] == 0) return;

        __block NSError *saveError;

        NSManagedObjectContext *context = [[self applicationDelegate] managedObjectContext];

        NSDictionary *profiles = [responseEnvelope profiles];

        TCPost *firstPost = [[responseEnvelope posts] firstObject];
        NSDate *firstTimestamp = firstPost.publishedAt;
        NSString *firstVersionID = firstPost.versionID;

        [[responseEnvelope posts] enumerateObjectsUsingBlock:^(TCPost *post, __unused NSUInteger idx, __unused BOOL *stop) {
            NSString *entity = [((NSDictionary *)[post.mentions objectAtIndex:0]) objectForKey:@"entity"];
            NSDictionary *profile = [profiles objectForKey:entity];

            if (!profile) return;

            Contact *contact = [[Contact alloc] initWithEntity:[NSEntityDescription entityForName:@"Contact" inManagedObjectContext:context] insertIntoManagedObjectContext:context];

            contact.name = [profile objectForKey:@"name"];

            if (!contact.name) {
                contact.name = entity;
            }

            contact.entityURI = entity;

            contact.sectionName = [contact.name substringToIndex:1];

            __block NSManagedObjectID *contactObjectID = contact.objectID;
            __block NSString *avatarDigest = [profile objectForKey:@"avatar_digest"];

            if (contactObjectID && avatarDigest) {
                [fetchAvatarsQueue addOperationWithBlock:^{
                    [self fetchAvatarWithContactObjectID:contactObjectID entity:entity avatarDigest:avatarDigest client:client completionBlock:^{
                        // Decrement number of avatar requests remaining
                        [avatarsSyncRemainingLock lock];
                        avatarsSyncRemaining--;
                        [avatarsSyncRemainingLock unlock];
                    }];
                }];
            }

            NSError *existingContactFetchError;
            [self deleteContactsForPostID:post.ID error:&existingContactFetchError];

            if (existingContactFetchError) {
                NSLog(@"error deleting duplicate contacts: %@", existingContactFetchError);
            }

            TCPostManagedObject *postManagedObject = [MTLManagedObjectAdapter managedObjectFromModel:post insertingIntoContext:context error:&saveError];

            contact.relationshipPost = postManagedObject;
        }];

        if (![context hasChanges]) return;

        if ([[self applicationDelegate] saveContext:context error:&saveError]) {
           
            NSLock *saveCursorsLock = [[self applicationDelegate] saveCursorsLock];

            [saveCursorsLock lock];

            cursors.relationshipCursorTimestamp = firstTimestamp;
            cursors.relationshipCursorVersionID = firstVersionID;

            [cursors saveToPlistWithError:&saveError];

            [saveCursorsLock unlock];
        }
    } completionBlock:^{
        relastionshipsSyncComplete = YES;
    }];

    // Wait for all requests to finish
    [client.operationQueue addOperationWithBlock:^{
        while (!relastionshipsSyncComplete) {
            [NSThread sleepForTimeInterval:1];
        }

        // Set number of avatar requests remaining
        [avatarsSyncRemainingLock lock];
        avatarsSyncRemaining = (int)[fetchAvatarsQueue operationCount];
        [avatarsSyncRemainingLock unlock];

        // Wait until all relationships are synced before fetching avatars
        [fetchAvatarsQueue setSuspended:NO];

        // Wait until all avatar requests are queued
        [fetchAvatarsQueue waitUntilAllOperationsAreFinished];

        // Wait until all avatar requests/callbacks have completed
        while (avatarsSyncRemaining > 0) {
            [NSThread sleepForTimeInterval:1];
        }
    }];

    // TODO: fetch any missing avatars

    [client.operationQueue waitUntilAllOperationsAreFinished];

    [[self applicationDelegate] hideNetworkActivityIndicator];
}

+ (BOOL)deleteContactsForPostID:(NSString *)postID error:(NSError *__autoreleasing *)error {
    NSManagedObjectContext *context = [[self applicationDelegate] managedObjectContext];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Contact"];

    // Configure sort order
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"relationshipPost.id == %@", postID];
    [fetchRequest setPredicate:predicate];

    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];

    [fetchedResultsController performFetch:error];

    if ([fetchedResultsController.fetchedObjects count] == 0) {
        return NO;
    }

    [fetchedResultsController.fetchedObjects enumerateObjectsUsingBlock:^(Contact *obj, __unused NSUInteger idx, __unused BOOL *stop) {
        [context deleteObject:obj.relationshipPost];
        [context deleteObject:obj];
    }];

    if (error) {
        return NO;
    } else {
        return YES;

    }
}

+ (void)fetchRelationshipsWithClient:(TentClient *)client feedParams:(TCParams *)feedParams successBlock:(void (^)(AFHTTPRequestOperation *operation, TCResponseEnvelope *responseEnvelope))success completionBlock:(void (^)())completion {

    [client postsFeedWithParams:feedParams successBlock:^(AFHTTPRequestOperation *operation, TCResponseEnvelope *responseEnvelope) {
        success(operation, responseEnvelope);

        if ([responseEnvelope isEmpty]) {
            completion();
        } else {
            TCParams *prevPageParams = [responseEnvelope previousPageParams];

            [self fetchRelationshipsWithClient:client feedParams:prevPageParams successBlock:success completionBlock:completion];
        }
    } failureBlock:^(__unused AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"postsFeedWithParams failure: %@", error);

        completion();
    }];
}

+ (void)fetchAvatarWithContactObjectID:(NSManagedObjectID *)contactObjectID entity:(NSString *)entity avatarDigest:(NSString *)avatarDigest client:(TentClient *)client completionBlock:(void (^)())completion {
    [client getAttachmentWithEntity:entity digest:avatarDigest successBlock:^(__unused AFHTTPRequestOperation *operation, NSData *attachmentBinary) {
        NSManagedObjectContext *context = [[self applicationDelegate] managedObjectContext];

        Contact *contact = (Contact *)[context objectWithID:contactObjectID];

        contact.avatar = attachmentBinary;

        NSError *error;

        [[self applicationDelegate] saveContext:context error:&error];

        if (error) {
            NSLog(@"error saving contact avatar: %@", error);
        }

        completion();
    } failureBlock:^(__unused AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"fetch avatar failure: %@", error);

        completion();
    }];
}

+ (AppDelegate *)applicationDelegate {
    return (AppDelegate *)([UIApplication sharedApplication].delegate);
}

@end
