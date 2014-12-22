//
//  SNGPhotoFlickrProvider.h
//  WeatherNearYou
//
//  Created by Konstantin Snegov on 15/11/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNGPhotoProvider.h"

@interface SNGPhotoFlickrProvider : SNGPhotoProvider

/// Request photo list, which were taken near location, from all photo providers
+ (NSOperation *)requestPhotoListForLatitude:(double)latitude Longitude:(double)longitude withCompletionHandler:(void(^)(NSArray *photos))completionHandler failure:(void(^)(NSError *error))failureHandler;

@end
