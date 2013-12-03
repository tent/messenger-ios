//
//  ParticipantsViewController.h
//  Messages
//
//  Created by Jesse on 7/25/13.
//  Copyright (c) 2013 Boolean Cupcake, LLC. All rights reserved.
//

@import UIKit;
#import "Conversation.h"

@interface ParticipantsViewController : UITableViewController

@property(nonatomic) Conversation *conversationManagedObject;
@end
