//
//  BeeSafeDictionary.h
//  Bumblebee
//
//  Created by GIKI on 17/1/11.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeeSafeDictionary : NSObject

+ (instancetype)dictionary;

- (NSUInteger)count;

- (NSArray*)allKeys;

- (__kindof id)objectForKey:(NSString*)key;

- (void)setObject:(id)value forKey:(NSString *)key;

- (void)removeObjectForKey:(id)key;

- (void)removeAllObjects;

@end
