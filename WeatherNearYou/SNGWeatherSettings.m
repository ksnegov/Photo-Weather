//
//  SNGWeatherSettings.m
//  WeatherNearYou
//
//  Created by Konstantin Snegov on 14/11/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import "SNGWeatherSettings.h"

@implementation SNGWeatherSettings

#pragma mark -
#pragma mark Constants

static NSString * const SNGWeatherSettingsKey = @"WeatherSettings";
static NSString * const SNGWeatherSettingsTemperatureFormatKey = @"TemperatureFormat";
static NSString * const SNGWeatherSettingsPressureFormatKey = @"PressureFormat";
static NSString * const SNGWeatherSettingsWindSpeedFormatKey = @"WindSpeedFormat";
static NSString * const SNGWeatherSettingsTimeFormatKey = @"TimeFormat";
static double const SNGWeatherSettingsKelvinInCelsius = -273.15; // 1 Kelvin = -273.15 Celsius
static double const SNGWeatherSettingsKelvinInFahrenheit = -459.67;
static double const SNGWeatherSettingsPascalInHectoPascal = 100; // 1 hPa = 100 Pa
static double const SNGWeatherSettingsMillimeterOfMercuryInPascal = 133.3223684; // 1 mm = 133,322 368 4 Pa
static double const SNGWeatherSettingsMilesPerHourInMetersPerSecond = 2.23694; // 1 mps = 2.23694 mph
static double const SNGWeatherSettingsKilometersPerHourInMetersPerSecond = 3.6; // 1 m/s = 3.6 k/h
#pragma mark -
#pragma mark Singlton

+ (SNGWeatherSettings *)sharedSettings {
    static SNGWeatherSettings *settings;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        settings = [[SNGWeatherSettings alloc] initPrivate];
    });
    return settings;
}

#pragma mark -
#pragma mark Initializers

- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton" reason:@"This class is singleton. Use class method instead." userInfo:nil];
}

/// Designated initializer
- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        [self loadSettings];
    }
    return self;
}

#pragma mark -
#pragma mark Save and Load settings

/// Plist settings
- (NSDictionary *)plist {
    return @{ SNGWeatherSettingsTemperatureFormatKey : [NSNumber numberWithInteger:self.temperatureFormat],
              SNGWeatherSettingsPressureFormatKey : [NSNumber numberWithInteger:self.pressureFormat],
              SNGWeatherSettingsWindSpeedFormatKey : [NSNumber numberWithInteger:self.windSpeedFormat],
              SNGWeatherSettingsTimeFormatKey : [NSNumber numberWithInteger:self.timeFormat]
            };
}


/// Write settings to NSUserDefaults
- (void)saveSettings {
    [[NSUserDefaults standardUserDefaults] setObject:[self plist] forKey:SNGWeatherSettingsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/// Restore settings from NSUserDefaults
- (void)loadSettings {
    NSDictionary *plist = [[NSUserDefaults standardUserDefaults] objectForKey:SNGWeatherSettingsKey];
    self.temperatureFormat = [plist[SNGWeatherSettingsTemperatureFormatKey] integerValue];
    self.pressureFormat = [plist[SNGWeatherSettingsPressureFormatKey] integerValue];
    self.windSpeedFormat = [plist[SNGWeatherSettingsWindSpeedFormatKey] integerValue];
    self.timeFormat = [plist[SNGWeatherSettingsTimeFormatKey] integerValue];
}

#pragma mark -
#pragma mark Helpers

/// Returns NSDateFormatter for presenting time depends on the settings
- (NSDateFormatter *)timeDateFormatter {
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    timeFormatter.dateFormat = @"HH:mm";
    if (self.timeFormat == SNGWeatherSettingsTimeFormat12H) {
        timeFormatter.dateFormat = @"hh:mm a";
    }
    return timeFormatter;
}

#pragma mark -
#pragma mark Temperature convertions

/// Convert temperature in Kelvin to Celsius
+ (double)convertKelvinToCelsius:(double)temperatureInKelvin {
    return temperatureInKelvin + SNGWeatherSettingsKelvinInCelsius;
}

/// Convert temperature in Kelvin to Fahrenheit
+ (double)convertKelvinToFahrenheit:(double)temperatureInKelvin {
    return temperatureInKelvin * 9/5 + SNGWeatherSettingsKelvinInFahrenheit;
}

#pragma mark -
#pragma Pressure conversions

/// Convert pressure in Hecto pascal to Millimeters of mercury
+ (NSInteger)convertHectoPascalToMillimetrOfMercury:(NSInteger)pressureInHectoPascal {
    return [self convertHectoPascalToPascal:pressureInHectoPascal] / SNGWeatherSettingsMillimeterOfMercuryInPascal;
}

/// Convert pressure in Hecto pascal to Pascal
+ (NSInteger)convertHectoPascalToPascal:(NSInteger)pressureInHectoPascal {
    return pressureInHectoPascal * SNGWeatherSettingsPascalInHectoPascal;
}

#pragma mark -
#pragma mark Wind speed conversions

/// Convert Meters per second to Miles per hour
+ (double)convertMetersPerSecondToMilesPerHour:(double)mps {
    return mps * SNGWeatherSettingsMilesPerHourInMetersPerSecond;
}

/// Convert Meters per second to Kilometers per hour
+ (double)convertMetersPerSecondToKilometersPerHour:(double)mps {
    return mps * SNGWeatherSettingsKilometersPerHourInMetersPerSecond;
}

@end
