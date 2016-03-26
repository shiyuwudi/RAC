//
//  RWSearchFormViewController.m
//  TwitterInstant
//
//  Created by Colin Eberhardt on 02/12/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "RWSearchFormViewController.h"
#import "RWSearchResultsViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACExtScope.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "YYModel.h"
#import "UIImageView+WebCache.h"
#import "RWTweet.h"

typedef NS_ENUM(NSInteger, RWTwitterInstantError) {
    RWTwitterInstantErrorAccessDenied,
    RWTwitterInstantErrorNoTwitterAccounts,
    RWTwitterInstantErrorInvalidResponse
};

static NSString * const RWTwitterInstantDomain = @"TwitterInstant";

@interface RWSearchFormViewController ()

@property (weak, nonatomic) IBOutlet UITextField *searchText;

@property (strong, nonatomic) RWSearchResultsViewController *resultsViewController;

@property (strong, nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic) ACAccountType *twitterAccountType;

@end

@implementation RWSearchFormViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.title = @"Twitter Instant";
  
  [self styleTextField:self.searchText];
  
  self.resultsViewController = self.splitViewController.viewControllers[1];
  
    __weak RWSearchFormViewController *blockSelf =self;
    RAC(self.searchText, backgroundColor) = [[self.searchText.rac_textSignal map:^id(NSString *text) {
        return @([blockSelf isValidSearchText:text]);
    }] map:^id(NSNumber *valid) {
        return [valid boolValue] ? [UIColor whiteColor] : [UIColor yellowColor];
    }];
    
    self.accountStore = [ACAccountStore new];
    self.twitterAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [[[[[[[self requestToAccessTwitterAccountSignal] then:^RACSignal *{
        return blockSelf.searchText.rac_textSignal;
    }] filter:^BOOL(NSString *text) {
        return [blockSelf isValidSearchText:text];//主线程
    }] throttle:0.5] flattenMap:^RACStream *(NSString *text) {
        return [blockSelf searchTwitterSignal:text];//主线程
    }] deliverOn:[RACScheduler mainThreadScheduler]]//切换回主线程
     
     subscribeNext:^(NSDictionary *timeLineDict) {
         NSArray *tweets = [NSArray yy_modelArrayWithClass:[RWTweet class] json:timeLineDict[@"statuses"]];
         [self.resultsViewController displayTweets:tweets];
    }
     error:^(NSError *error) {
        NSLog(@"错误原因:%@",error);
    }];
}

- (void)styleTextField:(UITextField *)textField {
  CALayer *textFieldLayer = textField.layer;
  textFieldLayer.borderColor = [UIColor grayColor].CGColor;
  textFieldLayer.borderWidth = 2.0f;
  textFieldLayer.cornerRadius = 0.0f;
}

- (BOOL)isValidSearchText:(NSString *)text {
    return text.length > 2;
}

//申请推特账户访问授权
- (RACSignal *)requestToAccessTwitterAccountSignal {
    
    //1. 定义错误类型
    NSError *accessDeniedError = [NSError errorWithDomain:RWTwitterInstantDomain
                                                     code:RWTwitterInstantErrorAccessDenied
                                                 userInfo:nil];
    
    //2. 创建信号
    RACSignal * s = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        //3. 申请权限
        [self.accountStore requestAccessToAccountsWithType:self.twitterAccountType options:nil completion:^(BOOL granted, NSError *error) {
            //4. 处理响应
            if (granted) {
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:accessDeniedError];
            }
        }];
        return nil;
    }];
    
    return s;
}

//推特搜索请求

- (SLRequest *)requestforTwitterSearchWithText:(NSString *)text {
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/search/tweets.json"];
    NSDictionary *params = @{@"q" : text};
    
    SLRequest *request =  [SLRequest requestForServiceType:SLServiceTypeTwitter
                                             requestMethod:SLRequestMethodGET
                                                       URL:url
                                                parameters:params];
    return request;
}

//把请求包装成信号

- (RACSignal *)searchTwitterSignal:(NSString *)text {
    
    //1.声明错误
    NSError *noTwitterAccountsError = [NSError errorWithDomain:RWTwitterInstantDomain
                                                          code:RWTwitterInstantErrorNoTwitterAccounts
                                                      userInfo:nil];
    
    __weak RWSearchFormViewController *blockSelf = self;
    
    //3.创建信号
    RACSignal *s = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        //3.5获取所有推特账号
        SLRequest *searchRequest = [blockSelf requestforTwitterSearchWithText:text];
        NSArray *accounts = [blockSelf.accountStore accountsWithAccountType:blockSelf.twitterAccountType];
        if (accounts.count == 0) {
            [subscriber sendError:noTwitterAccountsError];
        } else {
            //4.发送请求
            ACAccount *oneAccount = [accounts lastObject];
            [searchRequest setAccount:oneAccount];
            [searchRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                if (urlResponse.statusCode == 200) {
                    NSDictionary *timeLineData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:NULL];
                    [subscriber sendNext:timeLineData];
                    [subscriber sendCompleted];
                } else {
                    NSError *invalidResponseError = [NSError errorWithDomain:RWTwitterInstantDomain
                                                                        code:RWTwitterInstantErrorInvalidResponse
                                                                    userInfo:@{@"resp code":@(urlResponse.statusCode)}];
                    [subscriber sendError:invalidResponseError];
                }
            }];
        }
        return nil;
    }];
    
    return s;
}

@end
