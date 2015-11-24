//
//  BaseAPIClient.m
//  WlianWorld
//
//  Created by xmfish on 15/11/13.
//  Copyright © 2015年 ash. All rights reserved.
//

#import "BaseAPIClient.h"

@implementation BaseAPIClient


+ (instancetype)sharedClient
{
    static BaseAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[BaseAPIClient alloc] initWithBaseURL:[NSURL URLWithString:[self getApiBaseString]]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
        [_sharedClient.requestSerializer setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
    });
    
    return _sharedClient;
}

+ (NSString *)getApiBaseString
{
    return  WL_DEV_API_URL;
}
@end
