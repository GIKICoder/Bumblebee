//
//  BeeObject.m
//  Bumblebee
//
//  Created by GIKI on 2017/2/25.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "BeeObject.h"
#import "BeeDefine.h"

@implementation BeeObject

- (id)init
{
    self = [super init];
    
    if (self) {
        _beeRetainCount = 1;
    }
    
    return self;
}

- (void)beeRetain
{
    if (_beeRetainCount >= 0) {
        _beeRetainCount++;
    }
}

- (void)beeRelease
{
    if (_beeRetainCount > 0) {
        _beeRetainCount--;
    }
    
    if (_beeRetainCount == 0) {
        //通知释放ComEntity
        [[NSNotificationCenter defaultCenter] postNotificationName:kReleaseModuleEntranceKey object:[self notificationObject]];
    }

}


/**
 组件入口重载返回组件id

 @return 返回组件id
 */
- (id)notificationObject
{
    return @"";
}
@end
