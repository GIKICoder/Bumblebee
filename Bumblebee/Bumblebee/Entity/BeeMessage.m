//
//  BeeMessage.m
//  Bumblebee
//
//  Created by GIKI on 2017/2/25.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "BeeMessage.h"

@implementation BeeMessage

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a = [date timeIntervalSince1970] * 1000;
        _tokenID = [NSString stringWithFormat:@"%f", a];
    }
    
    return self;
}

@end
