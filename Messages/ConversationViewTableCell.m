//
//  ConversationViewTableCell.m
//  Messages
//
//  Created by Jesse on 7/23/13.
//  Copyright (c) 2013 Cupcake. All rights reserved.
//

#import "ConversationViewTableCell.h"

@implementation ConversationViewTableCell

#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];

    // message bubble
    CGRect bubbleViewFrame = [self getBubbleFrameForSide];
    UIView *bubbleView = [[UIView alloc] initWithFrame:bubbleViewFrame];

    [bubbleView.layer setCornerRadius:3];
    bubbleView.backgroundColor = [self getBubbleBackgroundColor];

    int offsetY = 0;
    int offsetX = 10;
    int width = bubbleView.frame.size.width - (offsetX * 2);

    // name
    UILabel *nameView = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, offsetY + 11, width, 0)];
    nameView.text = self.name;
    nameView.textColor = [[UIColor alloc] initWithRed:2/255.0 green:116/255.0 blue:210/255.0 alpha:1];
    [nameView setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:11]];
    [nameView sizeToFit];

    CGRect frame = nameView.frame;
    offsetY = frame.origin.y + frame.size.height;

    // message body
    UILabel *messageBodyView = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, offsetY + 5, width, 0)];
    messageBodyView.lineBreakMode = NSLineBreakByWordWrapping;
    messageBodyView.text = self.messageBody;
    messageBodyView.numberOfLines = 0;
    [messageBodyView setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    [messageBodyView sizeToFit];

    frame = messageBodyView.frame;
    offsetY = frame.origin.y + frame.size.height;

    // status line
    UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(offsetX, offsetY + 5, width, 0)];
    UILabel *statusTextView = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, width - 10, 0)];
    statusTextView.text = [self getStringForMessageState];
    statusTextView.textColor = [[UIColor alloc] initWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    statusTextView.numberOfLines = 0;
    [statusTextView setFont:[UIFont fontWithName:@"HelveticaNeue" size:9]];
    [statusTextView sizeToFit];
    [statusView setFrame:CGRectMake(statusView.frame.origin.x, statusView.frame.origin.y, statusTextView.frame.size.width, statusTextView.frame.size.height)];

    UIImage *statusIcon = [self getIconForMessageState];
    UIImageView *statusIconView = [[UIImageView alloc] initWithImage:statusIcon];
    statusIconView.frame = CGRectMake(0, 1, 8, 8);

    [statusView addSubview:statusIconView];
    [statusView addSubview:statusTextView];

    frame = statusView.frame;
    offsetY = frame.origin.y + frame.size.height;

    // adjust bubble and cell dimentions based on content
    [bubbleView setFrame:CGRectMake(bubbleView.frame.origin.x, bubbleView.frame.origin.y, bubbleView.frame.size.width, offsetY + 10)];
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, bubbleView.frame.size.height + 10)];

    BubbleNibView *nibView = [[BubbleNibView alloc] initWithFrame:[self getBubbleNibFrameForFrame:bubbleView.frame] fillColor:[self getBubbleBackgroundColor] alignment:[self getBubbleNibAlignment]];
    nibView.backgroundColor = self.backgroundColor;
    [self addSubview:nibView];

    [bubbleView addSubview:nameView];
    [bubbleView addSubview:messageBodyView];
    [bubbleView addSubview:statusView];
    [self addSubview:bubbleView];
}

#pragma mark -

- (id)getStringForMessageState {
    ConversationMessageState state = self.messageState;
    if (state == ConversationMessageDelivered) {
        return @"Delivered";
    } else if (state == ConversationMessageDelivering) {
        return @"Sending";
    } else if (state == ConversationMessageDeliveryFailed) {
        return @"Failed, retry?";
    } else {
        return nil;
    }
}

- (id)getIconForMessageState {
    ConversationMessageState state = self.messageState;
    NSString *iconName = nil;
    if (state == ConversationMessageDelivered) {
        iconName = @"checkmark";
    } else if (state == ConversationMessageDelivering) {
        iconName = @"timer";
    } else if (state == ConversationMessageDeliveryFailed) {
        iconName = @"failed";
    } else {
        return nil;
    }

    UIImage *icon = [UIImage imageNamed:iconName];
    return icon;
}

- (CGRect)getBubbleFrameForSide {
    ConversationMessageAlignment alignment = self.messageAlignment;
    CGRect frame;

    int width = self.frame.size.width - 66;
    int height = self.frame.size.height;
    int offsetY = 13;
    int offsetX = 13;

    if (alignment == ConversationMessageRight) {
        width -= 18;
        frame = CGRectMake(self.frame.size.width - width - offsetX, offsetY, width, height);
    } else {
        frame = CGRectMake(offsetX, offsetY, width, height);
    }

    return frame;
}

- (id)getBubbleBackgroundColor {
    ConversationMessageAlignment alignment = self.messageAlignment;
    if (alignment == ConversationMessageRight) {
        return [[UIColor alloc] initWithRed:214/255.0 green:233/255.0 blue:248/255.0 alpha:1];
    } else {
        return [[UIColor alloc] initWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    }
}

- (BubbleNibAlignment)getBubbleNibAlignment {
    ConversationMessageAlignment alignment = self.messageAlignment;
    if (alignment == ConversationMessageRight) {
        return BubbleNibAlignmentRight;
    } else {
        return BubbleNibAlignmentLeft;
    }
}

- (CGRect)getBubbleNibFrameForFrame:(CGRect)frame {
    int nibWidth = 6;
    int nibHeight = 10;
    ConversationMessageAlignment alignment = self.messageAlignment;

    if (alignment == ConversationMessageLeft) {
        return CGRectMake(frame.origin.x - nibWidth, frame.origin.y + 15, nibWidth, nibHeight);

    } else {
        return CGRectMake(frame.origin.x + frame.size.width, frame.origin.y + 15, nibWidth, nibHeight);
    }
}

@end
