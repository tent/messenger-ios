//
//  ConversationTitleView.m
//  Messages
//
//  Created by Jesse on 7/22/13.
//  Copyright (c) 2013 Cupcake. All rights reserved.
//

#import "ConversationTitleView.h"
#import "UIImage+Resize.h"

@implementation ConversationTitleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        int avatarCount = 6;
        int avatarSize = 29;
        int avatarMarginRight = 5;
        int offset = 0;

        int displayAvatarCount;
        if (avatarCount > 5) {
            displayAvatarCount = 4;
        } else {
            displayAvatarCount = avatarCount;

            if (avatarCount < 5) {
                offset = ((5 - displayAvatarCount) * (avatarSize + avatarMarginRight)) / 2;
            }
        }

        for (int i=0; i<displayAvatarCount; i++) {
            UIImage *avatar = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", i + 1]];
            avatar = [avatar thumbnailImage:avatarSize transparentBorder:0 cornerRadius:3 interpolationQuality:kCGInterpolationHigh];

            UIView *avatarView = [[UIImageView alloc] initWithImage:avatar];
            avatarView.frame = CGRectMake(offset, 0, avatarView.frame.size.width, avatarView.frame.size.height);

            [self addSubview:avatarView];

            offset = avatarView.frame.origin.x + avatarView.frame.size.width + avatarMarginRight;
        }

        if (avatarCount > 5) {
            // +n view
            UIView *nMore = [[UIView alloc] initWithFrame:CGRectMake(offset, 0, avatarSize, avatarSize)];
            [nMore.layer setCornerRadius:3];
            [nMore.layer setBorderColor:[UIColor whiteColor].CGColor];
            [nMore.layer setBorderWidth:1];
            UILabel *nMoreText = [[UILabel alloc] initWithFrame:CGRectMake(1.5f, 1.5f, avatarSize - 3, avatarSize - 3)];
            nMoreText.text = [[NSString alloc] initWithFormat:@"+%d", avatarCount - displayAvatarCount];
            [nMoreText setBackgroundColor:[[UIColor alloc] initWithWhite:1 alpha:0]];
            [nMoreText setTextColor:[[UIColor alloc] initWithWhite:1 alpha:1]];
            int nMoreFontSize;
            if ([nMoreText.text length] > 3) {
                nMoreFontSize = 10;
            } else {
                nMoreFontSize = 13;
            }
            [nMoreText setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:nMoreFontSize]];
            nMoreText.textAlignment = NSTextAlignmentCenter;
            [nMore addSubview:nMoreText];
            [self addSubview:nMore];
        }
    }
    return self;
}

@end