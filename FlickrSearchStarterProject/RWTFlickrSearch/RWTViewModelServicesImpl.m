//
//  RWTViewModelServicesImpl.m
//  RWTFlickrSearch
//
//  Created by apple2 on 16/3/27.
//  Copyright © 2016年 Colin Eberhardt. All rights reserved.
//

#import "RWTViewModelServicesImpl.h"
#import "RWTFlickrSearchImpl.h" //实现的具体网络搜索方法
#import "RWTSearchResultsViewController.h"
#import "RWTSearchResultsViewModel.h"

@interface RWTViewModelServicesImpl ()

@property (nonatomic, strong) RWTFlickrSearchImpl *searchService;
@property (nonatomic, weak) UINavigationController *navigationController;

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

-(instancetype)initWithNavigationController:(UINavigationController *)navi{
    if (self = [super init]) {
        _searchService = [RWTFlickrSearchImpl new];
        _navigationController = navi;
    }
    return self;
}

-(void)pushViewModel:(id)viewModel{
    id viewController;
    if ([viewModel isKindOfClass:RWTSearchResultsViewModel.class]) {
        viewController = [[RWTSearchResultsViewController alloc]initWithViewModel:viewModel];
    } else {
        NSLog(@"push了一个未知的view model");
    }
    [self.navigationController pushViewController:viewController animated:YES];
}


@end
