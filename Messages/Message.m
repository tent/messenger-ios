//
//  Message.m
//  Messages
//
//  Created by Jesse Stuart on 7/28/13.
//  Copyright (c) 2013 Boolean Cupcake, LLC. All rights reserved.
//

#import "Message.h"
#import "Contact.h"
#import "Conversation.h"
#import "AppDelegate.h"
#import "TCPost+CoreData.h"


@implementation Message

@dynamic body;
@dynamic timestamp;
@dynamic contact;
@dynamic conversation;
@dynamic messagePost;

- (ConversationMessageAlignment)getAlignment {
    // TODO: calculate alignment based on who authored the message (us or them)
    return ConversationMessageLeft;
}

- (void)prepareForDeletion {
    /*
     * This message is about to be deleted
     * Perform the delete operation on the Tent server
     */

    [((AppDelegate *)([UIApplication sharedApplication].delegate)) showNetworkActivityIndicator];

    TCAppPost *appPost = [((AppDelegate *)([UIApplication sharedApplication].delegate)) currentAppPost];

    TentClient *client = [TentClient clientWithEntity:appPost.entityURI];

    client.credentialsPost = appPost.authCredentialsPost;

    TCPostManagedObject *messagePost = self.messagePost;

    void (^completion)() = ^ {
        [((AppDelegate *)([UIApplication sharedApplication].delegate)) hideNetworkActivityIndicator];
    };

    [client deletePostWithEntity:messagePost.entityURI postID:messagePost.id successBlock:^(__unused AFHTTPRequestOperation *operation) {
        NSLog(@"successfully deleted message post");

        completion();
    } failureBlock:^(__unused AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error deleting message post: %@ via <%@ %@>", error, [operation.request HTTPMethod], operation.request.URL);

        completion();
    }];
}

@end
