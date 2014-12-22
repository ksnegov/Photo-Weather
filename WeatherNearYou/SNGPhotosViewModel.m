//
//  SNGPhotosViewModel.m
//  WeatherNearYou
//
//  Created by Konstantin Snegov on 16/11/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import "SNGPhotosViewModel.h"
#import "SNGDownloadingManager.h"
#import "SNGPhoto.h"
#import "UIColor+SNGOppositeColor.h"
#import "UIImage+SNGAverageColor.h"

@interface SNGPhotosViewModel()
@property (strong, nonatomic, readwrite) UIImage *photo;
@property (strong, nonatomic, readwrite) UIColor *preferredTextColor;
@property (strong, nonatomic) NSMutableArray *photos;
@property (strong, nonatomic) NSMutableArray *shownPhotos;
@property (atomic, getter=shouldRequestPhotos) BOOL requestPhotos;
@end

@implementation SNGPhotosViewModel

#pragma mark -
#pragma mark Getters

- (NSMutableArray *)photos {
    if (!_photos) {
        _photos = [[NSMutableArray alloc] init];
    }
    return _photos;
}

- (NSMutableArray *)shownPhotos {
    if (!_shownPhotos) {
        _shownPhotos = [[NSMutableArray alloc] init];
    }
    return _shownPhotos;
}

#pragma mark -
#pragma mark Setters

- (void)setLatitude:(double)latitude {
    _latitude = latitude;
    [self.photos removeAllObjects];
    self.requestPhotos = YES;
}

- (void)setLongitude:(double)longitude {
    _longitude = longitude;
    [self.photos removeAllObjects];
    self.requestPhotos = YES;
}

#pragma mark -
#pragma mark Add new photos to array

/// Add new photos to photo waiting list and check if we already have these photos in waiting list or showing list
- (void)addPhotosToWaitingList:(NSArray *)newPhotos {
    for (SNGPhoto *newPhoto in newPhotos) {
        if (![self.photos containsObject:newPhoto] && ![self.shownPhotos containsObject:newPhoto]) {
            [self.photos addObject:newPhoto];
        }
    }
}

#pragma mark -
#pragma mark Initializers

/// Designated initilizer. Initialize with coordinates
- (instancetype)initWithLatitude:(double)latitude andLongitude:(double)longitude {
    self = [self init];
    if (self) {
        _latitude = latitude;
        _longitude = longitude;
        _requestPhotos = YES;
    }
    return self;
}

#pragma mark -
#pragma mark Downloading photos

/// Request random photo
- (void)requestRandomPhoto {
    if (self.shouldRequestPhotos) {
        [self requestPhotoList];
    } else {
        [self requestPhoto];
    }
}

/// Request photo
- (void)requestPhoto {
    if ([self.photos count] != 0) {
        SNGPhoto *photo = [self.photos firstObject];
        if (photo) {
            NSLog(@"%@", photo.path);
            [self.photos removeObject:photo];
            
            [[SNGDownloadingManager sharedManager] requestPhotoFrom:photo.path withCompletionHandler:^(NSData *photoData) {
                self.photo = [UIImage imageWithData:photoData];
                UIColor *averageColor = [self.photo averageColor];
                self.preferredTextColor = ([averageColor isDark]) ? [UIColor whiteColor] : [UIColor blackColor];
                [(NSObject *)self.delegate performSelectorOnMainThread:@selector(photoDidRecieved) withObject:nil waitUntilDone:NO];
                [self.shownPhotos addObject:photo];
            } failure:^(NSError *error) {
                [self.photos addObject:photo];
                if ([self respondsToSelector:@selector(photoDidFailureRequest:)]) {
                    [(NSObject *)self performSelectorOnMainThread:@selector(photoDidFailureRequest:) withObject:error waitUntilDone:NO];
                }
            }];
        }
    } else {
        self.photos = [self.shownPhotos mutableCopy];
        [self.shownPhotos removeAllObjects];
        if ([self.photos count] > 0) {
            [self requestPhoto];
        }
    }
}

/// Request photo list
- (void)requestPhotoList {
    [[SNGDownloadingManager sharedManager] requestPhotoListForLatitude:self.latitude Longitude:self.longitude withCompletionHandler:^(NSArray *photos) {
        NSLog(@"Get photo list");
        [self addPhotosToWaitingList:photos];
        
        if (self.shouldRequestPhotos) {
            self.requestPhotos = NO;
            [self requestPhoto];
        }
    } failure:^(NSError *error) {
        if ([self respondsToSelector:@selector(photoDidFailureRequest:)]) {
            [(NSObject *)self performSelectorOnMainThread:@selector(photoDidFailureRequest:) withObject:error waitUntilDone:NO];
        }
    }];
}

/// Stop downloading photos
- (void)stopDownloadingPhotos {
    [[SNGDownloadingManager sharedManager] stopPhotoTasks];
}

@end
