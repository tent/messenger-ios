//
//  ConversationViewController.h
//  Messages
//
//  Created by Jesse on 7/22/13.
//  Copyright (c) 2013 Cupcake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConversationViewTableCell.h"
#import "Conversation.h"

@interface ConversationViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

{
    NSManagedObjectContext *managedObjectContext;
    NSFetchedResultsController *fetchedResultsController;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardHeight;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (nonatomic) Conversation *conversation;

- (void)participantsButtonPressed:(id)sender;
- (void)sendButtonPressed:(id)sender;
- (NSManagedObjectContext *)managedObjectContext;
- (NSFetchedResultsController *)fetchedResultsController;
- (void)performFetch;
- (void)configureCell:(ConversationViewTableCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)scrollToBottom;
@end
