//
//  Message.h
//  Messages
//
//  Created by Jesse Stuart on 7/28/13.
//  Copyright (c) 2013 Cupcake. All rights reserved.
//

@import Foundation;
@import CoreData;

typedef NS_ENUM(NSUInteger, ConversationMessageState) {
    ConversationMessageDelivering,
    ConversationMessageDelivered,
    ConversationMessageDeliveryFailed,
    ConversationMessageTyping,
    ConversationMessageExists
};

typedef NS_ENUM(NSUInteger, ConversationMessageAlignment) {
    ConversationMessageLeft,
    ConversationMessageRight
};

@class Contact, Conversation;

@interface Message : NSManagedObject

@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) Contact *contact;
@property (nonatomic, retain) Conversation *conversation;

- (ConversationMessageAlignment)getAlignment;

@end
