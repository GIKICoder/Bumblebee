//
//  BeeBaseEntrance.h
//  Bumblebee
//
//  Created by GIKI on 2017/2/25.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "BeeObject.h"
#import "BeeResponse.h"
#import "BeeRequest.h"

/**
 组件入口类
 @breif:所有组件入口都需要继承该类
 */
@interface BeeBaseEntrance : BeeObject

@property (nonatomic, strong) NSString* moduleID;

@property (nonatomic, weak) BeeRequest* request;

- (NSNumber*)handleEntranceRequest:(BeeRequest*)request andModuleID:(NSString*)moduleID;


/**
 设置请求处理回调
 
 @param result 请求结果block
 */
- (void)setCompletionBlockWithResult:(void (^)(id responseObject))result;


- (void)setResponse:(BeeResponse*)response;


#pragma mark -需要子类重写的函数

- (BOOL)handleRequest:(BeeRequest*)request;


- (BOOL)handleDispatch:(BeeRequest*)request;


- (BOOL)handleCancel:(BeeRequest*)request;


- (BeeResponse*)handleInvoke:(BeeRequest*)request;



@end
