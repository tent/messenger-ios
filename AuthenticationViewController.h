//
//  AuthenticationViewController.h
//  Messages
//
//  Created by Jesse Stuart on 9/26/13.
//  Copyright (c) 2013 Cupcake. All rights reserved.
//

@import UIKit;

@interface AuthenticationViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *entityTextField;
@property (weak, nonatomic) IBOutlet UIButton *signinButton;

@end
