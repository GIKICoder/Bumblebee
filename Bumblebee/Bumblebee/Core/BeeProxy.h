//
//  BeeProxy.h
//  Bumblebee
//
//  Created by GIKI on 2017/2/25.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeeLink.h"
@class BeeKernel;
/**
 组件消息代理类
 */
@interface BeeProxy : NSObject

/**
 组件内核。
 */
@property (nonatomic, weak) BeeKernel* kernel;

/**
 加入代理队列

 @param link 组件请求link连接
 @return YES/NO
 */
- (BOOL)addOperation:(BeeLink*)link;

/**
 出代理队列

 @param tokenID 请求的唯一标示
 @return YES/NO
 */
- (BOOL)removeOperation:(NSString*)tokenID;

/*!
 @method getHeaderComLink
 @abstract 获得队列头
 @result 队列头comlink实例
 */

/**
 获取队列header

 @return 队列头BeeLink实例
 */
- (BeeLink*)getHeaderBeeLink;

/**
 开始执行

 @return YES/NO
 */
- (BOOL)start;


/**
 取消请求

 @param request beeRequest
 */
- (void)cancel:(BeeRequest*)request;

/**
 唤起执行方法

 @param request 请求
 @return 请求response
 */
- (BeeResponse*)invoke:(BeeRequest*)request;
@end
