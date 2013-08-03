//
//  ParticipantTableCell.m
//  Messages
//
//  Created by Jesse on 7/25/13.
//  Copyright (c) 2013 Cupcake. All rights reserved.
//

#import "ParticipantTableCell.h"
#import "MessagesAesthetics.h"

@implementation ParticipantTableCell

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect imageFrame = self.imageView.frame;
    imageFrame.origin.x = self.frame.origin.x + 10;
    self.imageView.frame = imageFrame;

    CGRect textFrame = self.textLabel.frame;
    textFrame.origin.x = imageFrame.origin.x + imageFrame.size.width + 10;
    self.textLabel.frame = textFrame;

    self.textLabel.textColor = [MessagesAesthetics blueColor];

    [MessagesAesthetics setFontForLabel:self.textLabel withSize:MessagesAestheticsFontSizeLarge withWeight:MessagesAestheticsFontWeightMedium];

    CGRect detailTextFrame = self.detailTextLabel.frame;
    detailTextFrame.origin.x += 10;
    self.detailTextLabel.frame = detailTextFrame;
}

@end
