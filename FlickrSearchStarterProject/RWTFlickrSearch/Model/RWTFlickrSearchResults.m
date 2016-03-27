//
//  RWTFlickrSearchResults.m
//  RWTFlickrSearch
//
//  Created by apple2 on 16/3/27.
//  Copyright © 2016年 Colin Eberhardt. All rights reserved.
//

#import "RWTFlickrSearchResults.h"

@implementation RWTFlickrSearchResults

- (NSString *)description {
    return [NSString stringWithFormat:@"searchString=%@, totalresults=%lu, photos=%@",
            self.searchString, (unsigned long)self.totalResults, self.photos];
}

@end
