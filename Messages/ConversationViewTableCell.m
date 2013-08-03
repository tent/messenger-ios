//
//  ConversationViewTableCell.m
//  Messages
//
//  Created by Jesse on 7/23/13.
//  Copyright (c) 2013 Cupcake. All rights reserved.
//

#import "ConversationViewTableCell.h"
#import "MessagesAesthetics.h"

@implementation ConversationViewTableCell

{
    UILabel *nameView;
    UIView *messageStatusView;
    UILabel *messageBodyView;
    UIView *messageBubbleView;
    BubbleNibView *messageBubbleNibView;
}

#pragma mark - UIView

- (id)initWithCoder:(NSCoder *)aDecoder {
    id ret = [super initWithCoder:aDecoder];

    [self setupViews];

    return ret;
}

- (void)layoutSubviews {
    // message bubble
    messageBubbleView.frame = [self getBubbleFrameForSide];

    [messageBubbleView.layer setCornerRadius:3];
    messageBubbleView.backgroundColor = [self getBubbleBackgroundColor];

    int offsetY = 0;
    int offsetX = 10;
    int width = messageBubbleView.frame.size.width - (offsetX * 2);

    // name
    nameView.frame = CGRectMake(offsetX, offsetY + 11, width, 0);
    [self refreshNameViewContent];

    CGRect frame = nameView.frame;
    offsetY = frame.origin.y + frame.size.height;

    // message body
    messageBodyView.frame = CGRectMake(offsetX, offsetY + 5, width, 0);
    [self refreshBodyViewContent];

    frame = messageBodyView.frame;
    offsetY = frame.origin.y + frame.size.height;

    // status line
    messageStatusView.frame = CGRectMake(offsetX, offsetY + 5, width, 0);
    [self refreshStatusViewContent];

    frame = messageStatusView.frame;
    offsetY = frame.origin.y + frame.size.height;

    // adjust bubble and cell dimentions based on content
    messageBubbleView.frame = CGRectMake(
                                         messageBubbleView.frame.origin.x, // x
                                         messageBubbleView.frame.origin.y, // y
                                         messageBubbleView.frame.size.width, // width
                                         offsetY + 10 // height
                                         );

    self.frame = CGRectMake(
                            self.frame.origin.x, // x
                            self.frame.origin.y, // y
                            self.frame.size.width, // width
                            messageBubbleView.frame.size.height + messageBubbleView.frame.origin.y // height
                            );

    [messageBubbleNibView
        setFrame:[self getBubbleNibFrameForFrame:messageBubbleView.frame]
        fillColor:[self getBubbleBackgroundColor]
        alignment:[self getBubbleNibAlignment]
     ];

    messageBubbleNibView.backgroundColor = self.backgroundColor;

    [super layoutSubviews];

}

#pragma mark -

- (void)setupViews {
    nameView = [[UILabel alloc] init];
    messageStatusView = [[UIView alloc] init];
    messageBodyView = [[UILabel alloc] init];
    messageBubbleView = [[UIView alloc] init];
    messageBubbleNibView = [[BubbleNibView alloc] init];

    messageBubbleView.userInteractionEnabled = NO;
    messageBubbleNibView.userInteractionEnabled = NO;

    [messageBubbleView addSubview:nameView];
    [messageBubbleView addSubview:messageBodyView];
    [messageBubbleView addSubview:messageStatusView];
    [self addSubview:messageBubbleNibView];
    [self addSubview:messageBubbleView];
}

- (void)refreshNameViewContent {
    UILabel *view = nameView;
    view.text = self.name;
    view.textColor = [MessagesAesthetics blueColor];
    [MessagesAesthetics setFontForLabel:view withStyle:UIFontTextStyleSubheadline];
    [view sizeToFit];
}

- (void)refreshBodyViewContent {
    UILabel *view = messageBodyView;
    view.lineBreakMode = NSLineBreakByWordWrapping;
    view.text = self.messageBody;
    view.numberOfLines = 0;
    [MessagesAesthetics setFontForLabel:view withStyle:UIFontTextStyleFootnote];
    [view sizeToFit];
}

- (void)refreshStatusViewContent {
    UIView *view = messageStatusView;

    // remove all subviews
    for (UIView *subview in view.subviews) {
        [subview removeFromSuperview];
    }

    // text
    UILabel *textView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width - 10, 0)];
    textView.text = [self getStringForMessageState];
    textView.textColor = [MessagesAesthetics greyColor];
    textView.numberOfLines = 0;
    [MessagesAesthetics setFontForLabel:textView withStyle:UIFontTextStyleCaption2];
    [textView sizeToFit];
    [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, textView.frame.size.width, textView.frame.size.height)];

    // icon
    UIImage *statusIcon = [self getIconForMessageState];
    UIImageView *statusIconView = [[UIImageView alloc] initWithImage:statusIcon];
    int iconSize = textView.frame.size.height - 6;
    float iconOffsetY = (textView.frame.size.height - iconSize) / 2;
    statusIconView.frame = CGRectMake(0, iconOffsetY, iconSize, iconSize);

    // text frame clears icon
    textView.frame = CGRectOffset(textView.frame, iconSize + 2, 0);

    // add subviews
    [view addSubview:statusIconView];
    [view addSubview:textView];
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
        return [MessagesAesthetics whiteBlueColor];
    } else {
        return [MessagesAesthetics lightGreyColor];
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
