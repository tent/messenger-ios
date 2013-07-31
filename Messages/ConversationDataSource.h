//
//  ConversationDataSource.h
//  Messages
//
//  Created by Jesse on 7/22/13.
//  Copyright (c) 2013 Cupcake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationViewTableCell.h"
#import "Conversation.h"

@interface ConversationDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>

{
    NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) Conversation *conversationManagedObject;

- (NSManagedObjectContext *)managedObjectContext;
- (void)setupFetchedResultsController;
- (void)configureCell:(ConversationViewTableCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end
