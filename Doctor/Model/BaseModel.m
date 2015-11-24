//
//  BaseModel.m
//  WlianWorld
//
//  Created by xmfish on 15/11/16.
//  Copyright © 2015年 ash. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             //             @"errCode": @"ret",
             @"errorCode": @"errorCode",
             @"errorMessage": @"errorMessage",
             };
}

+ (NSValueTransformer *)errorCodeJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value,BOOL *success, NSError *__autoreleasing *error) {
        
        NSNumber *num = value;
        
        NSString *tempStr = [NSString stringWithFormat:@"%@", num];
        
        return tempStr;
        
    } reverseBlock:^id(id value,BOOL *success, NSError *__autoreleasing *error) {
        
        NSString *tempStr = value;
        
        NSNumber *tempNum = @(tempStr.integerValue);
        
        return tempNum;
        
    }];
}
- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error
{
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self != nil)
    {
    }
    return self;
}
@end
