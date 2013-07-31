//
//  ConversationViewController.m
//  Messages
//
//  Created by Jesse on 7/22/13.
//  Copyright (c) 2013 Cupcake. All rights reserved.
//

#import "ConversationViewController.h"
#import "ConversationTitleView.h"
#import "ParticipantsViewController.h"
#import "Message.h"

@interface ConversationViewController ()
@end

@implementation ConversationViewController

- (void)participantsButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:@"loadParticipants" sender:self];
}

- (void)sendButtonPressed:(id)sender {
    NSString *messageText = self.messageTextField.text;

    NSManagedObjectContext *context = [self.tableDataSource managedObjectContext];
    Message *message = [NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:context];

    message.body = messageText;
    message.conversation = self.tableDataSource.conversationManagedObject;
    message.conversation.latestMessage = message; // TODO: use an observer for this
    message.timestamp = [[NSDate alloc] init];

    NSError *error;
    BOOL success = [context save:&error];

    if (success) {
        self.messageTextField.text = @"";

        NSLog(@"new message: %@", message);
    } else {
        NSLog(@"failed to save message: %@ error: %@", message, error);
    }
}

- (id)initWithCoder:(NSCoder *)decoder
{
    id ret = [super initWithCoder:decoder];

    self.tableDataSource = [[ConversationDataSource alloc] init];

    return ret;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)observeKeyboard {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Begin observing the keyboard notifications when the view is loaded.
    [self observeKeyboard];

    [self.tableDataSource setupFetchedResultsController];

    [self.tableView setDataSource:self.tableDataSource];
    [self.tableView setDelegate:self.tableDataSource];
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 60, 0)];

    CGRect frame = CGRectMake(0, 0, 165, 29);
    ConversationTitleView *titleView = [[ConversationTitleView alloc] initWithFrame:frame withDataSource:self.tableDataSource];
    [self.navigationItem setTitleView: titleView];

    UIButton *participantsButton = [[UIButton alloc] initWithFrame:titleView.frame];
    [titleView addSubview:participantsButton];
    [titleView bringSubviewToFront:participantsButton];
    [participantsButton addTarget:self action:@selector(participantsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    [self.sendButton addTarget:self action:@selector(sendButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height - self.tableView.bounds.size.height + 60) animated:YES];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"loadParticipants"]) {
        ParticipantsViewController *participantsViewController = (ParticipantsViewController *)([segue destinationViewController]);

        Conversation *conversation = [self.tableDataSource conversationManagedObject];

        participantsViewController.conversationManagedObject = conversation;
    }
}

@end
