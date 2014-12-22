//
//  SNGPhoto.h
//  WeatherNearYou
//
//  Created by Konstantin Snegov on 15/11/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNGPhoto : NSObject

@property (strong, nonatomic) NSString *author;
@property (strong, nonatomic) NSString *path;
@property (strong, nonatomic) NSData *photoData;


/// Designated initializer
- (instancetype)initWithPath:(NSString *)path Data:(NSData *)data andAuthor:(NSString *)author;

@end
