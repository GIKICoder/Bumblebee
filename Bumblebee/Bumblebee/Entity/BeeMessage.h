//
//  BeeMessage.h
//  Bumblebee
//
//  Created by GIKI on 2017/2/25.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeeDefine.h"

@interface BeeMessage : NSObject

/**
  消息唯一标示。
 */
@property (nonatomic, strong) NSString* tokenID;


/**
 组件 标示ID
 */
@property (nonatomic,   copy) NSString  *moduleID;

/**
 组件入口名称
 */
@property (nonatomic,   copy) NSString  *entranceName;

/**
 消息类型
 */
@property (nonatomic,  assign) kBeeMoudleMessageType messageType;

@end
