//
//  ConversationsCell.h
//  Messages
//
//  Created by Jesse on 7/25/13.
//  Copyright (c) 2013 Boolean Cupcake, LLC. All rights reserved.
//

@import UIKit;
#import "Conversation.h"
#import "ConversationsViewController.h"

@interface ConversationsCell : UITableViewCell

@property(nonatomic) Conversation *conversation;
@property(nonatomic) UITableViewController *tableViewController;
@property(nonatomic) NSIndexPath *indexPath;

- (void)initConversation:(Conversation *)conversation;

- (void)refreshTimeViewContent;
- (void)refreshImageViewContent;
- (void)refreshNameViewContent;
- (void)refreshBodyViewContent;
@end
