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

+ (UIFont *)fontWithStyle:(NSString *)style;
+ (UIFont *)fontWithSize:(CGFloat)size withWeight:(MessagesAestheticsFontWeights)weight;
+ (void)setFontForLabel:(UILabel *)label withStyle:(NSString *)style;
+ (void)setFontForLabel:(UILabel *)label withSize:(CGFloat)size withWeight:(MessagesAestheticsFontWeights)weight;
+ (NSString *)fontName:(MessagesAestheticsFontWeights)weight;

@end
