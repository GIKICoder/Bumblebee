//
//  BeeSystemUtil.h
//  Bumblebee
//
//  Created by GIKI on 2017/2/25.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeeSystemUtil : NSObject

/**
 检测手机是否越狱
 越狱需要做混淆处理
 @return YES/NO
 */
+ (BOOL)checkIphoneJailbreak;

@end
