//
//  MessagesAesthetics.m
//  Messages
//
//  Created by Jesse Stuart on 8/3/13.
//  Copyright (c) 2013 Cupcake. All rights reserved.
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
        blueColor = [[UIColor alloc] initWithRed:2/255.0 green:116/255.0 blue:210/255.0 alpha:1];
    }

    return blueColor;
}

+ (UIColor *)lightBlueColor {
    static UIColor *lightBlueColor;   // #1e84d9
    if (!lightBlueColor) {
        lightBlueColor = [[UIColor alloc] initWithRed:30/255.0 green:132/255.0 blue:217/255.0 alpha:1];
    }

    return lightBlueColor;
}

+ (UIColor *)whiteBlueColor {
    static UIColor *whiteBlueColor;   // #d6e9f8
    if (!whiteBlueColor) {
        whiteBlueColor = [[UIColor alloc] initWithRed:214/255.0 green:233/255.0 blue:248/255.0 alpha:1];
    }

    return whiteBlueColor;
}


+ (UIColor *)greyColor {
    static UIColor *greyColor;        // #999999
    if (!greyColor) {
        greyColor = [[UIColor alloc] initWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    }

    return greyColor;
}

+ (UIColor *)lightGreyColor {
    static UIColor *lightGreyColor;   // #f1f1f1
    if (!lightGreyColor) {
        lightGreyColor = [[UIColor alloc] initWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    }

    return lightGreyColor;
}

+ (UIColor *)blackColor {
    static UIColor *blackColor;       // #333333
    if (!blackColor) {
        blackColor = [[UIColor alloc] initWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
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

+ (UIFont *)fontWithSize:(MessagesAestheticsFontSizes)size weight:(MessagesAestheticsFontWeights)weight {
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

    int fontSize;
    switch (size) {
        case MessagesAestheticsFontSizeTinyTiny:
            fontSize = 5;
            break;
        case MessagesAestheticsFontSizeSmallTiny:
            fontSize = 8;
            break;
        case MessagesAestheticsFontSizeTiny:
            fontSize = 9;
            break;

        case MessagesAestheticsFontSizeBigTiny:
            fontSize = 10;
            break;

        case MessagesAestheticsFontSizeSmall:
            fontSize = 11;
            break;

        case MessagesAestheticsFontSizeMedium:
            fontSize = 13;
            break;

        case MessagesAestheticsFontSizeLarge:
            fontSize = 15;
            break;
    }

    return [UIFont fontWithName:fontName size:fontSize];
}

+ (void)setFontForLabel:(UILabel *)label withSize:(MessagesAestheticsFontSizes)size withWeight:(MessagesAestheticsFontWeights)weight {
    UIFont *font = [self fontWithSize:size weight:weight];
    [label setFont:font];
}

@end
