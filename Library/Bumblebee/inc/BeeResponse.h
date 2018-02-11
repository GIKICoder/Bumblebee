//
//  BeeResponse.h
//  Bumblebee
//
//  Created by GIKI on 2017/2/25.
//  Copyright © 2017年 GIKI. All rights reserved.
//


#import "BeeMessage.h"

@interface BeeResponse : BeeMessage
/*!
 @property type
 @abstract 组件响应数据类型。
 */
@property (nonatomic, assign) kBeeMoudleResponseDataType type;

/*!
 @property status
 @abstract 组件响应状态。
 */
@property (nonatomic, assign) kBeeMoudleResponseState status;

/*!
 @property entity
 @abstract 组件响应通用的数据。
 */
@property (nonatomic, strong) __kindof id responseData;

@end
