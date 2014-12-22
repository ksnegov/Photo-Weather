//
//  SNGWeatherViewModel.h
//  WeatherNearYou
//
//  Created by Konstantin Snegov on 13/11/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SNGWeatherViewModelDelegate <NSObject>
@required
- (void)weatherDidRecieved;
@optional
- (void)weatherDidFailureRequest:(NSError *)error;
@end

@interface SNGWeatherViewModel : NSObject

@property (weak, nonatomic) id<SNGWeatherViewModelDelegate> delegate;


@property (assign, nonatomic) double latitude;
@property (assign, nonatomic) double longitude;

@property (strong, nonatomic, readonly) NSString *sunriseTime;
@property (strong, nonatomic, readonly) NSString *sunsetTime;
@property (strong, nonatomic, readonly) NSString *shortConditionName;
@property (strong, nonatomic, readonly) NSString *conditionName;
@property (assign, nonatomic, readonly) NSString *temperature;
@property (assign, nonatomic, readonly) NSString *temperatureMin;
@property (assign, nonatomic, readonly) NSString *temperatureMax;
@property (assign, nonatomic, readonly) NSString *humidity;
@property (assign, nonatomic, readonly) NSString *pressure;
@property (assign, nonatomic, readonly) NSString *wind;
@property (assign, nonatomic, readonly) NSString *clouds;
@property (strong, nonatomic, readonly) NSString *placeName;
@property (strong, nonatomic, readonly) NSArray *forecast;

/// Init with latitude and longitude. Designated initializer
- (instancetype)initWithLatitude:(double)latitude andLongitude:(double)longitude;

/// Request weather
- (void)requestWeather;

@end
