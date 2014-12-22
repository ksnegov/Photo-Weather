//
//  SNGWeatherForecastViewModel.h
//  WeatherNearYou
//
//  Created by Konstantin Snegov on 13/11/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SNGWeather;

@interface SNGWeatherForecastViewModel : NSObject

@property (strong, nonatomic) NSString *forecastDate;
@property (strong, nonatomic) NSString *temperature;
@property (strong, nonatomic) NSString *forecastImageName;

/// Designated initializer
- (instancetype)initWithWeather:(SNGWeather *)weather;

@end
