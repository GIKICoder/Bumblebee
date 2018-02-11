//
//  BeeCommonUtil.h
//  Bumblebee
//
//  Created by GIKI on 2017/2/25.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeeCommonUtil : NSObject

/**
 创建文件目录

 @param filePath 文件路径 
        不存在就创建
 @return YES/NO
 */
+ (BOOL)creatFilePath:(NSString *)filePath;

/**
 检查文件路径是否存在

 @param filePath 文件路径
 @return 是否存在
 */
+ (BOOL)filePathIsExist:(NSString *)filePath;


@end
