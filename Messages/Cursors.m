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

    NSDictionary *relationshipCursor = [tmp objectForKey:@"RelationshipCursor"];

    if (!relationshipCursor) {
        relationshipCursor = @{
                               @"version": @"",
                               @"timestamp": [NSNumber numberWithInteger:0]
                               };
    }

    self.relationshipCursorTimestamp = [NSDate dateWithTimeIntervalSince1970:[[NSNumber numberWithDouble:([((NSNumber *)[relationshipCursor objectForKey:@"timestamp"]) floatValue] / 1000)] integerValue]];

    self.relationshipCursorVersionID = (NSString *)[relationshipCursor objectForKey:@"version"];

    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ <Relationship timestamp=%f version=%@>>", self.class, [self.relationshipCursorTimestamp timeIntervalSince1970] * 1000, self.relationshipCursorVersionID];
}

- (void)saveToPlistWithError:(NSError *__autoreleasing *)error {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Cursors.plist"];

    NSDictionary *relationshipCursor = @{
                                         @"version": self.relationshipCursorVersionID,
                                         @"timestamp": [NSNumber numberWithDouble:([self.relationshipCursorTimestamp timeIntervalSince1970] * 1000)]
                                         };

    NSDictionary *plistDictionary = [NSDictionary dictionaryWithObjects:@[relationshipCursor] forKeys:@[@"RelationshipCursor"]];

    NSData *plistXML = [NSPropertyListSerialization dataFromPropertyList:plistDictionary format:NSPropertyListXMLFormat_v1_0 errorDescription:error];

    if (plistXML) {
        [plistXML writeToFile:plistPath atomically:YES];
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

@end
