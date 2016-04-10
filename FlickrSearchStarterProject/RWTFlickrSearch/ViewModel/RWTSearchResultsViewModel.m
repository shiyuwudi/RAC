//
//  RWTSearchResultsViewModel.m
//  RWTFlickrSearch
//
//  Created by apple2 on 16/3/27.
//  Copyright © 2016年 Colin Eberhardt. All rights reserved.
//

#import "RWTSearchResultsViewModel.h"

@implementation RWTSearchResultsViewModel

-(instancetype)initWithSearchResults:(RWTFlickrSearchResults *)searchResults services:(id<RWTViewModelServices>)services {
    if (self = [super init]) {
        _title = searchResults.searchString;
        _searchResults = searchResults.photos;
    }
    return self;
}

@end
