//
//  SNGWeatherProvider.m
//  WeatherNearYou
//
//  Created by Konstantin Snegov on 13/11/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import "SNGWeatherProvider.h"
#import <AFNetworking/AFNetworking.h>
#import "SNGWeather.h"

@implementation SNGWeatherProvider

#pragma mark -
#pragma mark Constants

static NSString * const SNGWeatherProviderAPIKey = @"e46b38d5ecb4395e17d4a7288a2d5733";
static NSString * const SNGWeatherProviderAPIPath = @"http://api.openweathermap.org/data/2.5/";

static NSString * const SNGWeatherProviderClouds = @"clouds";
static NSString * const SNGWeatherProviderCloudsAll = @"all";

static NSString * const SNGWeatherProviderMain = @"main";
static NSString * const SNGWeatherProviderHumidity = @"humidity";
static NSString * const SNGWeatherProviderPressure = @"pressure";
static NSString * const SNGWeatherProviderTemperature = @"temp";
static NSString * const SNGWeatherProviderTemperatureMin = @"temp_min";
static NSString * const SNGWeatherProviderTemperatureMax = @"temp_max";

static NSString * const SNGWeatherProviderPlaceName = @"name";

static NSString * const SNGWeatherProviderSysInforation = @"sys";
static NSString * const SNGWeatherProviderCountry = @"country";
static NSString * const SNGWeatherProviderSunrise = @"sunrise";
static NSString * const SNGWeatherProviderSunset = @"sunset";

static NSString * const SNGWeatherProviderWeather = @"weather";
static NSString * const SNGWeatherProviderWeatherName = @"main";
static NSString * const SNGWeatherProviderWeatherDescription = @"description";

static NSString * const SNGWeatherProviderWind = @"wind";
static NSString * const SNGWeatherProviderWindSpeed = @"speed";
static NSString * const SNGWeatherProviderWindDegree = @"deg";

static NSString * const SNGWeatherProviderRain = @"rain";
static NSString * const SNGWeatherProviderSnow = @"snow";
static NSString * const SNGWeatherProvider3h = @"3h";

static NSString * const SNGWeatherProviderList = @"list";
static NSString * const SNGWeatherProviderId = @"id";
static NSString * const SNGWeatherProviderForecastDate = @"dt";

/// Thunderstorm codes (11)
+ (NSArray *)SNGWeatherProviderThunderstormCodes {
    return @[ @200, @201, @202, @210, @211, @212, @221, @230, @231, @232 ];
}

/// Shower rain codes (9)
+ (NSArray *)SNGWeatherProviderShowerRainCodes {
    return @[ @300, @301, @302, @310, @311, @312, @313, @314, @321, @520, @521, @522, @531 ];
}

/// Rain codes (10)
+ (NSArray *)SNGWeatherProviderRainCodes {
    return @[ @500, @501, @502, @503, @504 ];
}

/// Show codes (13)
+ (NSArray *)SNGWeatherProviderSnowCodes {
    return @[ @511, @600, @601, @602, @611, @612, @615, @616, @620, @621, @622 ];
}

/// Show codes (50)
+ (NSArray *)SNGWeatherProviderMistCodes {
    return @[ @701, @711, @721, @731, @741, @751, @761, @762, @771, @781 ];
}

/// Clear sky codes (1)
+ (NSArray *)SNGWeatherProviderClearSkyCodes {
    return @[ @800 ];
}

/// Few clouds codes (2)
+ (NSArray *)SNGWeatherProviderFewCloudsCodes {
    return @[ @801 ];
}

/// Scattered clouds codes (3)
+ (NSArray *)SNGWeatherProviderScatteredCloudsCodes {
    return @[ @802 ];
}

/// Broken clouds codes (4)
+ (NSArray *)SNGWeatherProviderBrokenCloudsCodes {
    return @[ @803 ];
}

/// Overcast clouds codes (5)
+ (NSArray *)SNGWeatherProviderOvercastCloudsCodes {
    return @[ @804 ];
}


