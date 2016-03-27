//
//  RWTFlickrSearch.h
//  RWTFlickrSearch
//
//  Created by apple2 on 16/3/27.
//  Copyright © 2016年 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RWTFlickrSearch <NSObject>

- (RACSignal *)flickerSearchSignal:(NSString *)text;

@end
