//
//  SNGWeatherViewModel.m
//  WeatherNearYou
//
//  Created by Konstantin Snegov on 13/11/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import "SNGWeatherViewModel.h"
#import "SNGWeather.h"
#import "SNGWeatherForecastViewModel.h"
#import "SNGDownloadingManager.h"
#import "SNGWeatherSettingsViewModel.h"

@interface SNGWeatherViewModel()

@property (strong, nonatomic) SNGWeather *weather;
@property (strong, nonatomic) NSMutableArray *forecastModels;
@end

@implementation SNGWeatherViewModel

#pragma mark -
#pragma mark Constants

static NSInteger const SNGWeatherViewModelForecastHours = 24;
static NSString * const SNGWeatherViewModelDefaultValueString = @"--";
static NSString * const SNGWeatherViewModelDefaultValueTimeString = @"--:--";

#pragma mark -
#pragma mark Getters

- (NSMutableArray *)forecastModels {
    if (!_forecastModels) {
        _forecastModels = [[NSMutableArray alloc] init];
    }
    return _forecastModels;
}

- (NSString *)sunriseTime {
    return (self.weather && self.weather.sunrise) ? [SNGWeatherSettingsViewModel timeFromDate:self.weather.sunrise] : SNGWeatherViewModelDefaultValueTimeString;
}

- (NSString *)sunsetTime {
    return (self.weather && self.weather.sunset) ? [SNGWeatherSettingsViewModel timeFromDate:self.weather.sunset] : SNGWeatherViewModelDefaultValueTimeString;
}

- (NSString *)shortConditionName {
    return (self.weather && self.weather.shortConditionName) ? NSLocalizedString(self.weather.shortConditionName, nil) : SNGWeatherViewModelDefaultValueString;
}

- (NSString *)conditionName {
    return (self.weather.conditionName && self.weather.conditionName) ? NSLocalizedString(self.weather.conditionName, nil) : SNGWeatherViewModelDefaultValueString;
}

- (NSString *)temperature {
    NSString *temp = [self temperatureStringFromDouble:[SNGWeatherSettingsViewModel temperatureInCurrentFormat:self.weather.temperature]];
    return self.weather ? [NSString stringWithFormat:@"%@", temp] : SNGWeatherViewModelDefaultValueString;
}

- (NSString *)temperatureMin {
    NSString *temp = [self temperatureStringFromDouble:[SNGWeatherSettingsViewModel temperatureInCurrentFormat:self.weather.temperatureMin]];
    return self.weather ? [NSString stringWithFormat:@"%@", temp] : SNGWeatherViewModelDefaultValueString;
}

- (NSString *)temperatureMax {
    NSString *temp = [self temperatureStringFromDouble:[SNGWeatherSettingsViewModel temperatureInCurrentFormat:self.weather.temperatureMax]];
    return self.weather ? [NSString stringWithFormat:@"%@", temp] : SNGWeatherViewModelDefaultValueString;
}

- (NSString *)humidity {
    return self.weather ? [NSString stringWithFormat:@"%lu%%", (unsigned long)self.weather.humidity] : SNGWeatherViewModelDefaultValueString;
}

- (NSString *)pressure {
    return self.weather ? [NSString stringWithFormat:@"%lu %@", (unsigned long)[SNGWeatherSettingsViewModel pressureInCurrentFormat:self.weather.pressure], [SNGWeatherSettingsViewModel pressureName]] : SNGWeatherViewModelDefaultValueString;
}

- (NSString *)wind {
    return self.weather ? [NSString stringWithFormat:@"%@ %.0f %@", self.weather.windArrow, [SNGWeatherSettingsViewModel windSpeedInCurrentFormat:self.weather.windSpeed], [SNGWeatherSettingsViewModel windSpeedName]] : SNGWeatherViewModelDefaultValueString;
}

- (NSString *)clouds {
    return self.weather ? [NSString stringWithFormat:@"%lu%%", (unsigned long)self.weather.clouds] : SNGWeatherViewModelDefaultValueString;
}

- (NSString *)placeName {
    return self.weather ? [NSString stringWithFormat:@"%@ (%@)", self.weather.placeName ? self.weather.placeName : @"" , self.weather.country ? self.weather.country : @""] : SNGWeatherViewModelDefaultValueString;
}

- (NSArray *)forecast {
    return [self.forecastModels copy];
}

#pragma mark -
#pragma mark Initializers

/// Init with SNGLocation. Designated initializer
- (instancetype)initWithLatitude:(double)latitude andLongitude:(double)longitude {
    self = [super init];
    if (self) {
        _latitude = latitude;
        _longitude = longitude;
    }
    return self;
}

#pragma mark -
#pragma mark Deallocations

- (void)dealloc {
    [[SNGDownloadingManager sharedManager] stopWeatherTasks];
}

#pragma mark -
#pragma mark Download weather

/// Request weather
- (void)requestWeather {
    [[SNGDownloadingManager sharedManager] requestCurrentWeatherForLatitude:self.latitude Longitude:self.longitude withCompletionHandler:^(SNGWeather *weather){
        NSLog(@"Weather recieved");
        self.weather = weather;
        [(NSObject *)self.delegate performSelectorOnMainThread:@selector(weatherDidRecieved) withObject:nil waitUntilDone:NO];
    } failure:^(NSError *error) {
        if ([self respondsToSelector:@selector(weatherDidFailureRequest:)]) {
            [(NSObject *)self performSelectorOnMainThread:@selector(weatherDidFailureRequest:) withObject:error waitUntilDone:NO];
        }
    }];
    
    [[SNGDownloadingManager sharedManager] requestWeatherForecastForNextHours:SNGWeatherViewModelForecastHours ForLatitude:self.latitude Longitude:self.longitude withCompletionHandler:^(NSArray *weatherForecast) {
        [self.forecastModels removeAllObjects];
        
        for (SNGWeather *forecast in weatherForecast) {
            SNGWeatherForecastViewModel *forecastModel = [[SNGWeatherForecastViewModel alloc] initWithWeather:forecast];
            [self.forecastModels addObject:forecastModel];
        }
        
        [(NSObject *)self.delegate performSelectorOnMainThread:@selector(weatherDidRecieved) withObject:nil waitUntilDone:NO];
    } failure:^(NSError *error) {
        if ([self respondsToSelector:@selector(weatherDidFailureRequest:)]) {
            [(NSObject *)self performSelectorOnMainThread:@selector(weatherDidFailureRequest:) withObject:error waitUntilDone:NO];
        }
    }];
}

#pragma mark -
#pragma mark Convertions

/// Convert temperature from double to string
- (NSString *)temperatureStringFromDouble:(double)temperature {
    NSNumber *tempNumber = [NSNumber numberWithDouble:temperature];
    return [NSString stringWithFormat:@"%i°", [tempNumber intValue]];
}

@end
