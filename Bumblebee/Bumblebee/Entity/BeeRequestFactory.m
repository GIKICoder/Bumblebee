//
//  BeeRequestFactory.m
//  Bumblebee
//
//  Created by GIKI on 2017/2/25.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "BeeRequestFactory.h"

@implementation BeeRequestFactory

/**
 构造消息请求request
 
 @param entranceName 组件名
 @return BeeRequest
 */
+ (BeeRequest*)BeeInvokeSynRequest:(NSString*)entranceName
{
    return [BeeRequestFactory initializeBeeRequest:entranceName andMessageType:kBeeMoudleMessageType_InvokeSyn];
}

/**
 构造opentarget请求
 
 @param entranceName 组件名
 @return BeeRequest
 */
+ (BeeRequest*)BeeOpenTargetRequest:(NSString*)entranceName
{
    return [BeeRequestFactory initializeBeeRequest:entranceName andMessageType:kBeeMoudleMessageType_OpenTarget];
}

/**
 构造异步消息请求
 
 @param entranceName 组件名
 @return BeeRequest
 */
+ (BeeRequest*)BeeInvokeASynRequest:(NSString*)entranceName
{
    return [BeeRequestFactory initializeBeeRequest:entranceName andMessageType:kBeeMoudleMessageType_InvokeAsyn];
}

#pragma mark - private Method

+ (BeeRequest*)initializeBeeRequest:(NSString*)entranceName andMessageType:(kBeeMoudleMessageType)messageType
{
    if (!entranceName || entranceName.length <= 0) {
        return nil;
    }
    BeeRequest * request = [[BeeRequest alloc] init];
    request.messageType = messageType;
    request.entranceName = entranceName;
    return request;
    
}
@end
