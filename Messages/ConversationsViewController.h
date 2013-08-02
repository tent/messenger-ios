//
//  ConversationsViewController.h
//  Messages
//
//  Created by Jesse on 7/20/13.
//  Copyright (c) 2013 Cupcake. All rights reserved.
//

@import UIKit;
#import "ConversationsCell.h"
#import "Conversation.h"

@interface ConversationsViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (nonatomic) IBOutlet UIBarButtonItem *actionButton;
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) NSMutableSet *selectedIndexPaths;

- (NSManagedObjectContext *)managedObjectContext;
- (void)setupFetchedResultsController;
- (void)handleConversationTap:(id)sender;
- (IBAction)editButtonPressed:(id)sender;
- (IBAction)actionButtonPressed:(id)sender;
@end
