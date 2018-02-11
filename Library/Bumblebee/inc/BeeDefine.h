//
//  BeeDefine.h
//  Bumblebee
//
//  Created by GIKI on 17/1/10.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#ifndef BeeDefine_h
#define BeeDefine_h

typedef void (^BeeCommonBlock)(void);
/**
 卸载组件入口通知
 */
#define kReleaseModuleEntranceKey @"kRealseModuleEntranceKey"

/**
 组件平台kernel 状态

 - kBeeMoudleEntranceState_IdleMode:                组件平台空闲
 - kBeeMoudleEntranceState_InstallFromResource:     从本地资源中安装组件
 - kBeeMoudleEntranceState_ResetFromResource:       从本地资源中重置组件
 - kBeeMoudleEntranceState_InstallFromDownload:     从下载文件里安装组件
 - kBeeMoudleEntranceState_DownloadMoudle:          下载组件
 - kBeeMoudleEntranceState_Background:              程序进入后台
 - kBeeMoudleEntranceState_Exception:               程序异常中断
 - kBeeMoudleEntranceState_UpdateCloudControl:      更新云控。获取云控信息
 - kBeeMoudleEntranceState_InstallComplete:         安装完成
 */
typedef NS_ENUM(NSUInteger, kBeeMoudleEntranceState) {
    kBeeMoudleEntranceState_IdleMode,
    kBeeMoudleEntranceState_InstallFromResource,
    kBeeMoudleEntranceState_ResetFromResource,
    kBeeMoudleEntranceState_InstallFromDownload,
    kBeeMoudleEntranceState_DownloadMoudle,
    kBeeMoudleEntranceState_Background,
    kBeeMoudleEntranceState_Exception,
    kBeeMoudleEntranceState_UpdateCloudControl,
    kBeeMoudleEntranceState_InstallComplete,
};

/**
 组件运行状态

 - kBeeMoudleEntranceOperation_Exception:   状态异常
 - kBeeMoudleEntranceOperation_Installed:   已经安装
 - kBeeMoudleEntranceOperation_Launch:      已经启动
 - kBeeMoudleEntranceOperation_Run:         正在运行
 - kBeeMoudleEntranceOperation_Stop:        已经停止
 - kBeeMoudleEntranceOperation_UNInstall:   已经卸载
 - kBeeMoudleEntranceOperation_Inprogress:  正在安装
 */
typedef NS_ENUM(NSUInteger, kBeeMoudleEntranceOperation) {
    kBeeMoudleEntranceOperation_Exception,
    kBeeMoudleEntranceOperation_Installed,
    kBeeMoudleEntranceOperation_Launch,
    kBeeMoudleEntranceOperation_Run,
    kBeeMoudleEntranceOperation_Stop,
    kBeeMoudleEntranceOperation_UNInstall,
    kBeeMoudleEntranceOperation_Inprogress,
};


/**
 组件消息类型

 - kBeeMoudleMessageType_OpenTarget:    打开目标对象，用于UI跳转 【main】
 - kBeeMoudleMessageType_InvokeSyn:     同步获取信息 【main】
 - kBeeMoudleMessageType_InvokeAsyn:    异步获取信息 
 */
typedef NS_ENUM(NSUInteger, kBeeMoudleMessageType) {
    kBeeMoudleMessageType_Invalid = 0, //无效
    kBeeMoudleMessageType_OpenTarget,
    kBeeMoudleMessageType_InvokeSyn,
    kBeeMoudleMessageType_InvokeAsyn,
    
};


/**
 组件响应数据类型

 - kBeeMoudleResponseType_Invaild:  组件响应数据异常
 - kBeeMoudleResponseType_Entity:   组件响应数据为实体类
 - kBeeMoudleResponseType_Json:     组件响应数据为JSON
 - kBeeMoudleResponseType_Buffer:   组件响应数据为二进制流
 - kBeeMoudleResponseType_Data:     组件响应数据为具体数据
 */
typedef NS_ENUM(NSUInteger, kBeeMoudleResponseDataType) {
    kBeeMoudleResponseType_Invaild = 0, //无效
    kBeeMoudleResponseType_Entity,
    kBeeMoudleResponseType_Json,
    kBeeMoudleResponseType_Buffer,
    kBeeMoudleResponseType_Data,
    
};

/**
 组件平台响应状态

 - kBeeMoudleResponseState_Invaild: 组件响应异常
 - kBeeMoudleResponseState_Success: 组件响应成功
 - kBeeMoudleResponseState_Failure: 组件响应失败
 - kBeeMoudleResponseState_TimeOut: 组件响应超时
 */
typedef NS_ENUM(NSUInteger, kBeeMoudleResponseState) {
    kBeeMoudleResponseState_Invaild = 0, //无效
    kBeeMoudleResponseState_Success,
    kBeeMoudleResponseState_Failure,
    kBeeMoudleResponseState_TimeOut,
    
};

#endif /* BeeDefine_h */
