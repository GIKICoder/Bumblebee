//
//  BeeObject.h
//  Bumblebee
//
//  Created by GIKI on 2017/2/25.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 组件基类
 管理组件对象生命周期
 */
@interface BeeObject : NSObject

@property (nonatomic, assign) NSInteger beeRetainCount;

- (void)beeRetain;

- (void)beeRelease;

- (id)notificationObject;

@end
