//
//  ConversationDataSource.h
//  Messages
//
//  Created by Jesse on 7/22/13.
//  Copyright (c) 2013 Cupcake. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConversationDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSArray *dataSet;
@end
