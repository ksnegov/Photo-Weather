//
//  SNGWeatherSettingsViewModel.m
//  WeatherNearYou
//
//  Created by Konstantin Snegov on 14/11/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import "SNGWeatherSettingsViewModel.h"
#import "SNGWeatherSettings.h"

@implementation SNGWeatherSettingsViewModel

#pragma mark -
#pragma mark - Getters

/// List of temperatures formats
+ (NSDictionary *)temperatureFormatName {
    return @{ [NSNumber numberWithInteger:SNGWeatherSettingsTemperatureInKelvin] : NSLocalizedString(@"Kelvin", nil),
              [NSNumber numberWithInteger:SNGWeatherSettingsTemperatureInCelsius] : NSLocalizedString(@"Celsius", nil),
              [NSNumber numberWithInteger:SNGWeatherSettingsTemperatureInFahrenheit] : NSLocalizedString(@"Fahrenheit", nil)
              };
}

/// List of pressure formats
+ (NSDictionary *)pressureFormatName {
    return @{ [NSNumber numberWithInteger:SNGWeatherSettingsPressureInHectoPascal] : NSLocalizedString(@"hPa", nil),
              [NSNumber numberWithInteger:SNGWeatherSettingsPressureInPascal] : NSLocalizedString(@"Pa", nil),
              [NSNumber numberWithInteger:SNGWeatherSettingsPressureInMillimetrOfMercury] : NSLocalizedString(@"mmHg", nil)
              };
}

/// List of wind speed formats
+ (NSDictionary *)windSpeedFormatName {
    return @{ [NSNumber numberWithInteger:SNGWeatherSettingsWindSpeedInKilometersPerHour] : NSLocalizedString(@"km/h", nil),
              [NSNumber numberWithInteger:SNGWeatherSettingsWindSpeedInMetersPerSecond] : NSLocalizedString(@"m/s", nil),
              [NSNumber numberWithInteger:SNGWeatherSettingsWindSpeedInMilesPerHour] : NSLocalizedString(@"mile/h", nil)
              };
}

/// List of time formats
+ (NSDictionary *)timeFormatName {
    return @{ [NSNumber numberWithInteger:SNGWeatherSettingsTimeFormat12H] : NSLocalizedString(@"12 hours", nil),
              [NSNumber numberWithInteger:SNGWeatherSettingsTimeFormat24H] : NSLocalizedString(@"24 hours", nil)
            };
}

- (NSInteger)temperatureIndex {
    return [SNGWeatherSettings sharedSettings].temperatureFormat;
}

- (NSInteger)pressureIndex {
    return [SNGWeatherSettings sharedSettings].pressureFormat;
}

- (NSInteger)windSpeedIndex {
    return [SNGWeatherSettings sharedSettings].windSpeedFormat;
}

- (NSInteger)timeFormatIndex {
    return [SNGWeatherSettings sharedSettings].timeFormat;
}

#pragma mark -
#pragma mark Setters

- (void)setTemperatureIndex:(NSInteger)temperatureIndex {
    [SNGWeatherSettings sharedSettings].temperatureFormat = temperatureIndex;
    [[SNGWeatherSettings sharedSettings] saveSettings];
}

- (void)setPressureIndex:(NSInteger)pressureIndex {
    [SNGWeatherSettings sharedSettings].pressureFormat = pressureIndex;
    [[SNGWeatherSettings sharedSettings] saveSettings];
}

- (void)setWindSpeedIndex:(NSInteger)windSpeedIndex {
    [SNGWeatherSettings sharedSettings].windSpeedFormat = windSpeedIndex;
    [[SNGWeatherSettings sharedSettings] saveSettings];
}

- (void)setTimeFormatIndex:(NSInteger)timeFormatIndex {
    [SNGWeatherSettings sharedSettings].timeFormat = timeFormatIndex;
    [[SNGWeatherSettings sharedSettings] saveSettings];
}

#pragma mark -
#pragma mark Names for formats

/// Returns temperature name for current weather settings
+ (NSString *)temperatureName {
    NSNumber *temperatureFormat = [NSNumber numberWithInteger:[SNGWeatherSettings sharedSettings].temperatureFormat];
    return [self temperatureFormatName][temperatureFormat];
}

/// Returns pressure format name for current weather settings
+ (NSString *)pressureName {
    NSNumber *pressureFormat = [NSNumber numberWithInteger:[SNGWeatherSettings sharedSettings].pressureFormat];
    return [self pressureFormatName][pressureFormat];
}

/// Returns wind speed name for current weather settings
+ (NSString *)windSpeedName {
    NSNumber *windSpeedFormat = [NSNumber numberWithInteger:[SNGWeatherSettings sharedSettings].windSpeedFormat];
    return [self windSpeedFormatName][windSpeedFormat];
}

#pragma mark -
#pragma mark Convertion helpers

/// Return time string for date. Format based on weather settings
+ (NSString *)timeFromDate:(NSDate *)date {
    if (!date) return @"--:--";
    
    NSDateFormatter *timeFormatter = [[SNGWeatherSettings sharedSettings] timeDateFormatter];
    return [timeFormatter stringFromDate:date];
}

/// Convert temperature in Kelvin to weather settings format
+ (double)temperatureInCurrentFormat:(double)temperatureInKelvin {
    double temperature = 0;
    switch ([SNGWeatherSettings sharedSettings].temperatureFormat) {
        case SNGWeatherSettingsTemperatureInCelsius:
            temperature = [SNGWeatherSettings convertKelvinToCelsius:temperatureInKelvin];
            break;

        case SNGWeatherSettingsTemperatureInFahrenheit:
            temperature = [SNGWeatherSettings convertKelvinToFahrenheit:temperatureInKelvin];
            break;
            
        case SNGWeatherSettingsTemperatureInKelvin:
            temperature = temperatureInKelvin;
            break;
            
        default:
            break;
    }
    return temperature;
}

/// Convert pressure in hecto pascal to weather settings format
+ (NSInteger)pressureInCurrentFormat:(NSInteger)pressureInHectoPascal {
    NSInteger pressure = 0;
    switch ([SNGWeatherSettings sharedSettings].pressureFormat) {
        case SNGWeatherSettingsPressureInMillimetrOfMercury:
            pressure = [SNGWeatherSettings convertHectoPascalToMillimetrOfMercury:pressureInHectoPascal];
            break;

        case SNGWeatherSettingsPressureInPascal:
            pressure = [SNGWeatherSettings convertHectoPascalToPascal:pressureInHectoPascal];
            break;

        case SNGWeatherSettingsPressureInHectoPascal:
            pressure = pressureInHectoPascal;
            break;
            
        default:
            break;
    }
    return pressure;
}

/// Convert wind speed in meters per second to weather settings format
+ (double)windSpeedInCurrentFormat:(double)windSpeedMps {
    double windSpeed = 0;
    switch ([SNGWeatherSettings sharedSettings].windSpeedFormat) {
        case SNGWeatherSettingsWindSpeedInKilometersPerHour:
            windSpeed = [SNGWeatherSettings convertMetersPerSecondToKilometersPerHour:windSpeedMps];
            break;
        
        case SNGWeatherSettingsWindSpeedInMilesPerHour:
            windSpeed = [SNGWeatherSettings convertMetersPerSecondToMilesPerHour:windSpeedMps];
            break;
        
        case SNGWeatherSettingsWindSpeedInMetersPerSecond:
            windSpeed = windSpeedMps;
            break;
            
        default:
            break;
    }
    return windSpeed;
}

@end
