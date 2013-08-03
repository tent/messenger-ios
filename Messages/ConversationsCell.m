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
#import "MessagesAesthetics.h"

@implementation ConversationsCell

{
    NSArray *contacts;
    NSTimer *refreshTimer;

    UIView *imageView;
    UIView *contentView;
    UILabel *timeView;
    UILabel *bodyView;
    UILabel *nameView;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    id ret = [super initWithCoder:aDecoder];

    imageView = [[UIView alloc] init];
    contentView = [[UIView alloc] init];
    timeView = [[UILabel alloc] init];
    bodyView = [[UILabel alloc] init];
    nameView = [[UILabel alloc] init];

    [contentView addSubview:nameView];
    [contentView addSubview:timeView];
    [contentView addSubview:bodyView];

    [self addSubview:imageView];
    [self addSubview:contentView];

    refreshTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshTimeViewContent) userInfo:nil repeats:YES];

    return ret;
}

#pragma mark - UIView

- (void)layoutSubviews {
    // Setup image frame
    CGRect imageFrame = CGRectMake(10, 10, 60, 60);

    // image frame is offset when in edit mode
    if (self.editing) {
        imageFrame = CGRectOffset(imageFrame, 40, 0);

        ConversationsViewController *c = (ConversationsViewController *)self.tableViewController;
        if ([c.selectedIndexPaths containsObject:self.indexPath]) {
            self.selected = true;
        }
    }

    // Assign image frame
    imageView.frame = imageFrame;

    // Assign image content
    [self refreshImageViewContent];

    CGRect contentFrame = CGRectMake(
                                     imageFrame.origin.x + imageFrame.size.width + 5, // x
                                     imageFrame.origin.y, // y
                                     self.frame.size.width - imageFrame.origin.x - imageFrame.size.width - 13, // width
                                     imageFrame.size.height // height
                                     );

    // Assign content frame
    contentView.frame = contentFrame;

    // time view frame
    timeView.frame = CGRectMake(contentFrame.size.width - 60, 0, 60, 20);

    // time view content
    [self refreshTimeViewContent];

    // name view frame
    nameView.frame = CGRectMake(0, 0, contentFrame.size.width - timeView.frame.size.width - 5, 20);

    // name view content
    [self refreshNameViewContent];

    // body view frame
    bodyView.frame = CGRectMake(0, nameView.frame.origin.y + nameView.frame.size.height, contentFrame.size.width, contentFrame.size.height - nameView.frame.origin.y - nameView.frame.size.height - 5);

    // body view content
    [self refreshBodyViewContent];

    [super layoutSubviews];
}

#pragma mark - UITableViewCell

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    if (!editing) {
        self.selected = NO;
    }

    self.tableViewController.tableView.allowsMultipleSelectionDuringEditing = editing;

    [super setEditing:editing animated:animated];
}

#pragma mark -

- (void)initConversation:(Conversation *)conversation {
    self.conversation = conversation;

    contacts = [self.conversation.contacts sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
}

- (void)refreshTimeViewContent {
    UILabel *view = timeView;

    if (self.conversation.latestMessage) {
        view.text = [self.conversation.latestMessage.timestamp dateTimeAgo]; // TODO: update in view every n seconds
    } else {
        view.text = nil;
    }

    view.textAlignment = NSTextAlignmentRight;

    [MessagesAesthetics setFontForLabel:view withStyle:UIFontTextStyleFootnote];
    view.textColor = [MessagesAesthetics greyColor];
}

- (void)refreshNameViewContent {
    UILabel *view = nameView;

    NSMutableArray *contactNames = [[NSMutableArray alloc] init];
    for (Contact *contact in contacts) {
        [contactNames addObject:contact.name];
    }
    view.text = [contactNames componentsJoinedByString:@", "];

    [MessagesAesthetics setFontForLabel:view withStyle:UIFontTextStyleSubheadline];
    view.textColor = [MessagesAesthetics blueColor];
}

- (void)refreshBodyViewContent {
    UILabel *view = bodyView;

    if (self.conversation.latestMessage) {
        view.text = self.conversation.latestMessage.body;
    } else {
        view.text = nil;
    }

    [MessagesAesthetics setFontForLabel:view withStyle:UIFontTextStyleFootnote];
    view.textColor = [MessagesAesthetics blackColor];
    view.numberOfLines = 2;
}

- (void)refreshImageViewContent {
    CGRect frame = imageView.frame;
    UIView *view = imageView;

    // Remove all subviews
    for (UIView *subview in view.subviews) {
        [subview removeFromSuperview];
    }

    int avatarMargin;
    int nPerRow;

    if (contacts.count > 1) {
        avatarMargin = 2;

        if (contacts.count > 4) {
            nPerRow = 3;
        } else {
            nPerRow = 2;
        }
    } else {
        avatarMargin = 0;
        nPerRow = 1;
    }

    int displayCount;

    if ((int)contacts.count > (nPerRow * nPerRow)) {
        displayCount = (nPerRow * nPerRow) - 1;
    } else {
        displayCount = contacts.count;
    }

    int nMore = contacts.count - displayCount;
    int avatarSize = (frame.size.height / nPerRow) - avatarMargin;

    UIImageView *imageSubView;
    UIImage *avatar;
    Contact *contact;
    int nthCol = 0;
    int nthRow = 0;
    for (int i = 0; i < displayCount; i++) {
        contact = [contacts objectAtIndex:i];
        avatar = [[UIImage imageWithData:contact.avatar] thumbnailImage:avatarSize transparentBorder:0 cornerRadius:3 interpolationQuality:kCGInterpolationHigh];
        imageSubView = [[UIImageView alloc] initWithImage:avatar];

        int offsetX = (nthCol * avatarSize) + (avatarMargin * (nthCol+1));
        int offsetY = (nthRow * avatarSize) + (avatarMargin * (nthRow+1));

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

        int offsetX = (nthCol * avatarSize) + (avatarMargin * (nthCol+1));
        int offsetY = (nthRow * avatarSize) + (avatarMargin * (nthRow+1));

        UIView *nMoreView = [[UIView alloc] initWithFrame:CGRectMake(offsetX, offsetY, avatarSize, avatarSize)];
        [nMoreView.layer setCornerRadius:3];
        [nMoreView.layer setBorderColor:[MessagesAesthetics blackColor].CGColor];
        [nMoreView.layer setBorderWidth:1];

        UILabel *nMoreText = [[UILabel alloc] initWithFrame:CGRectMake(1.5f, 1.5f, avatarSize - 3, avatarSize - 3)];
        nMoreText.text = [[NSString alloc] initWithFormat:@"+%d", nMore];
        [nMoreText setBackgroundColor:[MessagesAesthetics transparentColor]];
        [nMoreText setTextColor:[MessagesAesthetics blackColor]];

        int baseFontSize;
        if (nPerRow > 2) {
            baseFontSize = 8;
        } else {
            baseFontSize = 13;
        }

        int nMoreFontSize;
        if ([nMoreText.text length] > 3) {
            nMoreFontSize = 5;
        } else {
            nMoreFontSize = baseFontSize;
        }

        [MessagesAesthetics setFontForLabel:nMoreText withSize:nMoreFontSize withWeight:MessagesAestheticsFontWeightLight];
        nMoreText.textAlignment = NSTextAlignmentCenter;
        [nMoreView addSubview:nMoreText];

        [view addSubview:nMoreView];
    }
}

@end
