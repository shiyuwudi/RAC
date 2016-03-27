//
//  RWTFlickrSearchViewModel.m
//  RWTFlickrSearch
//
//  Created by apple2 on 16/3/27.
//  Copyright © 2016年 Colin Eberhardt. All rights reserved.
//

#import "RWTFlickrSearchViewModel.h"

@implementation RWTFlickrSearchViewModel

-(instancetype)init{
    if (self = [super init]) {
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
    
    [validSearchSignal subscribeNext:^(NSNumber *valid) {
        NSLog(@"%@",[valid boolValue] ? @"yes" : @"no");
    }];
    
    self.executeSearch = [[RACCommand alloc] initWithEnabled:validSearchSignal
                            signalBlock:^RACSignal *(id input) {
                                return [self executeSearchSignal];
                            }];
}

- (RACSignal *)executeSearchSignal {
    //业务逻辑部分(网络请求)
    return [[[[RACSignal empty] logAll] delay:2.0] logAll];
}

- (BOOL)isValidSearchText:(NSString *)text {
    return text.length > 3;
}

@end
