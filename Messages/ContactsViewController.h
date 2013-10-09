//
//  ContactsViewController.h
//  Messages
//
//  Created by Jesse on 7/21/13.
//  Copyright (c) 2013 Boolean Cupcake, LLC. All rights reserved.
//

@import UIKit;

@interface ContactsViewController : UITableViewController <NSFetchedResultsControllerDelegate, UISearchDisplayDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *continueButton;
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) UISearchDisplayController *mySearchDisplayController;

- (NSManagedObjectContext *)managedObjectContext;
- (void)setupFetchedResultsController;
- (void)enableDisableContinueButton;

@end
