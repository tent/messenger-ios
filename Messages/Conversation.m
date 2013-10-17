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

+ (void)syncObjectID:(NSManagedObjectID *)objectID {
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

            [self syncObjectID:conversation.objectID];
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

+ (AppDelegate *)applicationDelegate {
    return (AppDelegate *)([UIApplication sharedApplication].delegate);
}

@end