#pragma mark -
#pragma mark Paths for API

/// Return path with APP ID for Weather API
+ (NSString *)pathForWeatherAPIWithKey {
    return [NSString stringWithFormat:@"%@weather?APPID=%@", SNGWeatherProviderAPIPath, SNGWeatherProviderAPIKey];
}

/// Return path with APP ID for Weather forecast API
+ (NSString *)pathForWeatherForecastAPIWithKey {
    return [NSString stringWithFormat:@"%@forecast?APPID=%@", SNGWeatherProviderAPIPath, SNGWeatherProviderAPIKey];
}

/// Return path with APP ID, Latitude, Longitude for Weather API
+ (NSString *)pathForAPIWithLatitude:(double)latitude Longitude:(double)longitude useForecast:(BOOL)isForecast {
    NSString *apiPath = (isForecast) ? [self pathForWeatherForecastAPIWithKey] : [self pathForWeatherAPIWithKey];
    return [NSString stringWithFormat:@"%@&lat=%f&lon=%f", apiPath, latitude, longitude];
}

#pragma mark -
#pragma mark Operations

/// Request for downloading current weather with completion handler
+ (NSOperation *)requestCurrentWeatherForLatitude:(double)latitude Longitude:(double)longitude withCompletionHandler:(void(^)(SNGWeather *weather))completionHandler failure:(void(^)(NSError *error))failureHandler {
    NSURL *url = [NSURL URLWithString:[self pathForAPIWithLatitude:latitude Longitude:longitude useForecast:NO]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        
        NSDictionary *cloudsDictionary = result[SNGWeatherProviderClouds];
        NSDictionary *mainDictionary = result[SNGWeatherProviderMain];
        NSDictionary *sysDictionary = result[SNGWeatherProviderSysInforation];
        NSDictionary *windDictionary = result[SNGWeatherProviderWind];
        NSDictionary *rainDictionary = result[SNGWeatherProviderRain];
        NSDictionary *snowDictionary = result[SNGWeatherProviderSnow];
        NSArray *weatherArray = result[SNGWeatherProviderWeather];
        NSDictionary *weatherDictionary = [weatherArray firstObject];
        
        SNGWeather *currentWeather = [[SNGWeather alloc] init];
        currentWeather.forecastDate = [NSDate date];
        currentWeather.clouds = [cloudsDictionary[SNGWeatherProviderCloudsAll] unsignedIntegerValue];
        currentWeather.humidity = [mainDictionary[SNGWeatherProviderHumidity] unsignedIntegerValue];
        currentWeather.pressure = [mainDictionary[SNGWeatherProviderPressure] integerValue];
        currentWeather.temperature = [mainDictionary[SNGWeatherProviderTemperature] floatValue];
        currentWeather.temperatureMin = [mainDictionary[SNGWeatherProviderTemperatureMin] floatValue];
        currentWeather.temperatureMax = [mainDictionary[SNGWeatherProviderTemperatureMax] floatValue];
        currentWeather.placeName = result[SNGWeatherProviderPlaceName];
        currentWeather.country = sysDictionary[SNGWeatherProviderCountry];
        currentWeather.windSpeed = [windDictionary[SNGWeatherProviderWindSpeed] floatValue];
        currentWeather.windDegree = [windDictionary[SNGWeatherProviderWindDegree] floatValue];
        currentWeather.rain = [rainDictionary[SNGWeatherProvider3h] unsignedIntegerValue];
        currentWeather.snow = [snowDictionary[SNGWeatherProvider3h] unsignedIntegerValue];
        currentWeather.shortConditionName = weatherDictionary[SNGWeatherProviderWeatherName];
        currentWeather.conditionName = weatherDictionary[SNGWeatherProviderWeatherDescription];
        
        NSTimeInterval sunriseInterval = [sysDictionary[SNGWeatherProviderSunrise] doubleValue];
        currentWeather.sunrise = [NSDate dateWithTimeIntervalSince1970:sunriseInterval];
        NSTimeInterval sunsetInterval = [sysDictionary[SNGWeatherProviderSunset] doubleValue];
        currentWeather.sunset = [NSDate dateWithTimeIntervalSince1970:sunsetInterval];
        
        completionHandler(currentWeather);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureHandler(error);
    }];
    
    return operation;
}

