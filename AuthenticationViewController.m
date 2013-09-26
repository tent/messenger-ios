//
//  AuthenticationViewController.m
//  Messages
//
//  Created by Jesse Stuart on 9/26/13.
//  Copyright (c) 2013 Cupcake. All rights reserved.
//

#import "AuthenticationViewController.h"

@interface AuthenticationViewController ()

@end

@implementation AuthenticationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Dismiss keyboard when tap outside
    UIGestureRecognizer *tapParent = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard:)];
    [self.view addGestureRecognizer:tapParent];

    // Set keyboard type
    self.entityTextField.keyboardType = UIKeyboardTypeURL;

    // Set text field delegate
    self.entityTextField.delegate = self;

    // Set sign in button action
    [self.signinButton addTarget:self action:@selector(signinButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    // Disable sign in button initially
    self.signinButton.enabled = NO;

    // Get notified when text field content changes
    [self.entityTextField addTarget:self action:@selector(entityTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissKeyboard:(id)sender {
    if ([self.entityTextField isFirstResponder]) {
        [self.entityTextField resignFirstResponder];
    }
}

- (void)signinButtonPressed:(id)sender {
    NSLog(@"signin button pressed");
}

- (void)entityTextFieldChanged:(id)sender {
    if ([self validateEntityTextField]) {
        self.signinButton.enabled = YES;
    } else {
        self.signinButton.enabled = NO;
    }
}

- (BOOL)validateEntityTextField {
    NSURL *entityURI = [NSURL URLWithString:self.entityTextField.text];

    if (entityURI && entityURI.scheme && entityURI.host) {
        return YES;
    }

    return NO;
}

#pragma mark - UITextFieldDelegate

@end
