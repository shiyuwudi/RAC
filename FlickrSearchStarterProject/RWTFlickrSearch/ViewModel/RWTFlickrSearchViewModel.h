//
//  RWTFlickrSearchViewModel.h
//  RWTFlickrSearch
//
//  Created by apple2 on 16/3/27.
//  Copyright © 2016年 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWTFlickrSearchViewModel : NSObject

@property (nonatomic, copy)NSString *searchText;//search text field
@property (nonatomic, copy)NSString *title;//title of navigation bar

/*
 RACCommand is a ReactiveCocoa concept that represents a UI action. 
 It comprises a signal, which is the result of the UI action, 
 and the current state, which indicates whether the action is currently being executed.
 */
@property (strong, nonatomic) RACCommand *executeSearch;


@end
