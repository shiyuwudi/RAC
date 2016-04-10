//
//  RWTFlickrPhotoMetadata.m
//  RWTFlickrSearch
//
//  Created by apple2 on 16/4/10.
//  Copyright © 2016年 Colin Eberhardt. All rights reserved.
//

#import "RWTFlickrPhotoMetadata.h"

@implementation RWTFlickrPhotoMetadata

-(NSString *)description{
    return [NSString stringWithFormat:@"图片元数据: 评价数: %ld;收藏数: %ld",(long)self.comments, (long)self.favorites];
}

@end
