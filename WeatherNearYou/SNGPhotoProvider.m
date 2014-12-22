//
//  SNGPhotoProvider.m
//  WeatherNearYou
//
//  Created by Konstantin Snegov on 15/11/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import "SNGPhotoProvider.h"
#import <AFNetworking/AFNetworking.h>

@implementation SNGPhotoProvider

/// Request photo list, which were taken near location, from all photo providers. This is abstract method. Subclass should override it
+ (NSOperation *)requestPhotoListForLatitude:(double)latitude Longitude:(double)longitude withCompletionHandler:(void(^)(NSArray *photos))completionHandler failure:(void(^)(NSError *error))failureHandler {
    return nil;
}

/// Request photo
+ (NSOperation *)requestPhotoFrom:(NSString *)path withCompletionHandler:(void(^)(NSData *photoData))completionHandler failure:(void(^)(NSError *error))failureHandler {
    NSURL *url = [NSURL URLWithString:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *photoData = (NSData *)responseObject;
        completionHandler(photoData);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureHandler(error);
    }];
    return operation;
}


@end
