//
//  BeeKernel.h
//  Bumblebee
//
//  Created by GIKI on 17/1/10.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BeeModuleConfig,BeeObject;

@interface BeeKernel : NSObject


- (instancetype) initBeeKernelWithModulePath:(NSString *)modulePath;

#pragma mark -- Public Method

/**
 根据组件名称创建组件Entity

 @param entranceName 组件类名
 @return YES/NO
 */
- (BOOL)createModuleEntrance:(NSString*)entranceName;

/**
 根据组件名称卸载组件

 @param entranceName 组件类名
 @return YES/NO
 */
- (BOOL)releaseModuleEntrace:(NSString*)entranceName;

/**
 根据组件名字获取组件配置信息
 
 @param name 组件名称
 @return BeeModuleConfig
 */
- (BeeModuleConfig *)getModuleConfigByName:(NSString*)name;

/**
 获取组件请求实例
 
 @param moudleID 组件id
 @return 组件请求实例
 */
- (BeeObject*)getBeeRequestByModuleID:(NSString*)moudleID;

/**
 根据组件ID,判断组件是否有效

 @param entranceName 组件类名
 @return YES/NO
 */
- (BOOL)beeModuleIsEnable:(NSString*)entranceName;


@end
