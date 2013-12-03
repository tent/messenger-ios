//
//  ConversationTitleView.m
//  Messages
//
//  Created by Jesse on 7/22/13.
//  Copyright (c) 2013 Boolean Cupcake, LLC. All rights reserved.
//

#import "ConversationTitleView.h"
#import "UIImage+Resize.h"
#import "Contact.h"
#import "MessagesAesthetics.h"

@implementation ConversationTitleView {
  ConversationViewController *dataSource;
}

- (id)initWithFrame:(CGRect)frame
     withDataSource:(ConversationViewController *)source {
  dataSource = source;
  self = [self initWithFrame:frame];
  return self;
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];

    NSArray *contacts = [dataSource.conversation.contacts.allObjects sortedArrayUsingComparator:^(Contact *obj1, Contact *obj2) {
      NSString *name1 = obj1.name;
      NSString *name2 = obj2.name;

      return [name1 caseInsensitiveCompare:name2];
    }];

    if (self) {
      int avatarCount = (int)contacts.count;
      int avatarSize = 29;
      int avatarMarginRight = 5;
      int offset = 0;

      int displayAvatarCount;
      if (avatarCount > 5) {
        displayAvatarCount = 4;
      } else {
        displayAvatarCount = avatarCount;

        if (avatarCount < 5) {
          offset =
              ((5 - displayAvatarCount) * (avatarSize + avatarMarginRight)) / 2;
        }
      }

      for (int i = 0; i < displayAvatarCount; i++) {
        Contact *contact = [contacts objectAtIndex:(unsigned int)i];

        UIImage *avatar = [UIImage imageWithData:contact.avatar];
        avatar = [avatar thumbnailImage:avatarSize
                      transparentBorder:0
                           cornerRadius:3
                   interpolationQuality:kCGInterpolationHigh];

        UIView *avatarView = [[UIImageView alloc] initWithImage:avatar];
        avatarView.frame = CGRectMake(offset, 0, avatarView.frame.size.width,
                                      avatarView.frame.size.height);

        [self addSubview:avatarView];

        offset = (int)avatarView.frame.origin.x +
                 (int)avatarView.frame.size.width + avatarMarginRight;
      }

      if (avatarCount > 5) {
        // +n view
        UIView *nMore = [[UIView alloc]
            initWithFrame:CGRectMake(offset, 0, avatarSize, avatarSize)];
        [nMore.layer setCornerRadius:3];
        [nMore.layer setBorderColor:[MessagesAesthetics whiteColor].CGColor];
        [nMore.layer setBorderWidth:1];
        UILabel *nMoreText = [[UILabel alloc]
            initWithFrame:CGRectMake(1.5f, 1.5f, avatarSize - 3,
                                     avatarSize - 3)];
        nMoreText.text = [[NSString alloc]
            initWithFormat:@"+%d", avatarCount - displayAvatarCount];
        [nMoreText setBackgroundColor:[MessagesAesthetics transparentColor]];
        [nMoreText setTextColor:[MessagesAesthetics whiteColor]];
        int nMoreFontSize;
        if ([nMoreText.text length] > 3) {
          nMoreFontSize = 10;
        } else {
          nMoreFontSize = 13;
        }
        [MessagesAesthetics setFontForLabel:nMoreText
                                   withSize:nMoreFontSize
                                 withWeight:MessagesAestheticsFontWeightLight];
        nMoreText.textAlignment = NSTextAlignmentCenter;
        [nMore addSubview:nMoreText];
        [self addSubview:nMore];
      }
    }
    return self;
}

@end
