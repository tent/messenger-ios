//
//  Conversation.h
//  Messages
//
//  Created by Jesse Stuart on 7/28/13.
//  Copyright (c) 2013 Boolean Cupcake, LLC. All rights reserved.
//

@import Foundation;
@import CoreData;

@class Contact, Message, TCPostManagedObject, TCParams, TentClient,
    AFHTTPRequestOperation, TCResponseEnvelope;

@interface Conversation : NSManagedObject

@property(nonatomic, retain) NSSet *contacts;
@property(nonatomic, retain) NSSet *messages;
@property(nonatomic, retain) Message *latestMessage;
@property(nonatomic, retain) TCPostManagedObject *conversationPost;

+ (void)persistObjectID:(NSManagedObjectID *)objectID;

+ (void)syncAllConversations;

+ (void)fetchNewMessages;

+ (void)fetchNewMessagesWithClient:(TentClient *)client
                            params:(TCParams *)feedParams
                      successBlock:
                          (void (^)(AFHTTPRequestOperation *operation,
                                    TCResponseEnvelope *responseEnvelope))
    success
                      failureBlock:(void (^)(AFHTTPRequestOperation *operation,
                                             NSError *error))failure
                   completionBlock:(void (^)())completion;

+ (Contact *)contactForEntity:(NSString *)entity error:(NSError **)error;

+ (Conversation *)conversationForPostID:(NSString *)postID
                                  error:(NSError *__autoreleasing *)error;

+ (Message *)messageForPostID:(NSString *)postID
                        error:(NSError *__autoreleasing *)error;

@end

@interface Conversation (CoreDataGeneratedAccessors)

- (void)addContactsObject:(Contact *)value;
- (void)removeContactsObject:(Contact *)value;
- (void)addContacts:(NSSet *)values;
- (void)removeContacts:(NSSet *)values;

- (void)addMessagesObject:(Message *)value;
- (void)removeMessagesObject:(Message *)value;
- (void)addMessages:(NSSet *)values;
- (void)removeMessages:(NSSet *)values;

@end
