//
//  RWTFlickrSearchImpl.m
//  RWTFlickrSearch
//
//  Created by apple2 on 16/3/27.
//  Copyright © 2016年 Colin Eberhardt. All rights reserved.
//

#import "RWTFlickrSearchImpl.h"
#import "RWTFlickrSearchResults.h"
#import "RWTFlickrPhoto.h"
#import <objectiveflickr/ObjectiveFlickr.h>
#import <LinqToObjectiveC/NSArray+LinqExtensions.h>

@interface RWTFlickrSearchImpl ()<OFFlickrAPIRequestDelegate>

@property (strong, nonatomic) NSMutableSet *requests;//引用请求避免提前释放
@property (strong, nonatomic) OFFlickrAPIContext *flickrContext;//账户信息

@end

@implementation RWTFlickrSearchImpl

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *OFSampleAppAPIKey = @"032c60217aababffb54641c1704b5ee8";
        NSString *OFSampleAppAPISharedSecret = @"130d7221e8a0743e";
        
        _flickrContext = [[OFFlickrAPIContext alloc] initWithAPIKey:OFSampleAppAPIKey
                                                       sharedSecret:OFSampleAppAPISharedSecret];
        _requests = [NSMutableSet new];
    }
    return  self;
}

//搜索请求的二次封装
- (RACSignal *)signalFromAPIMethod:(NSString *)method
                         arguments:(NSDictionary *)args
                         transform:(id (^)(NSDictionary *response))block {
    
    //1.创建信号
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        //2.创建请求,并引用
        OFFlickrAPIRequest *request = [[OFFlickrAPIRequest alloc]initWithAPIContext:self.flickrContext];
        request.delegate = self; //位置可能不对?
        [self.requests addObject:request];
        
        //3.创建代理回调信号
        RACSignal *requestFallbackSignal = [self rac_signalForSelector:@selector(flickrAPIRequest:didCompleteWithResponse:) fromProtocol:@protocol(OFFlickrAPIRequestDelegate)];
        
        //4.处理代理回调信号
        [[[requestFallbackSignal map:^id(RACTuple *parameters) {
            return parameters.second;
        }] map:block] subscribeNext:^(id x) {
            [subscriber sendNext:x];
            [subscriber sendCompleted];
        }];
        
        //5.发请求
        [request callAPIMethodWithGET:method arguments:args];
        
        //6.移除对请求的引用
        return [RACDisposable disposableWithBlock:^{
            [self.requests removeObject:request];
        }];
        
    }];
}

- (RACSignal *)flickerSearchSignal:(NSString *)text {
    return [[[[RACSignal empty] logAll] delay:2.0] logAll];
}

@end
