//
//  SNGWeatherProvider.h
//  WeatherNearYou
//
//  Created by Konstantin Snegov on 13/11/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SNGWeather;

@interface SNGWeatherProvider : NSObject

/// Request for downloading current weather
+ (NSOperation *)requestCurrentWeatherForLatitude:(double)latitude Longitude:(double)longitude withCompletionHandler:(void(^)(SNGWeather *weather))completionHandler failure:(void(^)(NSError *error))failureHandler;

/// Request for downloading forecast for next hours
+ (NSOperation *)requestWeatherForecastForNextHours:(NSUInteger)hours ForLatitude:(double)latitude Longitude:(double)longitude withCompletionHandler:(void(^)(NSArray *weatherForecast))completionHandler failure:(void(^)(NSError *error))failureHandler;

@end
