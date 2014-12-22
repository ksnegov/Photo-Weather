//
//  UIImage+SNGAverageColor.h
//  WeatherNearYou
//
//  Created by Konstantin Snegov on 17/11/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SNGAverageColor)

/// Returns average color in the image
- (UIColor *)averageColor;

@end
