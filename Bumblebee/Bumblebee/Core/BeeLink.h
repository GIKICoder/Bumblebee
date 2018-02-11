//
//  BeeLink.h
//  Bumblebee
//
//  Created by GIKI on 2017/2/25.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BeeResponse,BeeRequest;

@interface BeeLink : NSObject

/**
 组件请求参数。
 */
@property (nonatomic, strong) BeeRequest* request;

/**
 组件响应参数。
 */
@property (nonatomic, strong) BeeResponse* response;

/**
 初始化组件链接类

 @param request 请求request
 @return 组件链接实例
 */
- (instancetype)initWithRequest:(BeeRequest*)request;

/**
 取消组件请求

 @return 取消的组件请求
 */
- (BeeRequest*)cancelReuqest;

/**
 加入请求完成block

 @param result 组件请求响应回调
 */
- (void)setCompletionBlockWithResult:(void (^)(id responseObject))result;


@end
