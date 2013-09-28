//
//  ParticipantsViewController.m
//  Messages
//
//  Created by Jesse on 7/25/13.
//  Copyright (c) 2013 Boolean Cupcake, LLC. All rights reserved.
//

#import "ParticipantsViewController.h"
#import "UIImage+Resize.h"
#import "AppDelegate.h"
#import "Contact.h"

@interface ParticipantsViewController ()

@end

@implementation ParticipantsViewController

{
    NSArray *participants;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    id ret = [super initWithCoder:decoder];

    return ret;
}

- (void)viewDidLoad {
    participants = [self.conversationManagedObject.contacts.allObjects sortedArrayUsingComparator:^(Contact *obj1, Contact *obj2) {
        NSString *name1 = obj1.name;
        NSString *name2 = obj2.name;

        return [name1 caseInsensitiveCompare:name2];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return participants.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"participantCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    Contact *contact = [participants objectAtIndex:[indexPath indexAtPosition:1]];

    cell.textLabel.text = contact.name;
    cell.multipleSelectionBackgroundView = [[UIView alloc] init];

    UIImage *avatar = [UIImage imageWithData:contact.avatar];
    avatar = [avatar thumbnailImage:40 transparentBorder:0 cornerRadius:3 interpolationQuality:kCGInterpolationHigh];

    cell.imageView.image = avatar;

    return cell;
}

@end
