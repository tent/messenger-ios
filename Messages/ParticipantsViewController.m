//
//  ParticipantsViewController.m
//  Messages
//
//  Created by Jesse on 7/25/13.
//  Copyright (c) 2013 Cupcake. All rights reserved.
//

#import "ParticipantsViewController.h"
#import "UIImage+Resize.h"

@interface ParticipantsViewController ()

@end

@implementation ParticipantsViewController

- (id)initWithCoder:(NSCoder *)decoder
{
    id ret = [super initWithCoder:decoder];

    participantNames = @[@"Agatha Salvato", @"Concetta Turmelle", @"Drema Rushin", @"Howard Trembley", @"Myong Forsman", @"Tiffany Austell"];

    return ret;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return participantNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"participantCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    cell.textLabel.text = [participantNames objectAtIndex:([indexPath indexAtPosition:0] * 2) + [indexPath indexAtPosition:1]];
    cell.multipleSelectionBackgroundView = [[UIView alloc] init];

    UIImage *avatar = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", ([indexPath indexAtPosition:0] * 2) + [indexPath indexAtPosition:1] + 1]];
    avatar = [avatar thumbnailImage:40 transparentBorder:0 cornerRadius:3 interpolationQuality:kCGInterpolationHigh];

    cell.imageView.image = avatar;

    return cell;
}

@end
