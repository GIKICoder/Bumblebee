//
//  BeeModuleConfig.h
//  Bumblebee
//
//  Created by GIKI on 2017/2/25.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeeDefine.h"

@interface BeeModuleConfig : NSObject

/** 组件ID*/
@property (nonatomic,   copy) NSString * moduleID;

/** 组件名称 一般为组件类名-> entranceA */
@property (nonatomic,   copy) NSString * name;

/** 组件对外名称 组件描述名-> 组件A */
@property (nonatomic,   copy) NSString * category;

/** 组件版本号*/
@property (nonatomic,   copy) NSString * version;

/** 组件描述信息*/
@property (nonatomic,   copy) NSString * descInfo;

/** 组件运行状态*/
@property (nonatomic, assign) kBeeMoudleEntranceOperation  operationState;

#pragma mark -- Method

+ (instancetype)beeModuleFormBundlePath:(NSString *)path;

- (instancetype)initWithBundlePath:(NSString *)path;
@end
