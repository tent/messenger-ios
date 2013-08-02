//
//  BubbleNibView.h
//  Messages
//
//  Created by Jesse on 7/24/13.
//  Copyright (c) 2013 Cupcake. All rights reserved.
//

@import UIKit;

typedef NS_ENUM(NSUInteger, BubbleNibAlignment) {
    BubbleNibAlignmentLeft,
    BubbleNibAlignmentRight
};

@interface BubbleNibView : UIView
@property (nonatomic) UIColor *nibColor;
@property (nonatomic) BubbleNibAlignment nibAlignment;

- (id)initWithFrame:(CGRect)aRect fillColor:(UIColor*)color alignment:(BubbleNibAlignment)alignment;
@end
