//
//  SNGPhotoProvider.h
//  WeatherNearYou
//
//  Created by Konstantin Snegov on 15/11/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNGPhotoProvider : NSObject

/// Request photo list, which were taken near location, from all photo providers
+ (NSOperation *)requestPhotoListForLatitude:(double)latitude Longitude:(double)longitude withCompletionHandler:(void(^)(NSArray *photos))completionHandler failure:(void(^)(NSError *error))failureHandler;

/// Request photo
+ (NSOperation *)requestPhotoFrom:(NSString *)path withCompletionHandler:(void(^)(NSData *photoData))completionHandler failure:(void(^)(NSError *error))failureHandler;


@end
