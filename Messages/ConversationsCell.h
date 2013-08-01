//
//  ConversationsCell.h
//  Messages
//
//  Created by Jesse on 7/25/13.
//  Copyright (c) 2013 Cupcake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Conversation.h"
#import "ConversationsViewController.h"

@interface ConversationsCell : UITableViewCell

{
    NSArray *contacts;
    UIView *imageView;
    UIView *contentView;
    UILabel *timeView;
    NSTimer *refreshTimer;
}

@property (nonatomic) Conversation *conversation;
@property (nonatomic) UITableViewController *tableViewController;
@property (nonatomic) NSIndexPath *indexPath;

- (void)initConversation:(Conversation *)conversation;
- (void)updateTimeView;
@end
