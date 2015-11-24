//
//  LoginModel.m
//  WlianWorld
//
//  Created by xmfish on 15/11/16.
//  Copyright © 2015年 ash. All rights reserved.
//

#import "LoginModel.h"
#import "LoginViewModel.h"
@implementation LoginModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:[super JSONKeyPathsByPropertyKey]];
    [dic setObject:@"info.msg" forKey:@"msg"];
    [dic setObject:@"info.status" forKey:@"status"];
    [dic setObject:@"info.userinfo.userid" forKey:@"userid"];
    [dic setObject:@"info.userinfo.username" forKey:@"username"];
    [dic setObject:@"info.userinfo.shopid" forKey:@"shopid"];
    [dic setObject:@"info.userinfo.shopname" forKey:@"shopname"];
    [dic setObject:@"info.userinfo.token" forKey:@"token"];
    return dic;
}
- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error
{
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self != nil)
    {
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
    }
    
    return self;
}

-(RACSignal*)loginSignalWithAccount:(NSString *)account withPassword:(NSString *)password
{
    RACSignal* singnal = [BaseWLService requireWithProperty:[self requireWithDic:[NSDictionary dictionaryWithObjectsAndKeys:account,@"username",password,@"password", nil] ]];
    
    return singnal;
}
-(BaseEntity*)requireWithDic:(NSDictionary *)dic
{
    BaseEntity *pro = [[BaseEntity alloc] init];
    pro.requireType = HTTPRequestTypeWithPOST;
    pro.responesOBJ = self.class;
    pro.reqURL = @"";
    pro.callback = @"user.login";
    pro.pro = dic;
    return pro;
}

@end
