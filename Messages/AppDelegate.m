//
//  AppDelegate.m
//  Messages
//
//  Created by Jesse on 7/20/13.
//  Copyright (c) 2013 Boolean Cupcake, LLC. All rights reserved.
//

#import "AppDelegate.h"
#import "Contact.h"
#import "Conversation.h"
#import "TCPost+CoreData.h"

@implementation AppDelegate

{
    NSManagedObjectID *currentAppPostObjectID;

    int numNetworkActivityRequests;
    NSLock *numNetworkActivityRequestsLock;
    NSLock *saveCursorsLock;
}

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(__unused UIApplication *)application didFinishLaunchingWithOptions:(__unused NSDictionary *)launchOptions
{
    self.cursors = [[Cursors alloc] init];

    return YES;
}

- (BOOL)application:(__unused UIApplication *)application openURL:(NSURL *)url sourceApplication:(__unused NSString *)sourceApplication annotation:(__unused id)annotation {
    if (self.authCallbackBlock) {
        self.authCallbackBlock(url);

        self.authCallbackBlock = nil;

        return YES;
    } else {
        return NO;
    }
}

- (void)applicationWillResignActive:(__unused UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(__unused UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

    NSError *saveCursorsError;
    [self.cursors saveToPlistWithError:&saveCursorsError];

    if (saveCursorsError) {
        NSLog(@"Error saving cursors: %@", saveCursorsError);
    }
}

- (void)applicationWillEnterForeground:(__unused UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

    self.cursors = [[Cursors alloc] init];
}

- (void)applicationDidBecomeActive:(__unused UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(__unused UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

    NSError *saveCursorsError;
    [self.cursors saveToPlistWithError:&saveCursorsError];

    if (saveCursorsError) {
        NSLog(@"Error saving cursors: %@", saveCursorsError);
    }
}

- (BOOL)saveContext:(NSManagedObjectContext *)context error:(NSError *__autoreleasing *)error {
    __block BOOL didSave = YES;

    if (![context hasChanges]) return YES;

    if ([context save:error]) {
        NSManagedObjectContext *mainContext = [self mainManagedObjectContext];

        if (context != mainContext) {
            [mainContext performBlockAndWait:^{
                if (![mainContext save:error]) {
                    didSave = NO;
                }
            }];
        }
    } else {
        didSave = NO;
    }

    if (!didSave) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", *error, [*error userInfo]);
        abort();
    }

    return didSave;
}

#pragma mark - Core Data stack

- (NSManagedObjectContext *)mainManagedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }

    return _managedObjectContext;
}

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *mainContext = [self mainManagedObjectContext];

    if ([NSThread isMainThread]) {
        return mainContext;
    } else {
        NSManagedObjectContext *context = [[[NSThread currentThread] threadDictionary] objectForKey:@"managedObjectContext"];

        if (!context) {
            context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSConfinementConcurrencyType];
            context.parentContext = mainContext;
        }

        return context;
    }
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DataModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }

    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"DataModel.sqlite"];

    // Copy default database (silently fail if it doesn't exist)
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:storeURL.path]) {
        NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"DataModel" ofType:@"sqlite"];
        if (defaultStorePath) {
            [fileManager copyItemAtPath:defaultStorePath toPath:storeURL.path error:NULL];
        }
    }

    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.

         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.


         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.

         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]

         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}

         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.

         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark -

- (void)applicationAuthenticated {
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];

    [operationQueue addOperationWithBlock:^{
        [Contact syncRelationships];

        NSLog(@"syncRelationshipsInvocation complete");

        // Fetch messages after relationship sync is finished
        [operationQueue addOperationWithBlock:^{
            NSLog(@"fetchNewMessagesInvocation start");

            [Conversation fetchNewMessages];

            NSLog(@"fetchNewMessagesInvocation complete");
        }];
    }];
}

