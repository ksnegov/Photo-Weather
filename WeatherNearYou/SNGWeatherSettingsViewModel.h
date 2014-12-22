//
//  SNGWeatherSettingsViewModel.h
//  WeatherNearYou
//
//  Created by Konstantin Snegov on 14/11/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNGWeatherSettingsViewModel : NSObject

@property (nonatomic) NSInteger temperatureIndex;
@property (nonatomic) NSInteger pressureIndex;
@property (nonatomic) NSInteger windSpeedIndex;
@property (nonatomic) NSInteger timeFormatIndex;

/// List of temperatures formats
+ (NSDictionary *)temperatureFormatName;

/// List of pressure formats
+ (NSDictionary *)pressureFormatName;

/// List of wind speed formats
+ (NSDictionary *)windSpeedFormatName;

/// List of time formats
+ (NSDictionary *)timeFormatName;

/// Return time string for date. Format based on weather settings
+ (NSString *)timeFromDate:(NSDate *)date;

/// Convert temperature in Kelvin to weather settings format
+ (double)temperatureInCurrentFormat:(double)temperatureInKelvin;

/// Convert pressure in hecto pascal to weather settings format
+ (NSInteger)pressureInCurrentFormat:(NSInteger)pressureInHectoPascal;

/// Convert wind speed in meters per second to weather settings format
+ (double)windSpeedInCurrentFormat:(double)windSpeedMps;

/// Returns temperature name for current weather settings
+ (NSString *)temperatureName;

/// Returns pressure format name for current weather settings
+ (NSString *)pressureName;

/// Returns wind speed name for current weather settings
+ (NSString *)windSpeedName;

@end
