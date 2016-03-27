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
    
    RACSignal *validSearchTextSignal = [[RACObserve(self, searchText) map:^id(NSString *text) {
        return @([bSelf isValidSearchText:text]);
    }] distinctUntilChanged];
    
    [validSearchTextSignal subscribeNext:^(NSNumber *valid) {
        NSLog(@"%@",[valid boolValue] ? @"yes" : @"no");
    }];
}

- (BOOL) isValidSearchText:(NSString *)text {
    return text.length > 3;
}

@end
