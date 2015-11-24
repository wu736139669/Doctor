//
//  BaseWLService.h
//  WlianWorld
//
//  Created by xmfish on 15/11/13.
//  Copyright © 2015年 ash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@class BaseEntity;

@interface BaseWLService : NSObject


+ (RACSignal *)requireWithProperty:(BaseEntity *)proper;
@end
