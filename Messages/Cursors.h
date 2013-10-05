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

- (void)saveToPlistWithError:(NSError **)error;

@end