- (void)applicationDeauthenticated {
    __block NSError *error;

    // Delete Data from Core Data entities

    NSArray *entityNames = @[
                          @"Contact",
                          @"Conversation",
                          @"Message",
                          @"TCAppPost",
                          @"TCCredentialsPost",
                          @"TCMetaPost",
                          @"TCMetaPostServer",
                          @"TCPost"
                          ];

    // Prevent deletes from propagating to Tent server
    [self unsetCurrentAppPost];

    NSManagedObjectContext *context = [self managedObjectContext];

    [entityNames enumerateObjectsUsingBlock:^(NSString *entityName, __unused NSUInteger idx, __unused BOOL *stop) {

        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];

        NSArray *items = [context executeFetchRequest:fetchRequest error:&error];

        if (error) {
            NSLog(@"error fetching %@: %@", entityName, error);
        }

        [items enumerateObjectsUsingBlock:^(NSManagedObject *managedObject, __unused NSUInteger _idx, __unused BOOL *_stop) {
            [context deleteObject:managedObject];
        }];

    }];

    // Persist deletes
    if (![context save:&error]) {
        NSLog(@"Error deleting records from core data: %@", error);
    }

    // Delete Cursors

    [self.cursors deletePlistWithError:&error];

    if (error) {
        NSLog(@"error deleting cursor: %@", error);
    }

    // Set new cursors object

    self.cursors = [[Cursors alloc] init];
}

- (TCMetaPost *)fetchMetaPostForEntity:(NSString *)entity error:(NSError *__autoreleasing *)error {
    TCMetaPost *metaPost;

    NSManagedObjectContext *context = [self managedObjectContext];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"TCMetaPost"];

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
        metaPost = [MTLManagedObjectAdapter modelOfClass:TCMetaPost.class fromManagedObject:appPostManagedObject error:error];
    } else {
        if (error) {
            *error = [[NSError alloc] initWithDomain:@"Meta post not found" code:1 userInfo:nil];
        }
    }

    return metaPost;
}

- (TCAppPost *)currentAppPost {
    if (!currentAppPostObjectID) return nil;

    NSManagedObject *appPostManagedObject = [[self mainManagedObjectContext] objectWithID:currentAppPostObjectID];

    if (!appPostManagedObject) return nil;

    return (TCAppPost *)[MTLManagedObjectAdapter modelOfClass:TCAppPost.class fromManagedObject:appPostManagedObject error:nil];
}

- (void)setCurrentAppPost:(TCAppPost *)appPost {
    NSManagedObject *appPostManagedObject = [MTLManagedObjectAdapter managedObjectFromModel:appPost insertingIntoContext:[self managedObjectContext] error:nil];

    currentAppPostObjectID = appPostManagedObject.objectID;
}

- (void)unsetCurrentAppPost {
    currentAppPostObjectID = nil;
}

- (NSLock *)saveCursorsLock {
    if (!saveCursorsLock) {
        saveCursorsLock = [[NSLock alloc] init];
    }

    return saveCursorsLock;
}

#pragma mark - Network Activity Indicator

- (NSLock *)numNetworkActivityRequestsLock {
    if (!numNetworkActivityRequestsLock) {
        numNetworkActivityRequestsLock = [[NSLock alloc] init];
    }

    return numNetworkActivityRequestsLock;
}

- (void)showNetworkActivityIndicator {
    [[self numNetworkActivityRequestsLock] lock];

    if (!numNetworkActivityRequests) {
        numNetworkActivityRequests = 1;
    } else {
        numNetworkActivityRequests += 1;
    }

    if (numNetworkActivityRequests > 0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }

    [[self numNetworkActivityRequestsLock] unlock];
}

- (void)hideNetworkActivityIndicator {
    [[self numNetworkActivityRequestsLock] lock];

    if (!numNetworkActivityRequests) {
        numNetworkActivityRequests = 0;
    } else {
        numNetworkActivityRequests -= 1;
    }

    if (numNetworkActivityRequests <= 0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }

    [[self numNetworkActivityRequestsLock] unlock];
}

@end
