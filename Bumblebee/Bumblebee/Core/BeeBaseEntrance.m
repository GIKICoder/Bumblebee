//
//  BeeBaseEntrance.m
//  Bumblebee
//
//  Created by GIKI on 2017/2/25.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "BeeBaseEntrance.h"

@interface BeeBaseEntrance ()

@property (nonatomic,   copy) BeeCommonBlock  completionBlock;
@property (nonatomic, strong) BeeResponse* response;
@property (nonatomic, strong) BeeMessage* message;

@end

@implementation BeeBaseEntrance

- (NSNumber*)handleEntranceRequest:(BeeRequest*)request andModuleID:(NSString*)moduleID
{
    if (request == nil || moduleID.length <= 0) {
        return @(0);
    }
    
    self.moduleID = moduleID;
    self.message  = request;
    
    if (request.messageType == kBeeMoudleMessageType_InvokeSyn) {
        self.beeRetainCount++;
    } else if (request.messageType == kBeeMoudleMessageType_OpenTarget) {
        return [NSNumber numberWithBool:[self handleDispatch:request]];
    }
    
    return [NSNumber numberWithBool:[self handleRequest:request]];
}

/**
 设置请求处理回调
 
 @param result 请求结果block
 */
- (void)setCompletionBlockWithResult:(void (^)(id responseObject))result
{
    
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-retain-cycles"
    #pragma clang diagnostic ignored "-Wgnu"
    __weak __typeof(&*self) weakSelfObj = self;
    
    self.completionBlock = ^{
        
        __strong __typeof(&*weakSelfObj)strongSelfObj = weakSelfObj;
        if (result) {
            __weak __typeof(&*strongSelfObj) weakObj = strongSelfObj;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong __typeof(&*weakObj) strongObj = weakObj;
                result(strongObj.response);
                strongObj.completionBlock  = nil;
            });
        }
    };
    #pragma clang diagnostic pop
    
}


- (void)setResponse:(BeeResponse*)response;
{

    if (response != self.response) {
        _response         = response;
        _response.tokenID = self.message.tokenID;
        _response.entranceName= self.message.entranceName;
        _response.moduleID = self.message.moduleID;
        _response.messageType  = self.message.messageType;
        
        if (self.completionBlock) {
            self.completionBlock();
            self.completionBlock = nil;
            self.beeRetainCount--;
        }
    }
    
}


#pragma mark -需要子类重写的函数

- (BOOL)handleRequest:(BeeRequest*)request
{
    self.request = request;
    
    if(request.actionName)
    {
        NSString* targetName =request.actionName;
        if (targetName) {
            return  [self callSelInImplement:targetName];
        }
        else {
            return NO;
        }
        
    }
    
    return NO;
}


- (BOOL)handleDispatch:(BeeRequest*)request
{
    self.request = request;
    
    if(request.actionName)
    {
        NSString* targetName =request.actionName;
        if (targetName) {
            return  [self callSelInImplement:targetName];
        }
        else {
            return NO;
        }
        
    }
    
    return NO;

}


- (BOOL)handleCancel:(BeeRequest*)request
{
    return NO;
}


- (BeeResponse*)handleInvoke:(BeeRequest*)request
{
    if (request.messageType != kBeeMoudleMessageType_InvokeSyn) {
        return nil;
    }
    
    self.request = request;
    
    if(request.parameter)
    {
        NSString* targetName =request.actionName;
        
        if (targetName) {
            
            //目前只是支持返回userdata的数据结果
            BeeResponse *result = [self getResponseSelInImplement:targetName];
            
            //            ComResponse *response = [[ComResponse alloc] init];
            //
            //            if (result == nil) {
            //                response.status = COM_RESPONSE_STATUS_FAIL;
            //            }
            //            else {
            //                response.status = COM_RESPONSE_STATUS_OK;
            //            }
            //
            //            if ([result isKindOfClass:[NSData class]]) {
            //                response.type = COM_RESPONSE_TYPE_BUFFER;
            //            }
            //
            //            response.type = COM_RESPONSE_TYPE_DATA;
            //            response.responseData = result;
            
            return result;
        }
        else
        {
            return nil;
        }
    }

    return nil;
}

#pragma mark - 重载父类方法

- (id)notificationObject
{
    return (id)(self.moduleID.length > 0 ? self.moduleID : @"");
}

#pragma mark - Private Method

-(BOOL)callSelInImplement:(NSString*)selector
{
    SEL func =   NSSelectorFromString(selector);
    
    
    if ([self respondsToSelector:func]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:func];
#pragma clang diagnostic pop
        return YES;
    }
    
    return NO;
    
}

-(BeeResponse *)getResponseSelInImplement:(NSString*)selector
{
    SEL func =   NSSelectorFromString(selector);
    id returnData = nil;
    
    if ([self respondsToSelector:func]) {
        //不能使用perform selector in arc with return value
        NSMethodSignature *signature = [self methodSignatureForSelector:func];
        if (signature) {
            const char *retType = [signature methodReturnType];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            if(0 == strcmp(retType, @encode(id))){
                returnData = [self performSelector:func];
            }else{
                [self performSelector:func];
            }
#pragma clang diagnostic pop
            
            //            if (0 == strcmp(retType, "v")) {
            //                //void
            //                objc_msgSend(self, func);
            //            }else if (0 == strcmp(retType, @encode(id))){
            //                //return object
            //                returnDic = objc_msgSend(self, func);
            //            }else{
            //                //返回简单变量
            //                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            //                invocation.target = self;
            //                invocation.selector = func;
            //                [invocation invoke];
            //            }
            
        }
        
        if ([returnData isKindOfClass:[BeeResponse class]]) {
            return returnData;
        }
        return nil;
    }
    
    return nil;
    
}


@end
