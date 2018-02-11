//
//  BeeProxy.m
//  Bumblebee
//
//  Created by GIKI on 2017/2/25.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "BeeProxy.h"
#import "BeeKernel.h"
#import "BeeResponse.h"
#import "BeeRequest.h"
#import "BeeModuleConfig.h"
#import "BeeBaseEntrance.h"
@interface BeeProxy ()

@property (nonatomic, strong) NSMutableArray* linkOperation;

@property (nonatomic, strong) NSLock*         operationLock;

@property (nonatomic, assign) BOOL            bDoingRequest;

@end

@implementation BeeProxy

#pragma mark - init

- (id)init
{
    self = [super init];
    
    if (self) {
        _linkOperation = [[NSMutableArray alloc] init];
        
        _operationLock = [[NSLock alloc] init];
    }
    
    return self;
}

#pragma mark - private Method

- (BOOL)doProcessBeeLink:(BeeLink*)link
{
    if (link == nil) {
        //[self removeOperation:link.request.moduleID];
        return NO;
    }
    
    BeeModuleConfig * config = [self.kernel getModuleConfigByName:link.request.entranceName];
    
    //获得comEntity实例
    BeeBaseEntrance* entrance = (BeeBaseEntrance*)[self.kernel getBeeRequestByModuleID:config.moduleID];
    if (!entrance) {
        [self removeOperation:link.request.tokenID];
        return NO;
    }
    __weak __typeof(&*self)weakSelfObj = self;
    __weak BeeLink* weakCurLink = link;
    [entrance setCompletionBlockWithResult:^(id response){
        
        __strong BeeLink* strongLink    = weakCurLink;
        __strong __typeof(&*weakSelfObj)strongSelfObj = weakSelfObj;
        
        [strongSelfObj doProcessResponse:strongLink andResponse:response];
    }];
    //当对应的InvokeAsyn request，无法做同步多次操作，如果有多次操作，comProxy会自动执行队列中任务
    if (link.request.messageType == kBeeMoudleMessageType_InvokeAsyn) {
        if (self.bDoingRequest) {
            return NO;
        }
        self.bDoingRequest = YES;
    }
    
    if ([entrance respondsToSelector:@selector(handleEntranceRequest:andModuleID:)]) {
        [entrance performSelector:@selector(handleEntranceRequest:andModuleID:) withObject:link.request withObject:config.moduleID];
    } else {
        [self removeOperation:link.request.tokenID];
        return NO;
    }
    
    if (link.request.messageType == kBeeMoudleMessageType_OpenTarget) {
        [self removeOperation:link.request.tokenID];
    }
    
    [self handleNextDispatchLink];
    
    return YES;
}

- (void)doProcessResponse:(BeeLink*)jobLink andResponse:(id)response
{
    if (jobLink == nil) {
        return;
    }
    
    if (![[NSThread currentThread] isMainThread]) {
      
        __weak __typeof(&*self)weakSelfObj = self;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong __typeof(&*weakSelfObj)strongSelfObj = weakSelfObj;
            [jobLink setResponse:response];
            //当request结果返回时，需要从proxy中去除对应的任务
            [strongSelfObj removeOperation:[strongSelfObj getHeaderBeeLink].request.tokenID];
            self.bDoingRequest = NO;
            
            //检查是否有下一个request任务
            [self handleNextRequestLink];
        });
    } else {
        [jobLink setResponse:response];
        //当request结果返回时，需要从proxy中去除对应的任务
        [self removeOperation:jobLink.request.tokenID];
        self.bDoingRequest = NO;
        
        //检查是否有下一个request任务
        [self handleNextRequestLink];
    }
}

- (void)handleNextRequestLink
{
    BeeLink* nextLink = [self getNextRequestComLink];
    
    if (nextLink) {
        [self doProcessBeeLink:nextLink];
    }
}

- (void)handleNextDispatchLink
{
    BeeLink* nextLink = [self getNextDispatchComLink];
    
    if (nextLink) {
        [self doProcessBeeLink:nextLink];
    }
}

- (BeeLink*)getNextRequestComLink
{
    while (![_operationLock tryLock]) {
        usleep(10 * 1000);
    }
    
    BeeLink * nextComLink = nil;
    
    NSInteger i = _linkOperation.count - 1;
    for (; i >= 0; i--) {
        nextComLink = [_linkOperation objectAtIndex:i];
        
        if (nextComLink.request.messageType == kBeeMoudleMessageType_InvokeAsyn) {
            break;
        }
    }
    
    if (i < 0) {
        nextComLink = nil;
    }
    
    [_operationLock unlock];
    
    return nextComLink;
}

