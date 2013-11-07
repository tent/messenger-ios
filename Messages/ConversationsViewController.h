//
//  ConversationsViewController.h
//  Messages
//
//  Created by Jesse on 7/20/13.
//  Copyright (c) 2013 Boolean Cupcake, LLC. All rights reserved.
//

@import UIKit;
#import "ConversationsCell.h"
#import "Conversation.h"

@interface ConversationsViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic) IBOutlet UIBarButtonItem *actionButton;
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) NSMutableSet *selectedIndexPaths;

- (NSManagedObjectContext *)managedObjectContext;
- (void)setupFetchedResultsController;
- (void)handleConversationTap:(id)sender;
- (void)refreshConversations:(UIRefreshControl *)sender;
- (IBAction)accountsButtonPressed:(id)sender;
- (IBAction)actionButtonPressed:(id)sender;
@end
