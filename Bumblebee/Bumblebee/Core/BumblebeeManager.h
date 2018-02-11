//
//  BumblebeeManager.h
//  Bumblebee
//
//  Created by GIKI on 17/1/10.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeeRequest.h"
#import "BeeResponse.h"

@interface BumblebeeManager : NSObject

@property (nonatomic, assign) BOOL bFirstLaunch;

+ (instancetype) ShareInstance;

/**
 创建bumblebee平台组件入口
 
 @param entranceName 组件名称
 @return 创建结果
 */
- (BOOL) createBumblebeeEntrance:(NSString*)entranceName;


/**
 卸载组件入口
 
 @param entranceName 组件名称
 */
- (BOOL) releaseBublebeeEntrance:(NSString *)entranceName;


/**
 用于目标跳转的组件api
 
 @breif: 涉及UI跳转。须在主线程调用
 
 @param paramRequest 请求参数
 @param responseResult 响应回调
 @return 组件跳转结果
 */
- (BOOL) openTargetWithPramas:(BeeRequest*)paramRequest resultBlock:(void(^)(BeeResponse* info))responseResult;



/**
 用于跨组件获取info 同步请求
 
 @breif: 须在主线程调用
 
 @param paramRequest 调用参数
 @return 请求结果
 */
- (BeeResponse *) invokeSynRequestWithPramas:(BeeRequest*)paramRequest;


/**
 组件异步请求调用
 
 @param paramRequest 请求参数
 @param responeResult 结果回调
 @return 是否调用成功
 */
- (BOOL) invokeAsynRequestWithPramas:(BeeRequest*)paramRequest resultBlock:(void(^)(BeeResponse* info))responeResult;



/*!
 @method cancelRequest
 @abstract 取消请求
 @param session 表示具体请求任务
 @result void
 */
- (BOOL)cancelRequest:(id)session;


/**
 *  组件是否可用
 *
 *  @param pluginId 组件ID
 *  @return 是否可用
 */
- (BOOL) MoudleIsEnable:(NSString*)pluginId;


/**
 *  获取组件版本
 *
 *  @param pluginID 组件id
 *
 *  @return 组件版本
 */

- (NSString*) getVersionById:(NSString*)pluginID;


/**
 *  获取当前运行组件ID
 *
 *  @return 组件ID
 */
-(NSString*) currentPluginID;



/**
 *  设置当前运行组件iD
 *
 *  @param pluginID 组件ID
 */
-(void) setCurrentPluginID:(NSString*)pluginID;
@end
