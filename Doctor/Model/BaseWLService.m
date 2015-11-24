//
//  BaseWLService.m
//  WlianWorld
//
//  Created by xmfish on 15/11/13.
//  Copyright © 2015年 ash. All rights reserved.
//

#import "BaseWLService.h"

#import "BaseEntity.h"

#import "MTLJSONAdapter.h"
#import "NSData+Godzippa.h"

#import "EGOCache.h"
#import "BaseAPIClient.h"

@implementation BaseWLService

+ (void)saveCacheWithAPIKey:(NSString *)apiKey property:(BaseEntity *)proper data:(id)tweet{
    if (proper.isCache) {
        SEL selector = NSSelectorFromString(@"errCode");
        IMP imp = [tweet methodForSelector:selector];
        NSString* (*func)(id, SEL) = (void *)imp;
        NSString *tmpErrCode = func(tweet, selector);
        DLog(@"%@", tmpErrCode);
        
        if (([tmpErrCode isKindOfClass:[NSString class]] && [tmpErrCode isEqualToString:@"0"] ) || ([tmpErrCode isKindOfClass:[NSNumber class]] && [tmpErrCode integerValue]==0)) {
            [[EGOCache globalCache] setObject:tweet forKey:apiKey];
            
        }
    }
}
+ (void)responseFromCacheWithAPIKey:(NSString *)apiKey property:(BaseEntity *)proper completionBlock:(id)subscriber{
    if (proper.isCache && [[EGOCache globalCache] hasCacheForKey:apiKey]) {
        [subscriber sendNext:[[EGOCache globalCache] objectForKey:apiKey]];
        [subscriber sendCompleted];
    }
}

+(RACSignal*)requireWithProperty:(BaseEntity *)proper
{
    
//    if (proper.requireType == HTTPRequestTypeWithGET) {
//        return [self requireWithGetWithProperty:proper];
//    }
//    return nil;
    return [self requireWithGetWithProperty:proper];
}
+(RACSignal*)requireWithGetWithProperty:(BaseEntity*)proper
{
    NSString *apiKey = proper.cacheKey;
    if (proper.pro && proper.pro[@"page"])
    {
        apiKey = [apiKey stringByAppendingFormat:@"%@",proper.pro[@"page"]];
    }

    

    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[BaseAPIClient sharedClient] GET:[proper reqURL]
                               parameters: [proper encodePro]
                                  success:^(AFHTTPRequestOperation * __unused task, id json) {
                                      DLog(@"%@", json);
                                      
                                      if(json)
                                      {
                                          NSError *error = nil;
                                          id tweet = [MTLJSONAdapter modelOfClass:[proper.responesOBJ class] fromJSONDictionary:json error:&error];
                                          
                                          
                                          [subscriber sendNext:tweet];
                                          [subscriber sendCompleted];
                                          
                                        [self saveCacheWithAPIKey:apiKey property:proper data:tweet];
                                          
                                      }
                                      else
                                      {
                                          [subscriber sendNext:nil];
                                          [subscriber sendCompleted];
                                      }
                                  }
                                  failure:^(AFHTTPRequestOperation *__unused task, NSError *error) {
                                      DLog(@"%@", error.description);
                                      
                                      [subscriber sendError:error];
                                      
                                      [self responseFromCacheWithAPIKey:apiKey property:proper completionBlock:subscriber];
                                  }];
        
        return [RACDisposable disposableWithBlock:^{
        }];
        
    }] replayLazily];
    

}
@end
