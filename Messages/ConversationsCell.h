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

{
    NSArray *contacts;
}

@property (nonatomic) Conversation *conversation;

- (void)initConversation:(Conversation *)conversation;
@end
