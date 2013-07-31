//
//  ConversationDataSource.m
//  Messages
//
//  Created by Jesse on 7/22/13.
//  Copyright (c) 2013 Cupcake. All rights reserved.
//

#import "ConversationDataSource.h"
#import "AppDelegate.h"
#import "Message.h"
#import "Contact.h"

@implementation ConversationDataSource

- (NSManagedObjectContext *)managedObjectContext {
    if (!managedObjectContext) {
        managedObjectContext = [(AppDelegate *)([UIApplication sharedApplication].delegate) managedObjectContext];
    }

    return managedObjectContext;
}

- (void)setupFetchedResultsController {
    NSManagedObjectContext *context = [self managedObjectContext];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Message"];

    // Configure the request's entity, and optionally its predicate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"conversation == %@", self.conversationManagedObject];
    [fetchRequest setPredicate:predicate];

    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:@"ConversationMessages"];

    NSError *error;
    [self.fetchedResultsController performFetch:&error];
}

- (void)configureCell:(ConversationViewTableCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Message *message = [self.fetchedResultsController objectAtIndexPath:indexPath];

    cell.name = message.contact.name;
    cell.messageBody = message.body;
    // cell.messageState = message.state;
    cell.messageAlignment = [message getAlignment];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"conversationCell";
    ConversationViewTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    [self configureCell:cell atIndexPath:indexPath];

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     This is called for every row in the table before any of the cells are rendered
     and is a temperary solution to style the cells

     TODO: Replace this with something performant!
     */

    ConversationViewTableCell *cell = [[ConversationViewTableCell alloc] init];

    [self configureCell:cell atIndexPath:indexPath];

    return cell.frame.size.height;
}


@end
