//
//  RWTFlickrSearchViewModel.h
//  RWTFlickrSearch
//
//  Created by apple2 on 16/3/27.
//  Copyright © 2016年 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWTViewModelServices.h"

@interface RWTFlickrSearchViewModel : NSObject

@property (nonatomic, copy)NSString *searchText;//search text field
@property (nonatomic, copy)NSString *title;//title of navigation bar

@property (strong, nonatomic) RACCommand *executeSearch;//search button

- (instancetype)initWithServices:(id<RWTViewModelServices>)services;

@end
