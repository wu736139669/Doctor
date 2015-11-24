//
//  LoginViewModel.m
//  WlianWorld
//
//  Created by xmfish on 15/11/13.
//  Copyright © 2015年 ash. All rights reserved.
//

#import "LoginViewModel.h"

@interface LoginViewModel()

@end

@implementation LoginViewModel

-(id)init
{
    self = [super init];
    
    if (self)
    {
        self.model = [[LoginModel alloc] init];
        [self initialize];
    }
    
    return self;
}


- (void)initialize
{
    
    self.model.title = @"登陆";
    
    self.validLoginSignal = [[RACSignal combineLatest:@[RACObserve(self, account),RACObserve(self, password)] reduce:^id(NSString* account,NSString* password){
        return @( (account.length>1) && (password.length>1) );
    }] distinctUntilChanged];
    
    
    self.executeLogin = [[RACCommand alloc] initWithEnabled:self.validLoginSignal
                                                 signalBlock:^RACSignal *(id input) {
                                                     return [self executeSearchSignal];
                                                 }];
}


- (RACSignal *)executeSearchSignal {
    
    return [[self.model loginSignalWithAccount:self.account withPassword:self.password] doNext:^(id result) {
        self.model = result;
    }];
}

@end
