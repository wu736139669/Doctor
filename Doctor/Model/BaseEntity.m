//
//  BaseEntity.m
//  WlianWorld
//
//  Created by xmfish on 15/11/13.
//  Copyright © 2015年 ash. All rights reserved.
//

#import "BaseEntity.h"
#import "BaseModel.h"
#import "NSString+HXAddtions.h"
#import "AWordDefault.h"
@implementation proFile

@end
static NSString* app_key = @"123456";
static NSString* app_key_secret = @"z*~#@kR^*N";
@implementation BaseEntity
- (NSDictionary *)encodePro
{
    
    NSMutableDictionary* dic= [NSMutableDictionary dictionary];;
    
    
    [dic setObject:_callback forKey:@"callback"];
    if(_pro)
    {
        [dic setObject:_pro forKey:@"params"];
    }
    [dic setObject:@"1" forKey:@"devicecode"];
    
    NSString* uid = [AWordDefault getUid];
    if (uid) {
        [dic setObject:uid forKey:@"uid"];
    }
    [dic setObject:@"shop1" forKey:@"username"];
    NSString* token = [AWordDefault getToken];
    if (token) {
        [dic setObject:token forKey:@"token"];
    }
    NSString* shopid = [AWordDefault getShopId];
    if (shopid) {
        [dic setObject:shopid forKey:@"shopid"];
    }
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    [dic setObject:[NSString stringWithFormat:@"%f", timeStamp] forKey:@"timestamp"];
    
    [dic setObject:[self getSignWithDic:dic] forKey:@"sign"];
    
    
    DLog(@"参数是:%@",dic);
    NSString* jsonKey = [NSString jsonStringWithDictionary:(NSDictionary*)dic];
    NSData *nsdata = [jsonKey
                      dataUsingEncoding:NSUTF8StringEncoding];
    NSString *baseKey = [nsdata base64EncodedStringWithOptions:0];
    NSMutableString *key = [[NSMutableString alloc]initWithString:baseKey];
    [key stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *resultDic = @{@"key":key};
    return resultDic;
}


-(NSString*)getSignWithDic:(NSDictionary*)dic
{
    NSString* resultStr = [self getStrWithDic:dic];
    NSString* appkey = [NSString stringWithFormat:@"%@%@",app_key,app_key_secret];
    NSString* md5Appkey = [[appkey md5] substringWithRange:NSMakeRange(8, 18)];
    resultStr = [resultStr stringByAppendingString:md5Appkey];
    resultStr = [resultStr md5];
    return resultStr;
}

-(NSString*)getStrWithDic:(NSDictionary*)dic
{
    NSString* resultStr = @"";
    
    for (NSString* key in [dic allKeys]) {
        NSObject* obj = [dic objectForKey:key];
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = [self getStrWithDic:(NSDictionary*)obj];
            if ([resultStr isEqualToString:@""]) {
                resultStr = obj;
                
            }else{
                resultStr = [NSString stringWithFormat:@"%@&%@",resultStr,obj];
                
            }        }else{
            if ([resultStr isEqualToString:@""]) {
                resultStr = [NSString stringWithFormat:@"%@=%@",key,obj];
                
            }else{
                resultStr = [NSString stringWithFormat:@"%@&%@=%@",resultStr,key,obj];
                
            }
        }
        
    }
    return resultStr;
}
@end
