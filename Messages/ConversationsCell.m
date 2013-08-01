//
//  ConversationsCell.m
//  Messages
//
//  Created by Jesse on 7/25/13.
//  Copyright (c) 2013 Cupcake. All rights reserved.
//

#import "ConversationsCell.h"
#import "UIImage+Resize.h"
#import "NSDate+TimeAgo.h"
#import "Contact.h"
#import "Message.h"

@implementation ConversationsCell

- (void)initConversation:(Conversation *)conversation {
    self.conversation = conversation;

    contacts = [self.conversation.contacts sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
}

- (UILabel *)timeViewWithFrame:(CGRect)frame {
    UILabel *view = [[UILabel alloc] initWithFrame:frame];


    if (self.conversation.latestMessage) {
        view.text = [self.conversation.latestMessage.timestamp dateTimeAgo]; // TODO: update in view every n seconds
    } else {
        view.text = nil;
    }

    view.textAlignment = NSTextAlignmentRight;


    [view setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    view.textColor = [[UIColor alloc] initWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];

    return view;
}

- (UILabel *)nameViewWithFrame:(CGRect)frame {
    UILabel *view = [[UILabel alloc] initWithFrame:frame];

    NSMutableArray *contactNames = [[NSMutableArray alloc] init];
    for (Contact *contact in contacts) {
        [contactNames addObject:contact.name];
    }
    view.text = [contactNames componentsJoinedByString:@", "];

    [view setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:15]];
    view.textColor = [[UIColor alloc] initWithRed:2/255.0 green:116/255.0 blue:210/255.0 alpha:1];

    return view;
}

- (UILabel *)bodyViewWithFrame:(CGRect)frame {
    UILabel *view = [[UILabel alloc] initWithFrame:frame];

    if (self.conversation.latestMessage) {
        view.text = self.conversation.latestMessage.body;
    } else {
        view.text = nil;
    }

    [view setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    view.textColor = [[UIColor alloc] initWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    view.numberOfLines = 2;

    return view;
}

- (UIView *)imageViewWithFrame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];

    int avatarSize;
    int avatarMargin;
    int displayCount;
    int nMore;

    if (contacts.count > 8) {
        avatarMargin = 2;
        avatarSize = (frame.size.height / 3) - avatarMargin;

        if (contacts.count == 9) {
            displayCount = 9;
            nMore = 0;
        } else {
            displayCount = 8;
            nMore = contacts.count - displayCount;
        }
    } else if (contacts.count > 1) {
        avatarMargin = 2;
        avatarSize = (frame.size.height / 2) - avatarMargin;

        if (contacts.count > 4) {
            displayCount = 3;
            nMore = contacts.count - displayCount;
        } else {
            nMore = 0;
            displayCount = contacts.count;
        }
    } else {
        avatarMargin = 0;
        avatarSize = frame.size.height;
        displayCount = 1;
        nMore = 0;
    }

    UIImageView *imageSubView;
    UIImage *avatar;
    Contact *contact;
    int nthCol = 0;
    int nthRow = 0;
    int nPerRow = (int)(frame.size.height / avatarSize);
    for (int i = 0; i < displayCount; i++) {
        contact = [contacts objectAtIndex:i];
        avatar = [[UIImage imageWithData:contact.avatar] thumbnailImage:avatarSize transparentBorder:0 cornerRadius:3 interpolationQuality:kCGInterpolationHigh];
        imageSubView = [[UIImageView alloc] initWithImage:avatar];

        int offsetX = (nthCol * avatarSize) + (avatarMargin * nthCol);
        int offsetY = (nthRow * avatarSize) + (avatarMargin * nthRow);

        imageSubView.frame = CGRectMake(offsetX, offsetY, avatarSize, avatarSize);

        [view addSubview:imageSubView];

        if (nthCol == nPerRow - 1) {
            nthCol = 0;
            nthRow++;
        } else {
            nthCol++;
        }
    }



    if (nMore > 0) {
        // +n view

        int offsetX = (nthCol * avatarSize) + (avatarMargin * nthCol);
        int offsetY = (nthRow * avatarSize) + (avatarMargin * nthRow);

        UIView *nMoreView = [[UIView alloc] initWithFrame:CGRectMake(offsetX, offsetY, avatarSize, avatarSize)];
        [nMoreView.layer setCornerRadius:3];
        [nMoreView.layer setBorderColor:[UIColor blackColor].CGColor];
        [nMoreView.layer setBorderWidth:1];

        UILabel *nMoreText = [[UILabel alloc] initWithFrame:CGRectMake(1.5f, 1.5f, avatarSize - 3, avatarSize - 3)];
        nMoreText.text = [[NSString alloc] initWithFormat:@"+%d", nMore];
        [nMoreText setBackgroundColor:[[UIColor alloc] initWithWhite:1 alpha:0]];
        [nMoreText setTextColor:[[UIColor alloc] initWithWhite:0 alpha:1]];

        int baseFontSize;
        if (nPerRow > 2) {
            baseFontSize = 8;
        } else {
            baseFontSize = 13;
        }

        int nMoreFontSize;
        if ([nMoreText.text length] > 3) {
            nMoreFontSize = baseFontSize - 3;
        } else {
            nMoreFontSize = baseFontSize;
        }

        [nMoreText setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:nMoreFontSize]];
        nMoreText.textAlignment = NSTextAlignmentCenter;
        [nMoreView addSubview:nMoreText];

        [view addSubview:nMoreView];
    }

    return view;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (imageView) {
        [imageView removeFromSuperview];
    }

    if (contentView) {
        [contentView removeFromSuperview];
    }

    CGRect imageFrame = CGRectMake(10, 10, 60, 60);
    imageView = [self imageViewWithFrame:imageFrame];

    CGRect contentFrame = CGRectMake(imageFrame.origin.x + imageFrame.size.width + 5, imageFrame.origin.y, self.frame.size.width - imageFrame.origin.x - imageFrame.size.width - 13, imageFrame.size.height);
    contentView = [[UIView alloc] initWithFrame:contentFrame];

    UILabel *timeView = [self timeViewWithFrame:CGRectMake(contentFrame.size.width - 60, 0, 60, 20)];

    UILabel *nameView = [self nameViewWithFrame:CGRectMake(0, 0, contentFrame.size.width - timeView.frame.size.width - 5, 20)];
    UILabel *bodyView = [self bodyViewWithFrame:CGRectMake(0, nameView.frame.origin.y + nameView.frame.size.height, contentFrame.size.width, contentFrame.size.height - nameView.frame.origin.y - nameView.frame.size.height - 5)];

    [contentView addSubview:nameView];
    [contentView addSubview:timeView];
    [contentView addSubview:bodyView];

    [self addSubview:imageView];
    [self addSubview:contentView];
}

@end
