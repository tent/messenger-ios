//
//  ConversationViewController.h
//  Messages
//
//  Created by Jesse on 7/22/13.
//  Copyright (c) 2013 Cupcake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConversationDataSource.h"

@interface ConversationViewController : UIViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardHeight;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) ConversationDataSource *tableDataSource;

- (void)participantsButtonPressed:(id)sender;
@end
