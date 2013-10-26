//
//  MessagesAesthetics.m
//  Messages
//
//  Created by Jesse Stuart on 8/3/13.
//  Copyright (c) 2013 Boolean Cupcake, LLC. All rights reserved.
//

#import "MessagesAesthetics.h"

@implementation MessagesAesthetics

#pragma mark - Colors

+ (UIColor *)transparentColor {
    static UIColor *transparentColor; // fully transparent
    if (!transparentColor) {
        transparentColor = [[UIColor alloc] initWithWhite:0 alpha:0];
    }

    return transparentColor;
}

+ (UIColor *)blueColor {
    static UIColor *blueColor;        // #0274d2
    if (!blueColor) {
        blueColor = [[UIColor alloc] initWithRed:(float)(2/255.0) green:(float)(116/255.0) blue:(float)(210/255.0) alpha:1];
    }

    return blueColor;
}

+ (UIColor *)lightBlueColor {
    static UIColor *lightBlueColor;   // #1e84d9
    if (!lightBlueColor) {
        lightBlueColor = [[UIColor alloc] initWithRed:(float)(30/255.0) green:(float)(132/255.0) blue:(float)(217/255.0) alpha:1];
    }

    return lightBlueColor;
}

+ (UIColor *)whiteBlueColor {
    static UIColor *whiteBlueColor;   // #d6e9f8
    if (!whiteBlueColor) {
        whiteBlueColor = [[UIColor alloc] initWithRed:(float)(214/255.0) green:(float)(233/255.0) blue:(float)(248/255.0) alpha:1];
    }

    return whiteBlueColor;
}


+ (UIColor *)greyColor {
    static UIColor *greyColor;        // #999999
    if (!greyColor) {
        greyColor = [[UIColor alloc] initWithRed:(float)(153/255.0) green:(float)(153/255.0) blue:(float)(153/255.0) alpha:1];
    }

    return greyColor;
}

+ (UIColor *)lightGreyColor {
    static UIColor *lightGreyColor;   // #f1f1f1
    if (!lightGreyColor) {
        lightGreyColor = [[UIColor alloc] initWithRed:(float)(241/255.0) green:(float)(241/255.0) blue:(float)(241/255.0) alpha:1];
    }

    return lightGreyColor;
}

+ (UIColor *)blackColor {
    static UIColor *blackColor;       // #333333
    if (!blackColor) {
        blackColor = [[UIColor alloc] initWithRed:(float)(51/255.0) green:(float)(51/255.0) blue:(float)(51/255.0) alpha:1];
    }

    return blackColor;
}

+ (UIColor *)whiteColor {
    static UIColor *whiteColor;       // #ffffff
    if (!whiteColor) {
        whiteColor = [[UIColor alloc] initWithWhite:1 alpha:1];
    }

    return whiteColor;
}

#pragma mark - Fonts

+ (UIFont *)fontWithStyle:(NSString *)style {
    UIFontDescriptor *fontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:style];

    return [UIFont fontWithDescriptor:fontDescriptor size:fontDescriptor.pointSize];
}

+ (UIFont *)fontWithSize:(CGFloat)size withWeight:(MessagesAestheticsFontWeights)weight {
    return [UIFont fontWithName:[self fontName:weight] size:size];
}

+ (void)setFontForLabel:(UILabel *)label withStyle:(NSString *)style {
    [label setFont:[self fontWithStyle:style]];
}

+ (void)setFontForLabel:(UILabel *)label withSize:(CGFloat)size withWeight:(MessagesAestheticsFontWeights)weight {
    [label setFont:[self fontWithSize:size withWeight:weight]];
}

+ (NSString *)fontName:(MessagesAestheticsFontWeights)weight {
    NSString *fontName;
    switch (weight) {
        case MessagesAestheticsFontWeightLight:
            fontName = @"HelveticaNeue-Light";
            break;

        case MessagesAestheticsFontWeightMedium:
            fontName = @"HelveticaNeue-Medium";
            break;

        case MessagesAestheticsFontWeightRegular:
            fontName = @"HelveticaNeue";
            break;
    }

    return fontName;
}

@end
