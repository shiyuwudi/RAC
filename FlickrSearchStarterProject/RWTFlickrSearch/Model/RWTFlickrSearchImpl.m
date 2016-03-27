//
//  RWTFlickrSearchImpl.m
//  RWTFlickrSearch
//
//  Created by apple2 on 16/3/27.
//  Copyright © 2016年 Colin Eberhardt. All rights reserved.
//

#import "RWTFlickrSearchImpl.h"

@implementation RWTFlickrSearchImpl

- (RACSignal *)flickerSearchSignal:(NSString *)text {
    return [[[[RACSignal empty] logAll] delay:2.0] logAll];
}

@end
