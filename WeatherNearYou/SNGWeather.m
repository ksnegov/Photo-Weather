//
//  SNGWeather.m
//  WeatherNearYou
//
//  Created by Konstantin Snegov on 12/11/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import "SNGWeather.h"

@implementation SNGWeather

#pragma mark -
#pragma mark Getters

- (SNGWeatherWindDirection)windDirection {
    SNGWeatherWindDirection direction;
    
    if (self.windDegree >= 11.25 && self.windDegree <= 33.74) { direction = SNGWeatherWindDirectionNorthNorthEast; } else
    if (self.windDegree >= 33.75 && self.windDegree <= 56.24) { direction = SNGWeatherWindDirectionNorthEast; } else
    if (self.windDegree >= 56.25 && self.windDegree <= 78.74) { direction = SNGWeatherWindDirectionEastNorthEast; } else
    if (self.windDegree >= 78.75 && self.windDegree <= 101.24) { direction = SNGWeatherWindDirectionEast; } else
    if (self.windDegree >= 101.25 && self.windDegree <= 123.74) { direction = SNGWeatherWindDirectionEastSouthEast; } else
    if (self.windDegree >= 123.75 && self.windDegree <= 146.24) { direction = SNGWeatherWindDirectionSouthEast; } else
    if (self.windDegree >= 146.25 && self.windDegree <= 168.74) { direction = SNGWeatherWindDirectionSouthSouthEast; } else
    if (self.windDegree >= 168.75 && self.windDegree <= 191.24) { direction = SNGWeatherWindDirectionSouth; } else
    if (self.windDegree >= 191.25 && self.windDegree <= 213.74) { direction = SNGWeatherWindDirectionSouthSouthWest; } else
    if (self.windDegree >= 213.75 && self.windDegree <= 236.24) { direction = SNGWeatherWindDirectionSouthWest; } else
    if (self.windDegree >= 236.25 && self.windDegree <= 258.74) { direction = SNGWeatherWindDirectionWestSouthWest; } else
    if (self.windDegree >= 258.75 && self.windDegree <= 281.24) { direction = SNGWeatherWindDirectionWest; } else
    if (self.windDegree >= 281.25 && self.windDegree <= 303.74) { direction = SNGWeatherWindDirectionWestNorthWest; } else
    if (self.windDegree >= 303.75 && self.windDegree <= 326.24) { direction = SNGWeatherWindDirectionNorthWest; } else
    if (self.windDegree >= 326.25 && self.windDegree <= 348.74) { direction = SNGWeatherWindDirectionNorthNorthWest; } else
        { direction = SNGWeatherWindDirectionNorth; }

    return direction;
}

- (NSString *)windArrow {
    NSString *wind;
    switch (self.windDirection) {
        case SNGWeatherWindDirectionNorth:
            wind = @"↓";
            break;
            
        case SNGWeatherWindDirectionNorthNorthEast:
            wind = @"↙︎";
            break;
            
        case SNGWeatherWindDirectionNorthEast:
            wind = @"↙︎";
            break;
            
        case SNGWeatherWindDirectionEastNorthEast:
            wind = @"↙︎";
            break;
            
        case SNGWeatherWindDirectionEast:
            wind = @"←";
            break;
            
        case SNGWeatherWindDirectionEastSouthEast:
            wind = @"↖︎";
            break;
            
        case SNGWeatherWindDirectionSouthEast:
            wind = @"↖︎";
            break;
            
        case SNGWeatherWindDirectionSouthSouthEast:
            wind = @"↖︎";
            break;
            
        case SNGWeatherWindDirectionSouth:
            wind = @"↑";
            break;
            
        case SNGWeatherWindDirectionSouthSouthWest:
            wind = @"↗︎";
            break;
            
        case SNGWeatherWindDirectionSouthWest:
            wind = @"↗︎";
            break;
            
        case SNGWeatherWindDirectionWestSouthWest:
            wind = @"↗︎";
            break;
            
        case SNGWeatherWindDirectionWest:
            wind = @"→";
            break;
            
        case SNGWeatherWindDirectionWestNorthWest:
            wind = @"↘︎";
            break;
            
        case SNGWeatherWindDirectionNorthWest:
            wind = @"↘︎";
            break;
            
        case SNGWeatherWindDirectionNorthNorthWest:
            wind = @"↘︎";
            break;
            
        default:
            wind = @"";
            break;
    }
    return wind;
}

@end
