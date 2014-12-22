//
//  SNGWeatherForecastViewModel.m
//  WeatherNearYou
//
//  Created by Konstantin Snegov on 13/11/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import "SNGWeatherForecastViewModel.h"
#import "SNGWeather.h"
#import "SNGWeatherSettingsViewModel.h"

@implementation SNGWeatherForecastViewModel

#pragma mark -
#pragma mark Initializers

/// Designated initializer
- (instancetype)initWithWeather:(SNGWeather *)weather {
    self = [super init];
    if (self) {
        _forecastDate = [SNGWeatherSettingsViewModel timeFromDate:weather.forecastDate];
        ///TODO: If temperature is -0.234 then in UI we will see -0. Convertion method in SNGWeatherViewModel use it.
        _temperature = [NSString stringWithFormat:@"%f", [SNGWeatherSettingsViewModel temperatureInCurrentFormat:weather.temperature]];
        _forecastImageName = [self imageNameForWeatherConditionType:weather.conditionType];
    }
    return self;
}

#pragma mark -
#pragma mark Photo names for weather conditions

/// Returns image name for wether condition type
- (NSString *)imageNameForWeatherConditionType:(SNGWeatherConditionType)condition {
    ///TODO: Implement this later when we will have some pictures
    return nil;
}

@end
