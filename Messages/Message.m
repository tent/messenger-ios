//
//  Message.m
//  Messages
//
//  Created by Jesse Stuart on 7/28/13.
//  Copyright (c) 2013 Cupcake. All rights reserved.
//

#import "Message.h"
#import "Contact.h"
#import "Conversation.h"


@implementation Message

@dynamic body;
@dynamic timestamp;
@dynamic contact;
@dynamic conversation;

- (ConversationMessageAlignment)getAlignment {
    // TODO: calculate alignment based on who authored the message (us or them)
    return ConversationMessageLeft;
}

@end
