//
//  BeeLink.m
//  Bumblebee
//
//  Created by GIKI on 2017/2/25.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "BeeLink.h"
#import "BeeDefine.h"

@interface BeeLink ()

@property (nonatomic,   copy) BeeCommonBlock  completeBlock;

@end

@implementation BeeLink

/**
 初始化组件链接类
 
 @param request 请求request
 @return 组件链接实例
 */
- (instancetype)initWithRequest:(BeeRequest*)request
{
    self = [super init];
    
    if (self) {
        self.request = request;
    }
    
    return self;
}

-(void)dealloc
{
    self.completeBlock = nil;
}

/**
 取消组件请求
 
 @return 取消的组件请求
 */
- (BeeRequest*)cancelReuqest
{
    self.completeBlock = nil;
    return self.request;
}

/**
 加入请求完成block
 
 @param result 组件请求响应回调
 */
- (void)setCompletionBlockWithResult:(void (^)(id responseObject))result
{
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
#pragma clang diagnostic ignored "-Wgnu"
    
    if (result == nil) {
        return;
    }
    __typeof(&*self)weakSelf = self;
    
    self.completeBlock = ^{
        if (weakSelf.response) {
            if (result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    result(weakSelf.response);
                });
            }
        }
    };
#pragma clang diagnostic pop
}

- (void)setResponse:(BeeResponse *)response
{
    if (response != _response) {
        _response = response;
        
        if (self.completeBlock) {
            self.completeBlock();
            
            self.completeBlock = nil;
        }
    }
}


@end
