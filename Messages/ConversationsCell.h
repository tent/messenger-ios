//
//  ConversationsCell.h
//  Messages
//
//  Created by Jesse on 7/25/13.
//  Copyright (c) 2013 Cupcake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Conversation.h"

@interface ConversationsCell : UITableViewCell
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *messageBody;
@property (nonatomic) NSString *timestamp;
@property (nonatomic) Conversation *conversation;
@end
