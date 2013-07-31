//
//  ParticipantsViewController.h
//  Messages
//
//  Created by Jesse on 7/25/13.
//  Copyright (c) 2013 Cupcake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Conversation.h"

@interface ParticipantsViewController : UITableViewController

{
    NSArray *participants;
}

@property (nonatomic) Conversation *conversationManagedObject;
@end
