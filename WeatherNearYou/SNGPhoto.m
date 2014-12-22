//
//  SNGPhoto.m
//  WeatherNearYou
//
//  Created by Konstantin Snegov on 15/11/14.
//  Copyright (c) 2014 Konstantin Snegov. All rights reserved.
//

#import "SNGPhoto.h"

@implementation SNGPhoto

/// Designated initializer
- (instancetype)initWithPath:(NSString *)path Data:(NSData *)data andAuthor:(NSString *)author {
    self = [super init];
    if (self) {
        _path = path;
        _photoData = data;
        _author = author;
    }
    return self;
}

#pragma mark -
#pragma mark NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ : %@", self.author, self.path];
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[self class]]) {
        SNGPhoto *photo = (SNGPhoto *)object;
        return [self.path isEqualToString:photo.path];
    } else {
        return NO;
    }
}

@end
