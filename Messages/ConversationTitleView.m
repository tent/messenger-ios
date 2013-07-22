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
        int offset = 0;
        for (int i=0; i<4; i++) {
            UIImage *avatar = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", i + 1]];
            avatar = [avatar thumbnailImage:29 transparentBorder:0 cornerRadius:3 interpolationQuality:kCGInterpolationHigh];

            UIView *avatarView = [[UIImageView alloc] initWithImage:avatar];
            avatarView.frame = CGRectMake(offset, 0, avatarView.frame.size.width, avatarView.frame.size.height);

            [self addSubview:avatarView];

            offset = avatarView.frame.origin.x + avatarView.frame.size.width + 5;
        }

        // +n view
        UIView *nMore = [[UIView alloc] initWithFrame:CGRectMake(offset, 0, 29, 29)];
        [nMore.layer setCornerRadius:3];
        [nMore.layer setBorderColor:[UIColor whiteColor].CGColor];
        [nMore.layer setBorderWidth:1.5f];
        UILabel *nMoreText = [[UILabel alloc] initWithFrame:CGRectMake(1.5f, 1.5f, 29 - 3, 29 - 3)];
        nMoreText.text = @"+2";
        [nMoreText setBackgroundColor:[[UIColor alloc] initWithWhite:1 alpha:0]];
        [nMoreText setTextColor:[[UIColor alloc] initWithWhite:1 alpha:1]];
        [nMoreText setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13]];
        nMoreText.textAlignment = NSTextAlignmentCenter;
        [nMore addSubview:nMoreText];
        [self addSubview:nMore];
    }
    return self;
}

@end
