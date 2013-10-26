//
//  Cursors.h
//  Messages
//
//  Created by Jesse Stuart on 10/5/13.
//  Copyright (c) 2013 Boolean Cupcake, LLC. All rights reserved.
//

@import Foundation;

@interface Cursors : NSObject

@property (copy, nonatomic) NSDate *relationshipCursorTimestamp;
@property (copy, nonatomic) NSString *relationshipCursorVersionID;

@property (copy, nonatomic) NSDate *messageCursorTimestamp;
@property (copy, nonatomic) NSString *messageCursorVersionID;

- (BOOL)saveToPlistWithError:(NSError **)error;

- (BOOL)deletePlistWithError:(NSError **)error;

- (NSString *)stringFromTimestamp:(NSDate *)timestamp version:(NSString *)version;

- (NSDate *)deserializeTimestamp:(NSNumber *)timestamp;

- (NSNumber *)serializeTimestamp:(NSDate *)timestamp;

@end
