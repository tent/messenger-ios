//
//  ConversationsViewController.m
//  Messages
//
//  Created by Jesse on 7/20/13.
//  Copyright (c) 2013 Boolean Cupcake, LLC. All rights reserved.
//

#import "ConversationsViewController.h"
#import "ConversationViewController.h"
#import "AuthenticationViewController.h"
#import "AppDelegate.h"
#import "Conversation.h"

@interface ConversationsViewController ()

@end

@implementation ConversationsViewController

{
    NSArray *conversations;
    NSManagedObjectContext *managedObjectContext;
    Conversation *selectedConversation;
}

- (NSManagedObjectContext *)managedObjectContext {
    if (!managedObjectContext) {
        managedObjectContext = [(AppDelegate *)([UIApplication sharedApplication].delegate) managedObjectContext];
    }

    return managedObjectContext;
}

- (void)setupFetchedResultsController {
    NSManagedObjectContext *context = [self managedObjectContext];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Conversation"];

    // Configure the request's entity, and optionally its predicate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"latestMessage.timestamp" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"contacts.@count > 0"];
    [fetchRequest setPredicate:predicate];

    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:@"Conversations"];

    self.fetchedResultsController.delegate = self;

    NSError *error;
    [self.fetchedResultsController performFetch:&error];
}

- (void)handleConversationTap:(id)sender {
    UITapGestureRecognizer *tapGestureRecognizer = sender;
    ConversationsCell *cell = (ConversationsCell *)tapGestureRecognizer.view;
    selectedConversation = cell.conversation;


    if (cell.editing) {
        cell.selected = !cell.selected;
        if (cell.selected) {
            [self.selectedIndexPaths addObject:cell.indexPath];
        } else {
            [self.selectedIndexPaths removeObject:cell.indexPath];
        }
    } else {
        [self performSegueWithIdentifier:@"loadConversation" sender:self];
    }
}

- (id)initWithCoder:(NSCoder *)decoder
{
    id ret = [super initWithCoder:decoder];

    return ret;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:<#(SEL)#>];

    [self setupFetchedResultsController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

- (BOOL)tableView:(__unused UITableView *)tableView shouldHighlightRowAtIndexPath:(__unused NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)tableView:(__unused UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(__unused NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - Table view data source

    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
- (NSInteger)tableView:(__unused UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"conversationCell";
    ConversationsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    Conversation *conversation = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell initConversation:conversation];

    UIGestureRecognizer *tapParent = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleConversationTap:)];
    [cell addGestureRecognizer:tapParent];

    cell.tableViewController = self;
    cell.indexPath = indexPath;

    return cell;
}

- (void)tableView:(__unused UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ConversationsCell *cell = (ConversationsCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [[self managedObjectContext] deleteObject:cell.conversation];

        NSError *error;
        [[self managedObjectContext] save:&error];
    }
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(__unused NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(__unused id)sender
{
    if ([segue.identifier isEqualToString:@"loadConversation"]) {
        ConversationViewController *conversationViewController = (ConversationViewController *)([segue destinationViewController]);
        conversationViewController.conversation = selectedConversation;
    }
}

#pragma mark - IBAction

- (IBAction)accountsButtonPressed:(__unused id)sender {
    [self performSegueWithIdentifier:@"accountsSegue" sender:self];
}

- (IBAction)actionButtonPressed:(__unused id)sender {
    [self performSegueWithIdentifier:@"newMessage" sender:self];
}

#pragma mark -

@end
