//
//  ConversationViewController.m
//  Messages
//
//  Created by Jesse on 7/22/13.
//  Copyright (c) 2013 Cupcake. All rights reserved.
//

#import "ConversationViewController.h"
#import "ConversationTitleView.h"

@interface ConversationViewController ()
@end

@implementation ConversationViewController

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

    [self.tableView setDataSource:self.tableDataSource];
    [self.tableView setDelegate:self.tableDataSource];
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 60, 0)];


    CGRect frame = CGRectMake(0, 0, 165, 29);
    ConversationTitleView *titleView = [[ConversationTitleView alloc] initWithFrame:frame];
    [self.navigationItem setTitleView: titleView];
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

@end
