//
//  AppDelegate.h
//  Messages
//
//  Created by Jesse on 7/20/13.
//  Copyright (c) 2013 Boolean Cupcake, LLC. All rights reserved.
//

#import "TentClient.h"
#import "Cursors.h"

@import UIKit;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic) Cursors *cursors;

- (NSManagedObjectContext *)mainManagedObjectContext;

- (BOOL)saveContext:(NSManagedObjectContext *)context error:(NSError *__autoreleasing *)error;

- (NSURL *)applicationDocumentsDirectory;

- (void)applicationAuthenticated;

- (void)applicationDeauthenticated;

- (TCMetaPost *)fetchMetaPostForEntity:(NSString *)entity error:(NSError *__autoreleasing *)error;

- (TCAppPost *)currentAppPost;

- (void)setCurrentAppPost:(TCAppPost *)appPost;

#pragma mark - Network Activity Indicator

- (void)showNetworkActivityIndicator;

- (void)hideNetworkActivityIndicator;

@end
