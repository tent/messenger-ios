//
//  ConversationViewTableCell.h
//  Messages
//
//  Created by Jesse on 7/23/13.
//  Copyright (c) 2013 Cupcake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BubbleNibView.h"

typedef NS_ENUM(NSUInteger, ConversationMessageState) {
    ConversationMessageDelivering,
    ConversationMessageDelivered,
    ConversationMessageDeliveryFailed,
    ConversationMessageTyping
};

typedef NS_ENUM(NSUInteger, ConversationMessageAlignment) {
    ConversationMessageLeft,
    ConversationMessageRight
};

@interface ConversationViewTableCell : UITableViewCell
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *messageBody;
@property (nonatomic) ConversationMessageState messageState;
@property (nonatomic) ConversationMessageAlignment messageAlignment;

- (id)getStringForMessageState;
- (id)getIconForMessageState;
- (CGRect)getBubbleFrameForSide;
- (id) getBubbleBackgroundColor;
- (CGRect)getBubbleNibFrameForFrame:(CGRect)frame;
@end
