//
//  RWTSearchResultsCellViewModel.h
//  RWTFlickrSearch
//
//  Created by apple2 on 16/4/10.
//  Copyright © 2016年 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWTFlickrPhoto.h"
#import "RWTViewModelServices.h"

@interface RWTSearchResultsCellViewModel : NSObject //是结果控制器tableView中cell的view model

- (instancetype) initWithPhoto:(RWTFlickrPhoto *)photo services:(id<RWTViewModelServices>)services;

//cell status (for we only need to request metadata for visible cells)
@property (nonatomic) BOOL isVisible;

//picture (done requesting)
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSURL *url;

//metadata of picture above (need to request)
@property (nonatomic, strong) NSNumber *favorites;
@property (nonatomic, strong) NSNumber *comments;

@end
