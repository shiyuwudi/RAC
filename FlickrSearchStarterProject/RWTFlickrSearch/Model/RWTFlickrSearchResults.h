//
//  RWTFlickrSearchResults.h
//  RWTFlickrSearch
//
//  Created by apple2 on 16/3/27.
//  Copyright © 2016年 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWTFlickrSearchResults : NSObject

@property (copy, nonatomic) NSString *searchString;
@property (strong, nonatomic) NSArray *photos;
@property (assign ,nonatomic) NSUInteger totalResults;

@end
