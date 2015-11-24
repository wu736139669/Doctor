//
//  BaseAPIClient.h
//  WlianWorld
//
//  Created by xmfish on 15/11/13.
//  Copyright © 2015年 ash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"


@interface BaseAPIClient : AFHTTPRequestOperationManager

+ (instancetype)sharedClient;
+ (NSString *)getApiBaseString;

@end