- (BeeLink*)getNextDispatchComLink
{
    while (![_operationLock tryLock]) {
        usleep(10 * 1000);
    }
    
    BeeLink * nextComLink = nil;
    
    NSInteger i = _linkOperation.count - 1;
    for (; i >= 0; i--) {
        nextComLink = [_linkOperation objectAtIndex:i];
        
        if (nextComLink.request.messageType == kBeeMoudleMessageType_OpenTarget) {
            break;
        }
    }
    
    if (i < 0) {
        nextComLink = nil;
    }
    
    [_operationLock unlock];
    
    return nextComLink;
}


#pragma mark - public Method

/**
 加入代理队列
 
 @param link 组件请求link连接
 @return YES/NO
 */
- (BOOL)addOperation:(BeeLink*)link
{
    if (link == nil) {
        return NO;
    }
    
    while (![_operationLock tryLock]) {
        usleep(10 * 1000);
    }
    
    [_linkOperation insertObject:link atIndex:0];
    
    [_operationLock unlock];
    
    return YES;
}

/**
 出代理队列
 
 @param tokenID 请求的唯一标示
 @return YES/NO
 */
- (BOOL)removeOperation:(NSString*)tokenID
{
    BeeLink* headerLink = [self getHeaderBeeLink];
    BeeLink* handleLink = nil;
    
    while (![_operationLock tryLock]) {
        usleep(10 * 1000);
    }
    
    if ([tokenID isEqualToString:headerLink.request.tokenID]) {
        handleLink = headerLink;
        [_linkOperation removeObject:handleLink];
    } else {
        //容错处理，如果不是头结点，那么就去队列中查找具体的任务，并且删除任务
        BeeLink* link = nil;
        
        for (BeeLink* oneLink in _linkOperation) {
            if ([tokenID isEqualToString:headerLink.request.tokenID]) {
                link = oneLink;
                break;
            }
        }
        
        handleLink = link;
        [_linkOperation removeObject:handleLink];
    }
    
    [_operationLock unlock];
    
    return YES;

}

/**
 获取队列header
 
 @return 队列头BeeLink实例
 */
- (BeeLink*)getHeaderBeeLink
{
    while (![_operationLock tryLock]) {
        usleep(10 * 1000);
    }
    BeeLink* headLink = [_linkOperation lastObject];
    
    [_operationLock unlock];
    
    return headLink;
}

/**
 开始执行
 
 @return YES/NO
 */
- (BOOL)start
{
    //获得当前任务
    BeeLink* headerLink = [self getHeaderBeeLink];
    
    if (headerLink == nil) {
        return NO;
    }
    
    return [self doProcessBeeLink:headerLink];
}


/**
 取消请求
 
 @param request beeRequest
 */
- (void)cancel:(BeeRequest*)request
{
    if (!request) {
        return;
    }
    
    BeeModuleConfig * config = [self.kernel getModuleConfigByName:request.entranceName];
    
    //获得comEntity实例
    BeeBaseEntrance* entrance = (BeeBaseEntrance*)[self.kernel getBeeRequestByModuleID:config.moduleID];
    
    if (!entrance) {
        return;
    }
    
    //启动组件entity实例cancel功能
    if ([entrance respondsToSelector:@selector(handleCancel:)]) {
        [entrance performSelector:@selector(handleCancel:)
                           withObject:request];
    }
    //去除proxy代理中，对应的任务
    [self removeOperation:request.tokenID];
    
    //检查对应proxy代理中，是否有其他任务, 如果有其他任务，马上开始下一个request任务
    [self handleNextRequestLink];

}

/**
 唤起执行方法
 
 @param request 请求
 @return 请求response
 */
- (BeeResponse*)invoke:(BeeRequest*)request
{
    if (!request) {
        return nil;
    }
    
    BeeResponse* response = nil;
    

    BeeModuleConfig * config = [self.kernel getModuleConfigByName:request.entranceName];
    
    //获得comEntity实例
    BeeBaseEntrance* entrance = (BeeBaseEntrance*)[self.kernel getBeeRequestByModuleID:config.moduleID];
    
    
    if (!entrance) {
        return nil;
    }
    
    NSMutableDictionary* newParam = [[NSMutableDictionary alloc] initWithDictionary:request.parameter];
    
    request.parameter = newParam;
    
    //proxy启动对应组件的invoke服务
    if ([entrance respondsToSelector:@selector(handleInvoke:)]) {
        response = [entrance performSelector:@selector(handleInvoke:)
                                      withObject:request];
    }
    
    return response;
}
@end
