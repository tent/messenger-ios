//
//  ConversationsViewController.h
//  Messages
//
//  Created by Jesse on 7/20/13.
//  Copyright (c) 2013 Cupcake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConversationsCell.h"

@interface ConversationsViewController : UITableViewController
{
    NSArray *conversations;
    NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic) NSFetchedResultsController *fetchedResultsController;

- (NSManagedObjectContext *)managedObjectContext;
- (void)setupFetchedResultsController;
- (void)handleConversationTap:(id)sender;
@end
