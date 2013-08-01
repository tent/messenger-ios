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

    Contact *contact = [contacts objectAtIndex:0];
    UIImage *avatar = [UIImage imageWithData:contact.avatar];

    // TODO: tile avatars
    avatar = [avatar thumbnailImage:60 transparentBorder:0 cornerRadius:3 interpolationQuality:kCGInterpolationHigh];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:avatar];
    [view addSubview:imageView];

    return view;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect imageFrame = CGRectMake(10, 10, 60, 60);
    UIView *imageView = [self imageViewWithFrame:imageFrame];

    CGRect contentFrame = CGRectMake(imageFrame.origin.x + imageFrame.size.width + 5, imageFrame.origin.y, self.frame.size.width - imageFrame.origin.x - imageFrame.size.width - 13, imageFrame.size.height);
    UIView *contentView = [[UIView alloc] initWithFrame:contentFrame];

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
