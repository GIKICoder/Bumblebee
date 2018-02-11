//
//  Bumblebee.m
//  Bumblebee
//
//  Created by GIKI on 17/1/10.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "Bumblebee.h"
#import "BumblebeeManager.h"

@implementation Bumblebee

/**
 启动bumblebee平台
 
 @brief: 在app启动时调用
 */
+ (void) StartBumblebee
{
    [BumblebeeManager ShareInstance];
}


/**
 创建bumblebee平台组件入口
 
 @param entranceName 组件名称
 @return 创建结果
 */
+ (BOOL) createBumblebeeEntrance:(NSString*)entranceName
{
    return [[BumblebeeManager ShareInstance] createBumblebeeEntrance:entranceName];
}


/**
 卸载组件入口
 
 @param entranceName 组件名称
 */
+ (void) releaseBublebeeEntrance:(NSString *)entranceName
{
    [[BumblebeeManager ShareInstance] releaseBublebeeEntrance:entranceName];
}


/**
 用于目标跳转的组件api
 
 @breif: 涉及UI跳转。须在主线程调用
 
 @param paramRequest 请求参数
 @param responseBlock 响应回调
 @return 组件跳转结果
 */
+ (BOOL) openTargetWithPramas:(BeeRequest*)paramRequest resultBlock:(void(^)(BeeResponse* info))responseBlock
{
    return [[BumblebeeManager ShareInstance] openTargetWithPramas:paramRequest resultBlock:responseBlock];
}



/**
 用于跨组件获取info 同步请求
 
 @breif: 须在主线程调用
 
 @param paramRequest 调用参数
 @return 请求结果
 */
+ (BeeResponse*) invokeSynRequestWithPramas:(BeeRequest*)paramRequest
{
    return [[BumblebeeManager ShareInstance] invokeSynRequestWithPramas:paramRequest];
}


/**
 组件异步请求调用
 
 @param paramRequest 请求参数
 @param responseBlock 结果回调
 @return 是否调用成功
 */
+ (BOOL) invokeAsynRequestWithPramas:(BeeRequest*)paramRequest resultBlock:(void(^)(BeeResponse* info))responseBlock
{
    return [[BumblebeeManager ShareInstance] invokeAsynRequestWithPramas:paramRequest resultBlock:responseBlock];;
}


@end
