//
//  SNGDownloadingManager.h
//  WeatherNearYou
//
//  Created by Konstantin Snegov on 13/11/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SNGWeather;
@class SNGPhoto;

@interface SNGDownloadingManager : NSObject

/// Singlton
+ (SNGDownloadingManager *)sharedManager;


/// Request current weather for Location
- (void)requestCurrentWeatherForLatitude:(double)latitude Longitude:(double)longitude withCompletionHandler:(void(^)(SNGWeather *weather))completionHandler failure:(void(^)(NSError *error))failureHandler;

/// Request weather forecast for next hours using Location
- (void)requestWeatherForecastForNextHours:(NSUInteger)hours ForLatitude:(double)latitude Longitude:(double)longitude withCompletionHandler:(void(^)(NSArray *weatherForecast))completionHandler failure:(void(^)(NSError *error))failureHandler;

/// Request photo list, which were taken near location, from all photo providers
- (void)requestPhotoListForLatitude:(double)latitude Longitude:(double)longitude withCompletionHandler:(void(^)(NSArray *photos))completionHandler failure:(void(^)(NSError *error))failureHandler;

/// Request photo
- (void)requestPhotoFrom:(NSString *)path withCompletionHandler:(void(^)(NSData *photoData))completionHandler failure:(void(^)(NSError *error))failureHandler;

/// Stop all tasks in queue
- (void)stopTasks;

/// Stop photo tasks
- (void)stopPhotoTasks;

/// Stop weather tasks
- (void)stopWeatherTasks;

@end
