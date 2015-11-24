//
//  LoginViewModel.h
//  WlianWorld
//
//  Created by xmfish on 15/11/13.
//  Copyright © 2015年 ash. All rights reserved.
//

#import "BaseViewModel.h"
#import "LoginModel.h"
@interface LoginViewModel : BaseViewModel

@property (nonatomic,strong) NSString* account;
@property (nonatomic,strong) NSString* password;

@property (strong, nonatomic) RACCommand *executeLogin;
@property (strong, nonatomic)RACSignal* validLoginSignal;

@property (nonatomic, strong)LoginModel* model;



@end
