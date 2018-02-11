//
//  BumblebeeManager.m
//  Bumblebee
//
//  Created by GIKI on 17/1/10.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "BumblebeeManager.h"
#import "BeeSafeDictionary.h"
#import "BeeKernel.h"
#import "BeeProxy.h"
#import "BeeModuleConfig.h"

@interface BumblebeeManager()

@property (nonatomic, strong) BeeSafeDictionary  *proxyTable;
@property (nonatomic, strong) BeeKernel  *kernel;
@property (copy) NSString  *pluginID;

@end

@implementation BumblebeeManager

+ (instancetype) ShareInstance
{
    static BumblebeeManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[BumblebeeManager alloc] init];
    });
    return manager;
}

- (instancetype) init
{
    if (self = [super init]) {
        [self initConfigs];
    }
    return self;
}

- (id) copyWithZone:(NSZone *)zone {
    return self;
}

#if (!__has_feature(objc_arc)) //MRC下singleton

- (id) retain {
    return self;
}

- (unsigned) retainCount {
    return UINT_MAX;  //denotes an object that cannot be released
}

- (oneway void) release {
    //do nothing
}

- (id) autorelease {
    return self;
}
#endif

#pragma mark - private Method

/**
 组件平台配置信息初始化
 */
- (void) initConfigs
{
    self.proxyTable = [BeeSafeDictionary dictionary];
    self.kernel = [[BeeKernel alloc] initBeeKernelWithModulePath:@"123"];
}


/**
 组件间消息调用Method

 @param request 请求参数
 @param responBlock 请求回调
 @return 是否调用成功
 */
- (BOOL)doProcessRequestMethodParam:(BeeRequest*)request respone:(void(^)(BeeResponse*))responBlock
{
    if (!request || !request.entranceName) {
        return NO;
    }
    
    NSString *moduleID = [self.kernel getModuleConfigByName:request.entranceName].moduleID;
    request.moduleID = moduleID;
    
    BeeProxy * proxy = [self.proxyTable objectForKey:moduleID];
    if (!proxy) {
    //查看对应组件的代理是否存在在proxyTalbe中，如果没有要创建一个新的代理，并且
    //加入到proxyTable
        proxy = [[BeeProxy alloc] init];
        proxy.kernel = self.kernel;
        [self.proxyTable setObject:proxy forKey:moduleID];
    }
    
    //ComLink表示每个代理的任务
    BeeLink* newLink    = [[BeeLink alloc] initWithRequest:request];
    [newLink setCompletionBlockWithResult:responBlock];
    
    //获得目标组件的代理
    BeeProxy* destProxy = [self.proxyTable objectForKey:moduleID];
    
    if (destProxy) {
   
        [destProxy addOperation:newLink];
        //开始代理中的当前任务
        [destProxy start];
        return YES;
    }
    
    return NO;
}


- (BeeResponse*)doProcessInvokeSyn:(BeeRequest*)request
{
    if (!request || request.entranceName.length <= 0) {
        return nil;
    }
    
    if (self.proxyTable == nil) {
        self.proxyTable = [[BeeSafeDictionary alloc] init];
    }
    
    NSString * moduleID = [self.kernel getModuleConfigByName:request.entranceName].moduleID;
    
    BeeProxy* newProxy = nil;
    if ([self.proxyTable objectForKey:moduleID] == nil) {
        
        newProxy = [[BeeProxy alloc] init];
        newProxy.kernel = self.kernel;
        [self.proxyTable setObject:newProxy forKey:moduleID];
    }
    
    //获得目标代理
    BeeProxy* destProxy = [_proxyTable objectForKey:moduleID];
    
    //启动代理的invoke任务
    return [destProxy invoke:request];
}


#pragma mark -- public Method

/**
 创建bumblebee平台组件入口
 
 @param entranceName 组件名称
 @return 创建结果
 */
- (BOOL) createBumblebeeEntrance:(NSString*)entranceName
{
    return [self.kernel createModuleEntrance:entranceName];
}


/**
 卸载组件入口
 
 @param entranceName 组件名称
 */
- (BOOL) releaseBublebeeEntrance:(NSString *)entranceName
{
    return [self.kernel releaseModuleEntrace:entranceName];
}


/**
 用于目标跳转的组件api
 
 @breif: 涉及UI跳转。须在主线程调用
 
 @param paramRequest 请求参数
 @param responseResult 响应回调
 @return 组件跳转结果
 */
- (BOOL) openTargetWithPramas:(BeeRequest*)paramRequest resultBlock:(void(^)(BeeResponse* info))responseResult
{
    if (paramRequest == nil || paramRequest.messageType == kBeeMoudleMessageType_Invalid || paramRequest.actionName == nil ) {
        return NO;
    }
    
    if (paramRequest.messageType != kBeeMoudleMessageType_OpenTarget) {
        return NO;
    }
    
    if (![[NSThread currentThread] isMainThread]) {
        return NO;
    }

    return [self doProcessRequestMethodParam:paramRequest respone:responseResult];
}



/**
 用于跨组件获取info 同步请求
 
 @breif: 须在主线程调用
 
 @param paramRequest 调用参数
 @return 请求结果
 */
- (BeeResponse *) invokeSynRequestWithPramas:(BeeRequest*)paramRequest
{
    if (paramRequest.messageType != kBeeMoudleMessageType_InvokeSyn) {
        return nil;
    }
    
    if (![[NSThread currentThread] isMainThread]) {
        return nil;
    }

    //获得组件平台信息
    //     NSString* invokeTaget = request.actionName;
    //    //NSString* invokeTaget = [request.parameter objectForKey:@"target"];
    //
    //    if ([[invokeTaget lowercaseString] isEqualToString:@"comcore"]) {
    //
    //        return [self getComInfoByRequest:request];
    //    }
    
    return [self doProcessInvokeSyn:paramRequest];

}

/**
 组件异步请求调用
 
 @param paramRequest 请求参数
 @param responeResult 结果回调
 @return 是否调用成功
 */
- (BOOL) invokeAsynRequestWithPramas:(BeeRequest*)paramRequest resultBlock:(void(^)(BeeResponse* info))responeResult
{
    if (paramRequest == nil || responeResult == nil
        || paramRequest.tokenID == nil) {
        return NO;
    }
    
    if (paramRequest.messageType != kBeeMoudleMessageType_InvokeAsyn) {
        return NO;
    }
    
    
    [self doProcessRequestMethodParam:paramRequest respone:responeResult];
    
    return YES;

}

/*!
 @method cancelRequest
 @abstract 取消请求
 @param session 表示具体请求任务
 @result void
 */
- (BOOL)cancelRequest:(id)session
{
    return YES;
}

/**
 *  组件是否可用
 *
 *  @param pluginId 组件ID
 *  @return 是否可用
 */
- (BOOL) MoudleIsEnable:(NSString*)pluginId
{
    return YES;
}

/**
 *  获取组件版本
 *
 *  @param pluginID 组件id
 *
 *  @return 组件版本
 */

- (NSString*) getVersionById:(NSString*)pluginID
{
    return @"";
}

/**
 *  获取当前运行组件ID
 *
 *  @return 组件ID
 */
-(NSString*) currentPluginID
{
    return @"";
}

/**
 *  设置当前运行组件iD
 *
 *  @param pluginID 组件ID
 */
-(void) setCurrentPluginID:(NSString*)pluginID
{
}

@end
