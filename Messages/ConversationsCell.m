//
//  ConversationsCell.m
//  Messages
//
//  Created by Jesse on 7/25/13.
//  Copyright (c) 2013 Cupcake. All rights reserved.
//

#import "ConversationsCell.h"

@implementation ConversationsCell

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect imageFrame = self.imageView.frame;
    imageFrame.origin.x = self.frame.origin.x + 10;
    self.imageView.frame = imageFrame;

    CGRect contentFrame = CGRectMake(imageFrame.origin.x + imageFrame.size.width + 5, imageFrame.origin.y, self.frame.size.width - imageFrame.origin.x - imageFrame.size.width - 13, imageFrame.size.height);
    UIView *contentView = [[UIView alloc] initWithFrame:contentFrame];

    UILabel *timeView = [[UILabel alloc] initWithFrame:CGRectMake(contentFrame.size.width - 60, 0, 60, 20)];
    UILabel *nameView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, contentFrame.size.width - timeView.frame.size.width - 5, 20)];
    UILabel *bodyView = [[UILabel alloc] initWithFrame:CGRectMake(0, nameView.frame.origin.y + nameView.frame.size.height, contentFrame.size.width, contentFrame.size.height - nameView.frame.origin.y - nameView.frame.size.height - 5)];

    timeView.text = self.timestamp;
    nameView.text = self.name;
    bodyView.text = self.messageBody;

    timeView.textAlignment = NSTextAlignmentRight;

    [timeView setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    timeView.textColor = [[UIColor alloc] initWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];

    [nameView setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:15]];
    nameView.textColor = [[UIColor alloc] initWithRed:2/255.0 green:116/255.0 blue:210/255.0 alpha:1];

    [bodyView setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    bodyView.textColor = [[UIColor alloc] initWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    bodyView.numberOfLines = 2;

    [contentView addSubview:nameView];
    [contentView addSubview:timeView];
    [contentView addSubview:bodyView];

    [self addSubview:contentView];
}

@end
