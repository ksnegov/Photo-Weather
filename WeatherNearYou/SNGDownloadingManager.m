//
//  SNGDownloadingManager.m
//  WeatherNearYou
//
//  Created by Konstantin Snegov on 13/11/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import "SNGDownloadingManager.h"
#import "SNGWeatherProvider.h"
#import "SNGPhotoFlickrProvider.h"

@interface SNGDownloadingManager()

@property (strong, nonatomic) NSOperationQueue *downloadingQueue;

@end

@implementation SNGDownloadingManager

#pragma mark -
#pragma mark Constants

static const NSInteger SNGDownloadingManagerSimultaneouslyTaskDownloading = 3;
static NSString * const SNGDownloadingManagerWeatherRequestName = @"Weather request";
static NSString * const SNGDownloadingManagerWeatherForecastRequestName = @"Weather forecast request";

#pragma mark -
#pragma mark Getters

- (NSOperationQueue *)downloadingQueue {
    if (!_downloadingQueue) {
        _downloadingQueue = [[NSOperationQueue alloc] init];
        _downloadingQueue.name = @"Download queue";
        _downloadingQueue.maxConcurrentOperationCount = SNGDownloadingManagerSimultaneouslyTaskDownloading;
    }
    return _downloadingQueue;
}

#pragma mark -
#pragma mark Singlton

+ (SNGDownloadingManager *)sharedManager {
    static SNGDownloadingManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SNGDownloadingManager alloc] initPrivate];
    });
    return manager;
}

#pragma mark -
#pragma mark Initializers

- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton" reason:@"This class is singleton. Use class method instead." userInfo:nil];
}

/// Designated initializer
- (instancetype)initPrivate {
    self = [super init];
    return self;
}

#pragma mark -
#pragma mark Queues operations

/// Stop all tasks in queue
- (void)stopTasks {
    [self.downloadingQueue cancelAllOperations];
}

/// Stop photo tasks
- (void)stopPhotoTasks {
    for (NSOperation *operation in self.downloadingQueue.operations) {
        if ([operation.name isEqualToString:SNGDownloadingManagerWeatherForecastRequestName]) {
            [operation cancel];
        } else {
            NSRange range = [operation.name rangeOfString:@"photo"];
            if (range.length > 0) {
                [operation cancel];
            }
        }
    }
}

/// Stop weather tasks
- (void)stopWeatherTasks {
    for (NSOperation *operation in self.downloadingQueue.operations) {
        if ([operation.name isEqualToString:SNGDownloadingManagerWeatherRequestName]) {
            [operation cancel];
        }
    }
}

/// Add operation for downloading into the queue
- (void)addOperation:(NSOperation *)operation {
    for (NSOperation *operationInQueue in self.downloadingQueue.operations) {
        if ([operationInQueue.name isEqualToString:operation.name]) {
            [operationInQueue cancel];
        }
    }
    [self.downloadingQueue addOperation:operation];
}

/// Add operations for downloading into the queue
- (void)addOperations:(NSArray *)operations {
    for (id operation in operations) {
        if ([operation isKindOfClass:[NSOperation class]]) {
            [self addOperation:operation];
        }
    }
}

#pragma mark -
#pragma mark Weather operations

/// Request current weather for Location
- (void)requestCurrentWeatherForLatitude:(double)latitude Longitude:(double)longitude withCompletionHandler:(void (^)(SNGWeather *))completionHandler failure:(void (^)(NSError *))failureHandler {
    NSOperation *operation = [SNGWeatherProvider requestCurrentWeatherForLatitude:latitude Longitude:longitude withCompletionHandler:completionHandler failure:failureHandler];
    operation.queuePriority = NSOperationQueuePriorityHigh;
    operation.name = SNGDownloadingManagerWeatherRequestName;
    [self addOperation:operation];
}

/// Request weather forecast for next hours using Location
- (void)requestWeatherForecastForNextHours:(NSUInteger)hours ForLatitude:(double)latitude Longitude:(double)longitude withCompletionHandler:(void (^)(NSArray *))completionHandler failure:(void (^)(NSError *))failureHandler {
    NSOperation *operation = [SNGWeatherProvider requestWeatherForecastForNextHours:hours ForLatitude:latitude Longitude:longitude withCompletionHandler:completionHandler failure:failureHandler];
    operation.queuePriority = NSOperationQueuePriorityNormal;
    operation.name = SNGDownloadingManagerWeatherForecastRequestName;
    [self addOperation:operation];
}

#pragma mark -
#pragma mark Photos operations

- (NSArray *)photoProviders {
    return @[ [SNGPhotoFlickrProvider class] ];
}

/// Request photo list, which were taken near location, from all photo providers
- (void)requestPhotoListForLatitude:(double)latitude Longitude:(double)longitude withCompletionHandler:(void(^)(NSArray *photos))completionHandler failure:(void(^)(NSError *error))failureHandler {
    for (Class provider in [self photoProviders]) {
        NSOperation *operation = [provider requestPhotoListForLatitude:latitude Longitude:longitude withCompletionHandler:completionHandler failure:failureHandler];
        operation.queuePriority = NSOperationQueuePriorityNormal;
        operation.name = [NSString stringWithFormat:@"%@ photo list", provider];
        [self addOperation:operation];
    }
}

/// Request photo
- (void)requestPhotoFrom:(NSString *)path withCompletionHandler:(void(^)(NSData *photoData))completionHandler failure:(void(^)(NSError *error))failureHandler {
    NSOperation *operation = [SNGPhotoProvider requestPhotoFrom:path withCompletionHandler:completionHandler failure:failureHandler];
    operation.queuePriority = NSOperationQueuePriorityLow;
    operation.name = [NSString stringWithFormat:@"%@", path];
    [self addOperation:operation];
}


@end
