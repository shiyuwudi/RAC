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

@interface RWTSearchResultsViewModel : NSObject//是控制器的view model

@property (nonatomic, copy) NSString *title;//结果控制器的标题
@property (nonatomic, strong) NSArray *searchResults;//结果控制器的图片数组

- (instancetype)initWithSearchResults:(RWTFlickrSearchResults *)searchResults services:(id<RWTViewModelServices>)services;

@end
