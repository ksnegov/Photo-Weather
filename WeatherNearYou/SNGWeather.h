//
//  SNGWeather.h
//  WeatherNearYou
//
//  Created by Konstantin Snegov on 12/11/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SNGWeatherWindDirection) {
    SNGWeatherWindDirectionNorth,
    SNGWeatherWindDirectionNorthNorthEast,
    SNGWeatherWindDirectionNorthEast,
    SNGWeatherWindDirectionEastNorthEast,
    SNGWeatherWindDirectionEast,
    SNGWeatherWindDirectionEastSouthEast,
    SNGWeatherWindDirectionSouthEast,
    SNGWeatherWindDirectionSouthSouthEast,
    SNGWeatherWindDirectionSouth,
    SNGWeatherWindDirectionSouthSouthWest,
    SNGWeatherWindDirectionSouthWest,
    SNGWeatherWindDirectionWestSouthWest,
    SNGWeatherWindDirectionWest,
    SNGWeatherWindDirectionWestNorthWest,
    SNGWeatherWindDirectionNorthWest,
    SNGWeatherWindDirectionNorthNorthWest
};

typedef NS_ENUM(NSUInteger, SNGWeatherConditionType){
    SNGWeatherConditionNone,
    SNGWeatherConditionClearSky,
    SNGWeatherConditionFewClouds,
    SNGWeatherConditionScatteredClouds,
    SNGWeatherConditionBrokenClouds,
    SNGWeatherConditionOvercastClouds,
    SNGWeatherConditionShowerRain,
    SNGWeatherConditionRain,
    SNGWeatherConditionThunderstorm,
    SNGWeatherConditionSnow,
    SNGWeatherConditionMist
};

@interface SNGWeather : NSObject

@property (strong, nonatomic) NSDate *forecastDate;
@property (strong, nonatomic) NSDate *sunrise;
@property (strong, nonatomic) NSDate *sunset;
@property (assign, nonatomic) SNGWeatherConditionType conditionType;
@property (strong, nonatomic) NSString *shortConditionName;
@property (strong, nonatomic) NSString *conditionName;
@property (assign, nonatomic) double temperature; // in Kelvin
@property (assign, nonatomic) double temperatureMin; // in Kelvin
@property (assign, nonatomic) double temperatureMax; // in Kelvin
@property (assign, nonatomic) NSUInteger humidity;
@property (assign, nonatomic) NSInteger pressure;
@property (assign, nonatomic) double windSpeed; //mps
@property (assign, nonatomic) double windDegree; //meteorological
@property (strong, nonatomic, readonly) NSString *windArrow;
@property (assign, nonatomic, readonly) SNGWeatherWindDirection windDirection;
@property (assign, nonatomic) NSUInteger rain; //mm for last 3 hours
@property (assign, nonatomic) NSUInteger snow; //mm for last 3 hours
@property (assign, nonatomic) NSUInteger clouds;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *placeName;

@end
