//
//  BeeRequest.h
//  Bumblebee
//
//  Created by GIKI on 2017/2/25.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "BeeMessage.h"


@interface BeeRequest : BeeMessage

/**
 参数列表
 */
@property (nonatomic, strong) NSDictionary  *parameter;

/**
 目标方法
 */
@property (nonatomic,   copy) NSString  *actionName;




@end
