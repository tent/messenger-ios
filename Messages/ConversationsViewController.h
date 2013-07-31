//
//  ConversationsViewController.h
//  Messages
//
//  Created by Jesse on 7/20/13.
//  Copyright (c) 2013 Cupcake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConversationsCell.h"
#import "Conversation.h"

@interface ConversationsViewController : UITableViewController
{
    NSArray *conversations;
    NSManagedObjectContext *managedObjectContext;
    Conversation *selectedConversation;
}

@property (nonatomic) NSFetchedResultsController *fetchedResultsController;

- (NSManagedObjectContext *)managedObjectContext;
- (void)setupFetchedResultsController;
- (void)handleConversationTap:(id)sender;
@end
