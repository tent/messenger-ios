//
//  ContactsViewController.h
//  Messages
//
//  Created by Jesse on 7/21/13.
//  Copyright (c) 2013 Cupcake. All rights reserved.
//

@import UIKit;

@interface ContactsViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *continueButton;
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;

- (NSManagedObjectContext *)managedObjectContext;
- (void)setupFetchedResultsController;
- (void)enableDisableContinueButton;

@end
