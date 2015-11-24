//
//  BaseModel.h
//  WlianWorld
//
//  Created by xmfish on 15/11/16.
//  Copyright © 2015年 ash. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : MTLModel<MTLJSONSerializing>

@property (nonatomic,strong)NSString* title;
@property (nonatomic,readonly)NSString* errorCode;
@property (nonatomic,readonly)NSString* errorMessage;

@end
