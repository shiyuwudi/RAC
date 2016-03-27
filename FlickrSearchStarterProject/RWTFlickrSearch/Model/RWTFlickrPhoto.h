//
//  RWTFlickrPhoto.h
//  RWTFlickrSearch
//
//  Created by apple2 on 16/3/27.
//  Copyright © 2016年 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWTFlickrPhoto : NSObject

@property (copy, nonatomic) NSString *title;
@property (strong, nonatomic) NSURL *url;
@property (copy, nonatomic) NSString *identifier;

@end
