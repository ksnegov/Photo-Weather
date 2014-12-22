//
//  SNGPhotoFlickrProvider.m
//  WeatherNearYou
//
//  Created by Konstantin Snegov on 15/11/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import "SNGPhotoFlickrProvider.h"
#import <AFNetworking/AFNetworking.h>
#import "SNGPhoto.h"

@implementation SNGPhotoFlickrProvider

#pragma mark -
#pragma mark Constants

static NSString * const SNGPhotoFlickrProviderPhotoCount = @"200";
static NSString * const SNGPhotoFlickrProviderAPIURL = @"https://api.flickr.com/services/rest";
static NSString * const SNGPhotoFlickrProviderAPIKey = @"b4d5bbd0cddadc6fb68a6c4dcedfe569";
static NSString * const SNGPhotoFlickrProviderMethodPhotoSearch = @"flickr.photos.search";
static NSString * const SNGPhotoFlickrProviderParamLatitude = @"lat";
static NSString * const SNGPhotoFlickrProviderParamLongitude = @"lon";
static NSString * const SNGPhotoFlickrProviderParamPhotosPerPage = @"per_page";
static NSString * const SNGPhotoFlickrProviderParamPhotoHasGeo = @"has_geo";
static NSString * const SNGPhotoFlickrProviderParamPhotoSize = @"b";
static NSString * const SNGPhotoFlickrProviderKeyFarm = @"farm";
static NSString * const SNGPhotoFlickrProviderKeyServer = @"server";
static NSString * const SNGPhotoFlickrProviderKeyPhotoId = @"id";
static NSString * const SNGPhotoFlickrProviderKeyPhotoSecret = @"secret";
static NSString * const SNGPhotoFlickrProviderKeyPhotos = @"photos";
static NSString * const SNGPhotoFlickrProviderKeyPhoto = @"photo";
static NSString * const SNGPhotoFlickrProviderKeyOwner = @"owner";

#pragma mark -
#pragma mark Paths for api

/// Returs path for method with params
+ (NSString *)pathForMethod:(NSString *)method withParams:(NSDictionary *)params {
    NSString *path = [NSString stringWithFormat:@"%@?method=%@&api_key=%@&per_page=20&media=photos&nojsoncallback=1&format=json", SNGPhotoFlickrProviderAPIURL, method, SNGPhotoFlickrProviderAPIKey];
    for (NSString *key in [params allKeys]) {
        if (params[key]) {
            path = [NSString stringWithFormat:@"%@&%@=%@", path, key, params[key]];
        }
    }
    return path;
}

/// Returns path for photo on Flickr from dictionary, which was recieved from Flickr
+ (NSString *)pathForPhoto:(NSDictionary *)photoDictionary {
    NSString *path = [NSString stringWithFormat:@"https://farm%@.staticFlickr.com/%@/%@_%@_%@.jpg", photoDictionary[SNGPhotoFlickrProviderKeyFarm], photoDictionary[SNGPhotoFlickrProviderKeyServer], photoDictionary[SNGPhotoFlickrProviderKeyPhotoId], photoDictionary[SNGPhotoFlickrProviderKeyPhotoSecret], SNGPhotoFlickrProviderParamPhotoSize];
    return path;
}


#pragma mark -
#pragma mark Operations

/// Request photo list, which were taken near location, from all photo providers
+ (NSOperation *)requestPhotoListForLatitude:(double)latitude Longitude:(double)longitude withCompletionHandler:(void(^)(NSArray *photos))completionHandler failure:(void(^)(NSError *error))failureHandler {
    NSDictionary *params = @{ SNGPhotoFlickrProviderParamLatitude : [NSString stringWithFormat:@"%.2f", latitude],
                              SNGPhotoFlickrProviderParamLongitude : [NSString stringWithFormat:@"%.2f", longitude],
                              SNGPhotoFlickrProviderParamPhotosPerPage : SNGPhotoFlickrProviderPhotoCount,
                              SNGPhotoFlickrProviderParamPhotoHasGeo : @"1"
                            };
    NSString *path = [self pathForMethod:SNGPhotoFlickrProviderMethodPhotoSearch withParams:params];
    NSURL *url = [NSURL URLWithString:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *photos = [[NSMutableArray alloc] init];
        NSDictionary *result = (NSDictionary *)responseObject;
        NSDictionary *photosDictionary = result[SNGPhotoFlickrProviderKeyPhotos];
        for (NSDictionary *photoDictionary in photosDictionary[SNGPhotoFlickrProviderKeyPhoto]) {
            NSString *photoPath = [self pathForPhoto:photoDictionary];
            NSString *owner = photoDictionary[SNGPhotoFlickrProviderKeyOwner];
            SNGPhoto *photo = [[SNGPhoto alloc] initWithPath:photoPath Data:nil andAuthor:owner];
            [photos addObject:photo];
        }
        completionHandler([photos copy]);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureHandler(error);
    }];
    
    return operation;
}

@end
