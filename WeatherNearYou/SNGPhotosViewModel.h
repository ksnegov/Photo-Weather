//
//  SNGPhotosViewModel.h
//  WeatherNearYou
//
//  Created by Konstantin Snegov on 16/11/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol SNGPhotosViewModelDelegate <NSObject>
@required
- (void)photoDidRecieved;
@optional
- (void)photoDidFailureRequest:(NSError *)error;
@end


@interface SNGPhotosViewModel : NSObject
@property (weak, nonatomic) id<SNGPhotosViewModelDelegate> delegate;
@property (assign, nonatomic) double latitude;
@property (assign, nonatomic) double longitude;
@property (strong, nonatomic, readonly) UIImage *photo;
@property (strong, nonatomic, readonly) UIColor *preferredTextColor;

/// Initialize with coordinates
- (instancetype)initWithLatitude:(double)latitude andLongitude:(double)longitude;

/// Start showing photos
- (void)requestRandomPhoto;

/// Stop downloading photos
- (void)stopDownloadingPhotos;

@end
