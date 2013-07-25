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

    [self.messageBubbleView removeFromSuperview];
    [self.messageBubbleNibView removeFromSuperview];

    // message bubble
    CGRect bubbleViewFrame = [self getBubbleFrameForSide];
    self.messageBubbleView = [[UIView alloc] initWithFrame:bubbleViewFrame];

    [self.messageBubbleView.layer setCornerRadius:3];
    self.messageBubbleView.backgroundColor = [self getBubbleBackgroundColor];

    int offsetY = 0;
    int offsetX = 10;
    int width = self.messageBubbleView.frame.size.width - (offsetX * 2);

    // name
    UILabel *nameView = [self nameViewWithFrame:CGRectMake(offsetX, offsetY + 11, width, 0)];

    CGRect frame = nameView.frame;
    offsetY = frame.origin.y + frame.size.height;

    // message body
    UILabel *messageBodyView = [self messageBodyViewWithFrame:CGRectMake(offsetX, offsetY + 5, width, 0)];

    frame = messageBodyView.frame;
    offsetY = frame.origin.y + frame.size.height;

    // status line
    UIView *messageStatusView = [self messageStatusViewWithFrame:CGRectMake(offsetX, offsetY + 5, width, 0)];

    frame = messageStatusView.frame;
    offsetY = frame.origin.y + frame.size.height;

    // adjust bubble and cell dimentions based on content
    [self.messageBubbleView setFrame:CGRectMake(self.messageBubbleView.frame.origin.x, self.messageBubbleView.frame.origin.y, self.messageBubbleView.frame.size.width, offsetY + 10)];
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.messageBubbleView.frame.size.height + self.messageBubbleView.frame.origin.y)];

    self.messageBubbleNibView = [[BubbleNibView alloc] initWithFrame:[self getBubbleNibFrameForFrame:self.messageBubbleView.frame] fillColor:[self getBubbleBackgroundColor] alignment:[self getBubbleNibAlignment]];
    self.messageBubbleNibView.backgroundColor = self.backgroundColor;
    [self addSubview:self.messageBubbleNibView];

    [self.messageBubbleView addSubview:nameView];
    [self.messageBubbleView addSubview:messageBodyView];
    [self.messageBubbleView addSubview:messageStatusView];
    [self addSubview:self.messageBubbleView];
}

#pragma mark -

- (UILabel*)nameViewWithFrame:(CGRect)frame {
    UILabel *nameView = [[UILabel alloc] initWithFrame:frame];
    nameView.text = self.name;
    nameView.textColor = [[UIColor alloc] initWithRed:2/255.0 green:116/255.0 blue:210/255.0 alpha:1];
    [nameView setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:11]];
    [nameView sizeToFit];

    return nameView;
}

- (UILabel*)messageBodyViewWithFrame:(CGRect)frame {
    UILabel *messageBodyView = [[UILabel alloc] initWithFrame:frame];
    messageBodyView.lineBreakMode = NSLineBreakByWordWrapping;
    messageBodyView.text = self.messageBody;
    messageBodyView.numberOfLines = 0;
    [messageBodyView setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    [messageBodyView sizeToFit];

    return messageBodyView;
}

- (UIView*)messageStatusViewWithFrame:(CGRect)frame {
    UIView *statusView = [[UIView alloc] initWithFrame:frame];
    UILabel *statusTextView = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, statusView.frame.size.width - 10, 0)];
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

    return statusView;
}

- (NSString*)getStringForMessageState {
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

- (UIImage*)getIconForMessageState {
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

- (UIColor*)getBubbleBackgroundColor {
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
