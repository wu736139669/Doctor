//
//  LoginModel.h
//  WlianWorld
//
//  Created by xmfish on 15/11/16.
//  Copyright © 2015年 ash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface LoginModel : BaseModel

@property (nonatomic,readonly)  NSNumber* status;
@property (nonatomic, readonly) NSString *msg;
@property (nonatomic,readonly)  NSString* userid;
@property (nonatomic, readonly) NSString *username;
@property (nonatomic,readonly)  NSString* shopid;
@property (nonatomic, readonly) NSString *shopname;
@property (nonatomic,readonly)  NSString* token;
- (RACSignal*)loginSignalWithAccount:(NSString*)account withPassword:(NSString*)password;

@end
