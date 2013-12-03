//
//  BubbleNibView.h
//  Messages
//
//  Created by Jesse on 7/24/13.
//  Copyright (c) 2013 Boolean Cupcake, LLC. All rights reserved.
//

@import UIKit;

typedef NS_ENUM(NSUInteger, BubbleNibAlignment) { BubbleNibAlignmentLeft,
                                                  BubbleNibAlignmentRight };

@interface BubbleNibView : UIView

- (void)setFrame:(CGRect)frame
       fillColor:(UIColor *)color
       alignment:(BubbleNibAlignment)alignment;
@end
