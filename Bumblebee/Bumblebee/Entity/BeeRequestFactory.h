//
//  BeeRequestFactory.h
//  Bumblebee
//
//  Created by GIKI on 2017/2/25.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeeRequest.h"

@interface BeeRequestFactory : NSObject

/**
 构造消息请求request

 @param entranceName 组件名
 @return BeeRequest
 */
+ (BeeRequest*)BeeInvokeSynRequest:(NSString*)entranceName;

/**
 构造opentarget请求

 @param entranceName 组件名
 @return BeeRequest
 */
+ (BeeRequest*)BeeOpenTargetRequest:(NSString*)entranceName;

/**
 构造异步消息请求

 @param entranceName 组件名
 @return BeeRequest
 */
+ (BeeRequest*)BeeInvokeASynRequest:(NSString*)entranceName;
@end
