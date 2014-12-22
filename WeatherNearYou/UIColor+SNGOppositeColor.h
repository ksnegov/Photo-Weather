//
//  UIColor+SNGOppositeColor.h
//  WeatherNearYou
//
//  Created by Konstantin Snegov on 17/11/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (SNGOppositeColor)

/// Returns opposite color
- (UIColor *)oppositeColor;

/// Defines if this is dark color
- (BOOL)isDark;


@end
