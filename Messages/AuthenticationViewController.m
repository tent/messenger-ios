//
//  AuthenticationViewController.m
//  Messages
//
//  Created by Jesse Stuart on 9/26/13.
//  Copyright (c) 2013 Boolean Cupcake, LLC. All rights reserved.
//

#import "AuthenticationViewController.h"
#import "AppDelegate.h"
#import "TCPost+CoreData.h"

@import CoreData;

@interface AuthenticationViewController ()

@end

@implementation AuthenticationViewController

{
    NSManagedObjectContext *managedObjectContext;
}

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

- (TCAppPost *)appPostForEntity:(NSString *)entity error:(NSError **)error {
    TCAppPost *appPost;

    NSManagedObjectContext *context = [self managedObjectContext];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"TCAppPost"];

    // Configure sort order
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"clientReceivedAt" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"entityURI == %@", entity];
    [fetchRequest setPredicate:predicate];

    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];

    [fetchedResultsController performFetch:error];

    TCAppPostManagedObject *appPostManagedObject;

    if ([fetchedResultsController.fetchedObjects count] > 0) {
        appPostManagedObject = [fetchedResultsController.fetchedObjects objectAtIndex:0];
    }

    if ([appPostManagedObject isKindOfClass:TCAppPostManagedObject.class]) {
        appPost = [MTLManagedObjectAdapter modelOfClass:TCAppPost.class fromManagedObject:appPostManagedObject error:error];
    } else {
        appPost = [[TCAppPost alloc] init];

        appPost.typeURI = @"https://tent.io/types/app/v0#";
        appPost.name = @"Messenger iOS";
        appPost.appDescription = @"Private messenger app for iOS 7+";
        appPost.URL = [NSURL URLWithString:@"https://github.com/cupcake/messenger-ios"];
        appPost.redirectURI = [NSURL URLWithString:@"tentmessengerapp://oauth/callback"];
        appPost.writeTypes = @[
                               @"https://tent.io/types/conversation/v0",
                               @"https://tent.io/types/message/v0"
                               ];
    }

    return appPost;
}

- (void)persistAppPost:(TCAppPost *)appPost error:(NSError **)error {
    NSManagedObjectContext *context = [self managedObjectContext];

    TCAppPostManagedObject *appManagedObject = (TCAppPostManagedObject *)[MTLManagedObjectAdapter managedObjectFromModel:appPost insertingIntoContext:context error:error];

    [context save:error];
}

- (void)signinButtonPressed:(id)sender {
    NSURL *entityURI = [NSURL URLWithString:self.entityTextField.text];
    TentClient *client = [TentClient clientWithEntity:entityURI];
    self.client = client;

    __block NSError *error;
    TCAppPost *appPost = [self appPostForEntity:[entityURI absoluteString] error:&error];

    if (error) {
        // TODO: Inform user of error
        return;
    }

    [client authenticateWithApp:appPost successBlock:^(TCAppPost *appPost, TCCredentialsPost *authCredentialsPost) {
        [self persistAppPost:appPost error:&error];

        // TODO: Open ConversationsViewController
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        // TODO: Inform user of error
    } viewController:self];
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

- (NSManagedObjectContext *)managedObjectContext {
    if (!managedObjectContext) {
        managedObjectContext = [(AppDelegate *)([UIApplication sharedApplication].delegate) managedObjectContext];
    }

    return managedObjectContext;
}

#pragma mark - UITextFieldDelegate

@end
