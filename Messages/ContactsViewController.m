//
//  ContactsViewController.m
//  Messages
//
//  Created by Jesse on 7/21/13.
//  Copyright (c) 2013 Boolean Cupcake, LLC. All rights reserved.
//

#import "ContactsViewController.h"
#import "UIImage+Resize.h"
#import "Contact.h"
#import "AppDelegate.h"
#import "ConversationViewController.h"
#import "ContactTableCell.h"
#import "TCPost+CoreData.h"

@interface ContactsViewController ()
@end

@implementation ContactsViewController

{
    UIView *blankView;
    NSMutableSet *selectedContacts;
    NSManagedObjectContext *managedObjectContext;

    NSFetchedResultsController *searchFetchedResultsController;
}

- (NSManagedObjectContext *)managedObjectContext {
    if (!managedObjectContext) {
        managedObjectContext = [(AppDelegate *)([UIApplication sharedApplication].delegate) managedObjectContext];
    }

    return managedObjectContext;
}

#pragma mark - Lifecycle

- (id)initWithCoder:(NSCoder *)decoder
{
    id ret = [super initWithCoder:decoder];

    blankView = [[UIView alloc] init];
    selectedContacts = [[NSMutableSet alloc] init];

    return ret;
}

- (void)loadView
{
    [super loadView];


    // Setup search bar

    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44.0)];
    searchBar.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.tableView.tableHeaderView = searchBar;

    self.mySearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    self.mySearchDisplayController.delegate = self;
    self.mySearchDisplayController.searchResultsDataSource = self;
    self.mySearchDisplayController.searchResultsDelegate = self;

    [self.mySearchDisplayController.searchResultsTableView registerClass:ContactTableCell.class forCellReuseIdentifier:@"contactCell"];


    // Setup fetched results controllers

    [self setupFetchedResultsController];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self enableDisableContinueButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self configureTableView:self.tableView];

    [self configureTableView:self.searchDisplayController.searchResultsTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureTableView:(UITableView *)tableView {
    [tableView setEditing:YES animated:NO];
    tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);

    tableView.allowsMultipleSelectionDuringEditing = YES;
}

#pragma mark - Fetched Results Controller Initialization

- (void)setupFetchedResultsController {
    NSManagedObjectContext *context = [self managedObjectContext];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Contact"];

    // Configure the request's entity, and optionally its predicate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];

    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];

    self.fetchedResultsController.delegate = self;

    NSError *error;
    [self.fetchedResultsController performFetch:&error];
}

- (NSFetchedResultsController *)searchFetchedResultsController {
    if (searchFetchedResultsController) return searchFetchedResultsController;

    return [self configureSearchFetchedResultsController];
}

- (NSFetchedResultsController *)configureSearchFetchedResultsController {
    NSManagedObjectContext *context = [self managedObjectContext];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Contact"];

    // Configure the request's entity, and optionally its predicate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];

    // Filter using search query
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains[cd] %@", self.mySearchDisplayController.searchBar.text];
    [fetchRequest setPredicate:predicate];

    searchFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];

    searchFetchedResultsController.delegate = self;

    [searchFetchedResultsController performFetch:nil];

    return searchFetchedResultsController;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [[self tableViewForFetchedResultsController:controller] beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    UITableView *tableView = [self tableViewForFetchedResultsController:controller];

    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = [self tableViewForFetchedResultsController:controller];

    switch(type) {

        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeUpdate:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [[self tableViewForFetchedResultsController:controller] endUpdates];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self fetchedResultsControllerForTableView:tableView].sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[[self fetchedResultsControllerForTableView:tableView] sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [[self fetchedResultsControllerForTableView:tableView] sectionIndexTitles];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[[self fetchedResultsControllerForTableView:tableView] sections] objectAtIndex:section];
    return [sectionInfo name];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [[self fetchedResultsControllerForTableView:tableView] sectionForSectionIndexTitle:title atIndex:index];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSFetchedResultsController *fetchedResultsController = [self fetchedResultsControllerForTableView:tableView];

    NSString *cellIdentifier = @"contactCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    Contact *contact = [fetchedResultsController objectAtIndexPath:indexPath];

    cell.textLabel.text = contact.name;
    cell.multipleSelectionBackgroundView = blankView;
    
    UIImage *avatar = [UIImage imageWithData:contact.avatar];
    avatar = [avatar thumbnailImage:40 transparentBorder:0 cornerRadius:3 interpolationQuality:kCGInterpolationHigh];
    
    cell.imageView.image = avatar;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSFetchedResultsController *fetchedResultsController = [self fetchedResultsControllerForTableView:tableView];

    Contact *contact = [fetchedResultsController objectAtIndexPath:indexPath];
    [selectedContacts addObject:contact];

    [self enableDisableContinueButton];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSFetchedResultsController *fetchedResultsController = [self fetchedResultsControllerForTableView:tableView];

    Contact *contact = [fetchedResultsController objectAtIndexPath:indexPath];
    [selectedContacts removeObject:contact];

    [self enableDisableContinueButton];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSFetchedResultsController *fetchedResultsController = [self fetchedResultsControllerForTableView:tableView];

    Contact *contact = [fetchedResultsController objectAtIndexPath:indexPath];

    if ([[selectedContacts objectsPassingTest:^BOOL(Contact *obj, BOOL *stop) {
        return [contact.relationshipPost.id isEqualToString:obj.relationshipPost.id];
    }] count] > 0) {
        cell.selected = YES;
    } else {
        cell.selected = NO;
    }
}

#pragma mark - UISearchDisplayController Delegate Methods

- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView {
    [selectedContacts enumerateObjectsUsingBlock:^(Contact *obj, BOOL *stop) {
        NSIndexPath *indexPath = [self.fetchedResultsController indexPathForObject:obj];

        if (!indexPath) return;

        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];

        cell.selected = YES;
    }];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self configureSearchFetchedResultsController];

    // Return YES to cause the search results tableView to reload
    return YES;
}

#pragma mark - UISearchBarDelegate

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"newConversationSegue"]) {
        ConversationViewController *conversationViewController = (ConversationViewController *)([segue destinationViewController]);

        NSManagedObjectContext *context = [self managedObjectContext];

        Conversation *conversation = [NSEntityDescription insertNewObjectForEntityForName:@"Conversation" inManagedObjectContext:context];
        [conversation addContacts:selectedContacts];

        conversationViewController.conversation = conversation;
    }
}

#pragma mark -

- (void)enableDisableContinueButton {
    if (selectedContacts.count > 0) {
        self.continueButton.enabled = YES;
    } else {
        self.continueButton.enabled = NO;
    }
}

- (UITableView *)tableViewForFetchedResultsController:(NSFetchedResultsController *)controller {
    if (controller == self.fetchedResultsController) {
        return self.tableView;
    } else {
        return self.searchDisplayController.searchResultsTableView;
    }
}

- (NSFetchedResultsController *)fetchedResultsControllerForTableView:(UITableView *)tableView {
    if (tableView == self.tableView) {
        return self.fetchedResultsController;
    } else {
        return [self searchFetchedResultsController];
    }
}

@end
