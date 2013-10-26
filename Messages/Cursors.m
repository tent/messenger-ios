//
//  Cursors.m
//  Messages
//
//  Created by Jesse Stuart on 10/5/13.
//  Copyright (c) 2013 Boolean Cupcake, LLC. All rights reserved.
//

#import "Cursors.h"
#import "Mantle.h"

@implementation Cursors

- (instancetype)init {
    self = [super init];

    if (!self) return nil;

    // Read Cursors.plist

    NSString *error = nil;
    NSPropertyListFormat format;

    // Look in Documents
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Cursors.plist"];

    // Look in application Resources if not in Documents
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource:@"Cursors" ofType:@"plist"];
    }

    // Read plist data
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];

    // Deserialize plist data
    NSDictionary *tmp = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&error];

    if (error) {
        NSLog(@"Error reading plist: %@, format: %d", error, format);
    }

    // Relationship Cursor

    NSDictionary *relationshipCursor = [tmp objectForKey:@"RelationshipCursor"];

    if (!relationshipCursor) {
        relationshipCursor = @{
                               @"version": @"",
                               @"timestamp": [NSNumber numberWithInteger:0]
                               };
    }

    self.relationshipCursorTimestamp = [self deserializeTimestamp:(NSNumber *)[relationshipCursor objectForKey:@"timestamp"]];

    self.relationshipCursorVersionID = (NSString *)[relationshipCursor objectForKey:@"version"];

    // Message Cursor

    NSDictionary *messageCursor = [tmp objectForKey:@"MessageCursor"];

    if (!messageCursor) {
        messageCursor = @{
                          @"version": @"",
                          @"timestamp": [NSNumber numberWithInteger:0]
                          };
    }

    self.messageCursorTimestamp = [self deserializeTimestamp:(NSNumber *)[messageCursor objectForKey:@"timestamp"]];

    self.messageCursorVersionID = (NSString *)[messageCursor objectForKey:@"version"];

    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ <Relationship timestamp=%f version=%@>>", self.class, [self.relationshipCursorTimestamp timeIntervalSince1970] * 1000, self.relationshipCursorVersionID];
}

- (BOOL)saveToPlistWithError:(NSError *__autoreleasing *)error {
    // Relationship Cursor

    NSDictionary *relationshipCursor = @{
                                         @"version": self.relationshipCursorVersionID,
                                         @"timestamp": [self serializeTimestamp:self.relationshipCursorTimestamp]
                                         };

    // Message Cursor
   
    NSDictionary *messageCursor = @{
                                    @"version": self.messageCursorVersionID,
                                    @"timestamp": [self serializeTimestamp:self.messageCursorTimestamp]
                                    };

    // Save plist

    NSDictionary *plistDictionary = [NSDictionary dictionaryWithObjects:@[relationshipCursor, messageCursor] forKeys:@[@"RelationshipCursor", @"MessageCursor"]];

    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Cursors.plist"];

    NSString *errorDescription;

    NSData *plistXML = [NSPropertyListSerialization dataFromPropertyList:plistDictionary format:NSPropertyListXMLFormat_v1_0 errorDescription:&errorDescription];

    if (errorDescription && error != NULL) {
        *error = [NSError errorWithDomain:errorDescription code:1 userInfo:nil];
    }

    if (plistXML) {
        [plistXML writeToFile:plistPath atomically:YES];
    }

    if (error) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)deletePlistWithError:(NSError *__autoreleasing *)error {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Cursors.plist"];

    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        // Nothing to delete
        return YES;
    }

    return [[NSFileManager defaultManager] removeItemAtPath:plistPath error:error];
}

- (NSString *)stringFromTimestamp:(NSDate *)timestamp version:(NSString *)version {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSString *res = [formatter stringFromNumber:[self serializeTimestamp:timestamp]];

    if (![version isEqualToString:@""]) {
        return [res stringByAppendingString:[NSString stringWithFormat:@" %@", version]];
    } else {
        return res;
    }
}

- (NSDate *)deserializeTimestamp:(NSNumber *)timestamp {
    return [NSDate dateWithTimeIntervalSince1970:[[NSNumber numberWithDouble:([timestamp floatValue] / 1000)] integerValue]];
}

- (NSNumber *)serializeTimestamp:(NSDate *)timestamp {
    return [NSNumber numberWithDouble:([timestamp timeIntervalSince1970] * 1000)];
}

@end
