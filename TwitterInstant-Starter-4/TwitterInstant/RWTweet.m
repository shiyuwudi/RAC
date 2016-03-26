//
//  RWTweet.m
//  TwitterInstant
//
//  Created by Colin Eberhardt on 05/01/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import "RWTweet.h"
#import "YYModel.h"

@implementation RWTweet

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"status" : @"text",
             @"profileImageUrl" : @"user.profile_image_url",
             @"username" : @"user.screen_name",
             };
}

@end