/// Request for downloading forecast for next hours
+ (NSOperation *)requestWeatherForecastForNextHours:(NSUInteger)hours ForLatitude:(double)latitude Longitude:(double)longitude withCompletionHandler:(void (^)(NSArray *))completionHandler failure:(void (^)(NSError *))failureHandler {
    NSURL *url = [NSURL URLWithString:[self pathForAPIWithLatitude:latitude Longitude:longitude useForecast:YES]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDate *filterDate = [[NSDate date] dateByAddingTimeInterval:hours * 60 * 60];
        NSDictionary *result = (NSDictionary *)responseObject;
        NSMutableArray *forecasts = [[NSMutableArray alloc] init];
        
        NSArray *forecastList = result[SNGWeatherProviderList];
        
        for (NSDictionary *forecast in forecastList) {
            NSDictionary *mainDictionary = forecast[SNGWeatherProviderMain];
            NSArray *weatherArray = forecast[SNGWeatherProviderWeather];
            NSDictionary *weatherDictionary = [weatherArray firstObject];

            NSTimeInterval forecastInterval = [forecast[SNGWeatherProviderForecastDate] doubleValue];
            NSDate *forecastDate = [NSDate dateWithTimeIntervalSince1970:forecastInterval];
            
            // We don't need full forecast, only for next hours
            if ([forecastDate compare:filterDate] != NSOrderedDescending) {
                SNGWeather *forecastWeather = [[SNGWeather alloc] init];

                forecastWeather.forecastDate = forecastDate;
                forecastWeather.temperature = [mainDictionary[SNGWeatherProviderTemperature] floatValue];

                NSInteger conditionCode = [weatherDictionary[SNGWeatherProviderId] integerValue];
                forecastWeather.conditionType = [self weatherConditionType:conditionCode];
                [forecasts addObject:forecastWeather];
            }
        }
        
        completionHandler([forecasts copy]);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureHandler(error);
    }];

    return operation;
}

#pragma mark -
#pragma mark Weather conditions

+ (SNGWeatherConditionType)weatherConditionType:(NSInteger)code {
    SNGWeatherConditionType type = SNGWeatherConditionNone;
    NSNumber *numberCode = [NSNumber numberWithInteger:code];
    if ([[self SNGWeatherProviderMistCodes] containsObject:numberCode]) {
        type = SNGWeatherConditionMist;
    } else if ([[self SNGWeatherProviderRainCodes] containsObject:numberCode]) {
        type = SNGWeatherConditionRain;
    } else if ([[self SNGWeatherProviderShowerRainCodes] containsObject:numberCode]) {
        type = SNGWeatherConditionShowerRain;
    } else if ([[self SNGWeatherProviderSnowCodes] containsObject:numberCode]) {
        type = SNGWeatherConditionSnow;
    } else if ([[self SNGWeatherProviderThunderstormCodes] containsObject:numberCode]) {
        type = SNGWeatherConditionThunderstorm;
    } else if ([[self SNGWeatherProviderClearSkyCodes] containsObject:numberCode]) {
        type = SNGWeatherConditionClearSky;
    } else if ([[self SNGWeatherProviderFewCloudsCodes] containsObject:numberCode]) {
        type = SNGWeatherConditionFewClouds;
    } else if ([[self SNGWeatherProviderScatteredCloudsCodes] containsObject:numberCode]) {
        type = SNGWeatherConditionScatteredClouds;
    } else if ([[self SNGWeatherProviderBrokenCloudsCodes] containsObject:numberCode]) {
        type = SNGWeatherConditionBrokenClouds;
    } else if ([[self SNGWeatherProviderOvercastCloudsCodes] containsObject:numberCode]) {
        type = SNGWeatherConditionOvercastClouds;
    }
        
    return type;
}


@end
