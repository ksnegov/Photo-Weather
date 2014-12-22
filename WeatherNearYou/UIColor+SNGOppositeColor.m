//
//  UIColor+SNGOppositeColor.m
//  WeatherNearYou
//
//  Created by Konstantin Snegov on 17/11/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import "UIColor+SNGOppositeColor.h"

@implementation UIColor (SNGOppositeColor)

/// Returns opposite color
- (UIColor *)oppositeColor {
    CGFloat r, g, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return [UIColor colorWithRed:1.0-r green:1.0-g blue:1.0-b alpha:1.0];
}

/// Defines if this is dark color
- (BOOL)isDark {
    CGFloat w, a;
    [self getWhite:&w alpha:&a];
    return (w <= .55);
}

@end
