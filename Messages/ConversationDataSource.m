//
//  ConversationDataSource.m
//  Messages
//
//  Created by Jesse on 7/22/13.
//  Copyright (c) 2013 Cupcake. All rights reserved.
//

#import "ConversationDataSource.h"
#import "ConversationViewTableCell.h"

@implementation ConversationDataSource

- (id)init
{
    id ret = [super init];

    self.dataSet = @[ @{@"name": @"Ingeborg Chmielewski", @"messageBody": @"The quick brown fox jumps over the lazy dog! The slow red dog is lazy.", @"messageState": @(ConversationMessageDelivered), @"messageAlignment": @(ConversationMessageLeft)}, @{@"name": @"Howard Trembley", @"messageBody": @"More is less", @"messageState": @(ConversationMessageDelivering), @"messageAlignment": @(ConversationMessageLeft)}, @{@"name": @"Yadira Yarnell", @"messageBody": @"We can only do our best", @"messageState": @(ConversationMessageDeliveryFailed), @"messageAlignment": @(ConversationMessageRight)} ];

    return ret;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"conversationCell";
    ConversationViewTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    int dataIndex = [indexPath indexAtPosition:1];
    NSDictionary *cellData = [self.dataSet objectAtIndex:dataIndex];

    cell.name = cellData[@"name"];
    cell.messageBody = cellData[@"messageBody"];
    cell.messageState = [cellData[@"messageState"] unsignedIntegerValue];
    cell.messageAlignment = [cellData[@"messageAlignment"] unsignedIntegerValue];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSet.count;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     This is called for every row in the table before any of the cells are rendered
     and is a temperary solution to style the cells

     TODO: Replace this with something performant!
     */

    ConversationViewTableCell *cell = [[ConversationViewTableCell alloc] init];

    int dataIndex = [indexPath indexAtPosition:1];
    NSDictionary *cellData = [self.dataSet objectAtIndex:dataIndex];

    cell.name = cellData[@"name"];
    cell.messageBody = cellData[@"messageBody"];
    cell.messageState = [cellData[@"messageState"] unsignedIntegerValue];

    [cell layoutSubviews];

    return cell.frame.size.height;
}


@end
