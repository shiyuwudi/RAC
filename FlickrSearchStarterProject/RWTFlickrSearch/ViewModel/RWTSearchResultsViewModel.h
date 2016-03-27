//
//  RWTSearchResultsViewModel.h
//  RWTFlickrSearch
//
//  Created by apple2 on 16/3/27.
//  Copyright © 2016年 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWTViewModelServices.h"
#import "RWTFlickrSearchResults.h"

@interface RWTSearchResultsViewModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray *results;

- (instancetype)initWithSearchResults:(RWTFlickrSearchResults *)searchResults services:(id<RWTViewModelServices>)services;

@end
