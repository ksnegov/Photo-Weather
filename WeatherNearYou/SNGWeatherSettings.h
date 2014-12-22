//
//  SNGWeatherSettings.h
//  WeatherNearYou
//
//  Created by Konstantin Snegov on 14/11/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SNGWeatherSettingsTemperatureFormat){
    SNGWeatherSettingsTemperatureInKelvin,
    SNGWeatherSettingsTemperatureInCelsius,
    SNGWeatherSettingsTemperatureInFahrenheit
};

typedef NS_ENUM(NSInteger, SNGWeatherSettingsPressureFormat){
    SNGWeatherSettingsPressureInHectoPascal,
    SNGWeatherSettingsPressureInPascal,
    SNGWeatherSettingsPressureInMillimetrOfMercury
};

typedef NS_ENUM(NSInteger, SNGWeatherSettingsWindSpeedFormat){
    SNGWeatherSettingsWindSpeedInMilesPerHour,
    SNGWeatherSettingsWindSpeedInKilometersPerHour,
    SNGWeatherSettingsWindSpeedInMetersPerSecond
};

typedef NS_ENUM(NSInteger, SNGWeatherSettingsTimeFormat){
    SNGWeatherSettingsTimeFormat12H,
    SNGWeatherSettingsTimeFormat24H
};


@interface SNGWeatherSettings : NSObject

/// Temperature format F or C
@property (assign, nonatomic) SNGWeatherSettingsTemperatureFormat temperatureFormat;

/// Pressure format
@property (assign, nonatomic) SNGWeatherSettingsPressureFormat pressureFormat;

/// Wind speed format
@property (assign, nonatomic) SNGWeatherSettingsWindSpeedFormat windSpeedFormat;

/// Time format
@property (assign, nonatomic) SNGWeatherSettingsTimeFormat timeFormat;

/// Singltone
+ (SNGWeatherSettings *)sharedSettings;

/// Write settings to NSUserDefaults
- (void)saveSettings;


/// Returns NSDateFormatter for presenting time depends on the settings
- (NSDateFormatter *)timeDateFormatter;


/// Convert temperature in Kelvin to Celsius
+ (double)convertKelvinToCelsius:(double)temperatureInKelvin;

/// Convert temperature in Kelvin to Fahrenheit
+ (double)convertKelvinToFahrenheit:(double)temperatureInKelvin;

/// Convert pressure in Hecto pascal to Millimeters of mercury
+ (NSInteger)convertHectoPascalToMillimetrOfMercury:(NSInteger)pressureInHectoPascal;

/// Convert pressure in Hecto pascal to Pascal
+ (NSInteger)convertHectoPascalToPascal:(NSInteger)pressureInHectoPascal;

/// Convert Meters per second to Miles per hour
+ (double)convertMetersPerSecondToMilesPerHour:(double)mps;

/// Convert Meters per second to Kilometers per hour
+ (double)convertMetersPerSecondToKilometersPerHour:(double)mps;

@end
