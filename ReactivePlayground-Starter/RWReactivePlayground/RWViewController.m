//
//  RWViewController.m
//  RWReactivePlayground
//
//  Created by Colin Eberhardt on 18/12/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "RWViewController.h"
#import "RWDummySignInService.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface RWViewController ()//85 lines -> 87 lines

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UILabel *signInFailureText;

@property (strong, nonatomic) RWDummySignInService *signInService;

@end

@implementation RWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.signInService = [RWDummySignInService new];
    
    // initially hide the failure message
    self.signInFailureText.hidden = YES;
    
    RACSignal *verifyUsernameSignal = [self.usernameTextField.rac_textSignal map:^id(NSString *text) {
        return @([self isValidUsername:text]);
    }];
    
    RACSignal *verifyPasswordSignal = [self.passwordTextField.rac_textSignal map:^id(NSString *text) {
        return @([self isValidPassword:text]);
    }];
    
    RAC(self.usernameTextField, backgroundColor) = [verifyUsernameSignal map:^id(NSNumber *num) {
        return [num boolValue] ? [UIColor clearColor] : [UIColor yellowColor];
    }];
    
    RAC(self.passwordTextField, backgroundColor) = [verifyPasswordSignal map:^id(NSNumber *num) {
        return [num boolValue] ? [UIColor clearColor] : [UIColor yellowColor];
    }];
    
    RACSignal *signUpEnableSignal = [RACSignal combineLatest:@[verifyPasswordSignal, verifyUsernameSignal] reduce:^id(NSNumber *passwordOK, NSNumber *usernameOK){
        return @([passwordOK boolValue] && [usernameOK boolValue]);
    }];
    
    RAC(self.signInButton, enabled) = signUpEnableSignal;

    [[[[self.signInButton rac_signalForControlEvents:UIControlEventTouchUpInside] doNext:^(id x) {
        self.signInFailureText.hidden = YES;
        self.signInButton.enabled = NO;
    }] flattenMap:^id(id x) {
        return [self signInSignal];
    }] subscribeNext:^(NSNumber *flag) {
        BOOL success = [flag boolValue];
        self.signInFailureText.hidden = success;
        self.signInButton.enabled = YES;
        if (success) {
            [self performSegueWithIdentifier:@"signInSuccess" sender:self];
        }
    }];
}

- (RACSignal *)signInSignal {
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self.signInService signInWithUsername:self.usernameTextField.text password:self.passwordTextField.text complete:^(BOOL passed) {
            [subscriber sendNext:@(passed)];
            [subscriber sendCompleted];
        }];
        return nil; // no RACDisposable needed at this time
    }];
    return signal;
}

- (BOOL)isValidUsername:(NSString *)username {
  return username.length > 3;
}

- (BOOL)isValidPassword:(NSString *)password {
  return password.length > 3;
}

@end
