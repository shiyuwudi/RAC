//
//  RWTViewModelServicesImpl.m
//  RWTFlickrSearch
//
//  Created by apple2 on 16/3/27.
//  Copyright © 2016年 Colin Eberhardt. All rights reserved.
//

#import "RWTViewModelServicesImpl.h"
#import "RWTFlickrSearchImpl.h" //实现的具体网络搜索方法

@interface RWTViewModelServicesImpl ()

@property (nonatomic, strong) RWTFlickrSearchImpl *searchService;

@end

@implementation RWTViewModelServicesImpl

-(instancetype)init{
    self = [super init];
    if (self) {
        _searchService = [RWTFlickrSearchImpl new];
    }
    return self;
}

-(id<RWTFlickrSearch>)getFlickrSearchService {
    return self.searchService;
}

@end
