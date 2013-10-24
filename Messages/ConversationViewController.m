//
//  ConversationViewController.m
//  Messages
//
//  Created by Jesse on 7/22/13.
//  Copyright (c) 2013 Boolean Cupcake, LLC. All rights reserved.
//

#import "ConversationViewController.h"
#import "ConversationTitleView.h"
#import "ParticipantsViewController.h"
#import "Message.h"
#import "Contact.h"
#import "AppDelegate.h"

@interface ConversationViewController ()
@end

@implementation ConversationViewController

{
    NSManagedObjectContext *managedObjectContext;
    NSFetchedResultsController *fetchedResultsController;
}

- (id)initWithCoder:(NSCoder *)decoder {
    id ret = [super initWithCoder:decoder];

    return ret;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
    [self scrollToBottom];

    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - keyboard

- (void)observeKeyboard {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Begin observing the keyboard notifications when the view is loaded.
    [self observeKeyboard];

    // Dismiss keyboard when tap outside
    UIGestureRecognizer *tapParent = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTableTap:)];
    [self.tableView addGestureRecognizer:tapParent];

    [self performFetch];

    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 60, 0)];

    CGRect frame = CGRectMake(0, 0, 165, 29);
    ConversationTitleView *titleView = [[ConversationTitleView alloc] initWithFrame:frame withDataSource:self];
    [self.navigationItem setTitleView: titleView];

    UIButton *participantsButton = [[UIButton alloc] initWithFrame:titleView.frame];
    [titleView addSubview:participantsButton];
    [titleView bringSubviewToFront:participantsButton];
    [participantsButton addTarget:self action:@selector(participantsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    [self.sendButton addTarget:self action:@selector(sendButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidAppear:(BOOL)animated {
    // Remove ContactsViewController from navigation stack
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    for (UIViewController *c in self.navigationController.viewControllers) {
        if (![[NSString stringWithFormat:@"%@", c.class] isEqual:@"ContactsViewController"]) {
            [viewControllers addObject:c];
        }
    }
    [self.navigationController setViewControllers:(NSArray *)(viewControllers)];
}

// The callback for frame-changing of keyboard
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [kbFrame CGRectValue];
    
    CGFloat height = keyboardFrame.size.height;

    // Because the "space" is actually the difference between the bottom lines of the 2 views,
    // we need to set a negative constant value here.
    self.keyboardHeight.constant = -height;
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
        [self scrollToBottom];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    self.keyboardHeight.constant = 0;
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"loadParticipants"]) {
        ParticipantsViewController *participantsViewController = (ParticipantsViewController *)([segue destinationViewController]);

        participantsViewController.conversationManagedObject = self.conversation;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"conversationCell";
    ConversationViewTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    [self configureCell:cell atIndexPath:indexPath];

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
     This is called for every row in the table before any of the cells are rendered
     and is a temperary solution to style the cells

     TODO: Replace this with something performant!
     */

    ConversationViewTableCell *cell = [[ConversationViewTableCell alloc] init];

    [self configureCell:cell atIndexPath:indexPath];
    [cell setupViews];
    [cell layoutSubviews];

    return cell.frame.size.height;
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    if (action == @selector(copy:)) {
        return YES;
    } else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    if (action == @selector(copy:)) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];

        Message *message = [self.fetchedResultsController objectAtIndexPath:indexPath];

        pasteboard.string = message.body;
    }
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
    [self scrollToBottom];
}

#pragma mark -

- (void)participantsButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"loadParticipants" sender:self];
}

- (NSManagedObjectContext *)managedObjectContext {
    if (!managedObjectContext) {
        managedObjectContext = [(AppDelegate *)([UIApplication sharedApplication].delegate) managedObjectContext];
    }

    return managedObjectContext;
}

- (void)sendButtonPressed:(id)sender {
    NSString *messageText = self.messageTextField.text;

    if ([self.messageTextField isFirstResponder]) {
        [self.messageTextField resignFirstResponder];
    }

    NSManagedObjectContext *context = [self managedObjectContext];
    Message *message = [NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:context];

    message.body = messageText;
    message.conversation = self.conversation;
    message.conversation.latestMessage = message; // TODO: use an observer for this
    message.timestamp = [[NSDate alloc] init];

    NSError *error;
    BOOL success = [context save:&error];

    if (success) {
        self.messageTextField.text = @"";

        [Conversation persistObjectID:self.conversation.objectID];
    } else {
        NSLog(@"failed to save message: %@ error: %@", message, error);
    }
}

- (void)handleTableTap:(id)sender {
    if ([self.messageTextField isFirstResponder]) {
        [self.messageTextField resignFirstResponder];
    }
}

- (NSFetchedResultsController *)fetchedResultsController {

    if (fetchedResultsController) {
        return fetchedResultsController;
    }

    NSManagedObjectContext *context = [self managedObjectContext];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Message"];

    // Configure the request's entity, and optionally its predicate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"conversation == %@", self.conversation];
    [fetchRequest setPredicate:predicate];

    fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    fetchedResultsController.delegate = self;

    return fetchedResultsController;
}

- (void)performFetch {
    NSError *error;
    [[self fetchedResultsController] performFetch:&error];
}

- (void)configureCell:(ConversationViewTableCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Message *message = [self.fetchedResultsController objectAtIndexPath:indexPath];

    cell.name = message.contact.name;
    cell.messageBody = message.body;
    // cell.messageState = message.state;
    cell.messageAlignment = [message getAlignment];
}

- (void)scrollToBottom {
    if (self.tableView.contentSize.height > self.tableView.bounds.size.height) {
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height - self.tableView.bounds.size.height + 60) animated:NO];
    }
}

@end
