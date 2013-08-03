//
//  RootNavigationController.m
//  Messages
//
//  Created by Jesse on 7/20/13.
//  Copyright (c) 2013 Cupcake. All rights reserved.
//

#import "RootNavigationController.h"
#import "MessagesAesthetics.h"

@interface RootNavigationController ()

@end

@implementation RootNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationBar.barTintColor = [MessagesAesthetics lightBlueColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
