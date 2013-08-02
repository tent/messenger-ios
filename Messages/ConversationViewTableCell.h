//
//  ConversationViewTableCell.h
//  Messages
//
//  Created by Jesse on 7/23/13.
//  Copyright (c) 2013 Cupcake. All rights reserved.
//

@import UIKit;
#import "BubbleNibView.h"
#import "Message.h"

@interface ConversationViewTableCell : UITableViewCell
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *messageBody;
@property (nonatomic) ConversationMessageState messageState;
@property (nonatomic) ConversationMessageAlignment messageAlignment;

- (NSString*)getStringForMessageState;
- (UIImage*)getIconForMessageState;
- (CGRect)getBubbleFrameForSide;
- (UIColor*) getBubbleBackgroundColor;
- (CGRect)getBubbleNibFrameForFrame:(CGRect)frame;

- (void)setupViews;
- (void)refreshNameViewContent;
- (void)refreshBodyViewContent;
- (void)refreshStatusViewContent;
@end
