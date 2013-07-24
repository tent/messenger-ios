//
//  BubbleNibView.m
//  Messages
//
//  Created by Jesse on 7/24/13.
//  Copyright (c) 2013 Cupcake. All rights reserved.
//

#import "BubbleNibView.h"

@implementation BubbleNibView

- (id)initWithFrame:(CGRect)aRect fillColor:(UIColor*)color alignment:(BubbleNibAlignment)alignment {
    self.nibColor = color;
    self.nibAlignment = alignment;
    self = [self initWithFrame:aRect];
    return self;
}

-(void)drawRect:(CGRect)rect {
    // Create an oval shape to draw.

    int width = self.frame.size.width;
    int height = self.frame.size.height;

    UIBezierPath *aPath = [UIBezierPath bezierPath];

    if (self.nibAlignment == BubbleNibAlignmentLeft) {
        [aPath moveToPoint:CGPointMake(width, 0)];
        [aPath addLineToPoint:CGPointMake(0, height / 2)];
        [aPath addLineToPoint:CGPointMake(width, height)];
    } else {
        [aPath moveToPoint:CGPointMake(0, 0)];
        [aPath addLineToPoint:CGPointMake(width, height / 2)];
        [aPath addLineToPoint:CGPointMake(0, height)];
    }

    // Set the render colors.
    [self.nibColor setFill];
    NSLog(@"nibColor: %@", self.nibColor);

    // Adjust the drawing options as needed.
    aPath.lineWidth = 0;
    aPath.lineJoinStyle = kCGLineJoinRound;

    [aPath fill];
}

@end
