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

    self.dataSet = @[
                     @{
                         @"name": @"Granville Kilmon",
                         @"messageBody": @"Qui unde voluptas commodi. Quod suscipit impedit temporibus aliquam quo",
                         @"messageState": @(ConversationMessageDelivered),
                         @"messageAlignment": @(ConversationMessageRight)
                         },

                     @{
                         @"name": @"Granville Kilmon",
                         @"messageBody": @"Blanditiis repudiandae doloremque quidem perferendis",
                         @"messageState": @(ConversationMessageDelivered),
                         @"messageAlignment": @(ConversationMessageRight)
                         },

                     @{
                         @"name": @"Erinn Woolum",
                         @"messageBody": @"Iusto omnis qui velit quia aut optio",
                         @"messageAlignment": @(ConversationMessageLeft)
                         },

                     @{
                         @"name": @"Tiffany Austell",
                         @"messageBody": @"Consequatur laborum asperiores",
                         @"messageAlignment": @(ConversationMessageLeft)
                         },

                     @{
                         @"name": @"Granville Kilmon",
                         @"messageBody": @"Voluptatum!",
                         @"messageState": @(ConversationMessageDeliveryFailed),
                         @"messageAlignment": @(ConversationMessageRight)
                         },

                     @{
                         @"name": @"Erinn Woolum",
                         @"messageBody": @"Inventore culpa esse",
                         @"messageAlignment": @(ConversationMessageLeft)
                         },

                     @{
                         @"name": @"Erinn Woolum",
                         @"messageBody": @"Erinn Woolum Qui ut laudantium reprehenderit quisquam optio repellendus voluptatem",
                         @"messageAlignment": @(ConversationMessageLeft)
                         },

                     @{
                         @"name": @"Granville Kilmon",
                         @"messageBody": @"Granville Kilmon Fugiat cum et temporibus assumenda maxime veniam",
                         @"messageState": @(ConversationMessageDelivered),
                         @"messageAlignment": @(ConversationMessageRight)
                         },

                     @{
                         @"name": @"Tiffany Austell",
                         @"messageBody": @"Harum?",
                         @"messageAlignment": @(ConversationMessageLeft)
                         },

                     @{
                         @"name": @"Granville Kilmon",
                         @"messageBody": @"Doloribus iust Iste delectus eaque quibusdam exercitationem soluta",
                         @"messageState": @(ConversationMessageDelivering),
                         @"messageAlignment": @(ConversationMessageRight)
                         }

                    ];

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
    cell.messageAlignment = [cellData[@"messageAlignment"] unsignedIntegerValue];

    [cell layoutSubviews];

    return cell.frame.size.height;
}


@end
