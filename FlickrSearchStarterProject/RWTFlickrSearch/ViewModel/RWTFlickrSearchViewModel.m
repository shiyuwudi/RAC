//
//  RWTFlickrSearchViewModel.m
//  RWTFlickrSearch
//
//  Created by apple2 on 16/3/27.
//  Copyright © 2016年 Colin Eberhardt. All rights reserved.
//

#import "RWTFlickrSearchViewModel.h"
#import "RWTSearchResultsViewModel.h"

@interface RWTFlickrSearchViewModel ()

@property (nonatomic, weak) id<RWTViewModelServices> services;

@end

@implementation RWTFlickrSearchViewModel

-(instancetype)initWithServices:(id<RWTViewModelServices>)services {
    if (self = [super init]) {
        _services = services;
        [self setup];
    }
    return self;
}

- (void)setup {
    self.title = @"Flickr 搜索";
    
    __weak RWTFlickrSearchViewModel *bSelf = self;
    
    RACSignal *validSearchSignal = [[RACObserve(self, searchText) map:^id(NSString *text) {
        return @([bSelf isValidSearchText:text]);
    }] distinctUntilChanged];
    
    //点击事件
    self.executeSearch = [[RACCommand alloc] initWithEnabled:validSearchSignal
                            signalBlock:^RACSignal *(id input) {
                                return [bSelf executeSearchSignal];
                            }];
}

- (RACSignal *)executeSearchSignal {
    //返回搜索结果模型
    return [[[self.services getFlickrSearchService]
             flickerSearchSignal:self.searchText]
            doNext:^(RWTFlickrSearchResults *searchResults) {
                RWTSearchResultsViewModel *viewModel = [[RWTSearchResultsViewModel alloc]initWithSearchResults:searchResults services:self.services];
                [self.services pushViewModel:viewModel];
            }];
}

- (BOOL)isValidSearchText:(NSString *)text {
    return text.length > 3;
}

@end
