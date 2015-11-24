//
//  BaseViewModel.m
//  WlianWorld
//
//  Created by xmfish on 15/11/13.
//  Copyright © 2015年 ash. All rights reserved.
//

#import "BaseViewModel.h"
#import "BaseModel.h"
@implementation BaseViewModel

+(BaseEntity*)requireWithDic:(NSDictionary *)dic withModel:(BaseModel*)model
{
    BaseEntity *pro = [[BaseEntity alloc] init];
    pro.requireType = HTTPRequestTypeWithGET;
    pro.responesOBJ = model.class;
    pro.reqURL = @"";
    pro.pro = dic;
    return pro;
}
@end
