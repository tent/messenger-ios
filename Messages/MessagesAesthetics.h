//
//  MessagesAesthetics.h
//  Messages
//
//  Created by Jesse Stuart on 8/3/13.
//  Copyright (c) 2013 Cupcake. All rights reserved.
//

@import Foundation;

typedef NS_ENUM(NSUInteger, MessagesAestheticsFontWeights) {
    MessagesAestheticsFontWeightLight,
    MessagesAestheticsFontWeightMedium,
    MessagesAestheticsFontWeightRegular
};

typedef NS_ENUM(NSUInteger, MessagesAestheticsFontSizes) {
    MessagesAestheticsFontSizeTinyTiny, // 5
    MessagesAestheticsFontSizeSmallTiny, // 8
    MessagesAestheticsFontSizeTiny, // 9
    MessagesAestheticsFontSizeBigTiny, // 10
    MessagesAestheticsFontSizeSmall, // 11
    MessagesAestheticsFontSizeMedium, // 13
    MessagesAestheticsFontSizeLarge // 15
};

@interface MessagesAesthetics : NSObject

#pragma mark - Colors

+ (UIColor *)transparentColor;
+ (UIColor *)blueColor;
+ (UIColor *)lightBlueColor;
+ (UIColor *)whiteBlueColor;
+ (UIColor *)greyColor;
+ (UIColor *)lightGreyColor;
+ (UIColor *)blackColor;
+ (UIColor *)whiteColor;

#pragma mark - Fonts

+ (UIFont *)fontWithSize:(MessagesAestheticsFontSizes)size weight:(MessagesAestheticsFontWeights)weight;
+ (void)setFontForLabel:(UILabel *)label withSize:(MessagesAestheticsFontSizes)size withWeight:(MessagesAestheticsFontWeights)weight;

@end
