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
        for (int i=0; i<5; i++) {
            UIImage *avatar = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", i + 1]];
            avatar = [avatar thumbnailImage:29 transparentBorder:0 cornerRadius:3 interpolationQuality:kCGInterpolationHigh];

            UIView *avatarView = [[UIImageView alloc] initWithImage:avatar];
            avatarView.frame = CGRectMake(offset, 0, avatarView.frame.size.width, avatarView.frame.size.height);

            [self addSubview:avatarView];

            offset = avatarView.frame.origin.x + avatarView.frame.size.width + 5;
        }
    }
    return self;
}

@end
