//
//  ParticipantsViewController.h
//  Messages
//
//  Created by Jesse on 7/25/13.
//  Copyright (c) 2013 Cupcake. All rights reserved.
//

@import UIKit;
#import "Conversation.h"

@interface ParticipantsViewController : UITableViewController

@property (nonatomic) Conversation *conversationManagedObject;
@end
