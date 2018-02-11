//
//  BeeModuleConfig.m
//  Bumblebee
//
//  Created by GIKI on 2017/2/25.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "BeeModuleConfig.h"

@implementation BeeModuleConfig

+ (instancetype)beeModuleFormBundlePath:(NSString *)path
{
    BeeModuleConfig * config = [[BeeModuleConfig alloc] initWithBundlePath:path];
    return config;
}

- (instancetype)initWithBundlePath:(NSString *)path
{
    if (self = [super init]) {
        [self doProcessFromConfigFile:path];
    }
    return self;
}

- (void)doProcessFromConfigFile:(NSString*)path
{
    NSString* configPath = [NSString stringWithFormat:@"%@/config.txt", path];
    if (configPath.length <= 0) return;
    
    NSData* configData = [[NSData alloc] initWithContentsOfFile:configPath];
    if (!configData) return;
    
    NSDictionary * configDict = [NSJSONSerialization JSONObjectWithData:configData options:0 error:nil];
    if (!configDict) return;
    
    if ([configDict objectForKey:@"name"]) {
        self.name = [configDict objectForKey:@"name"];
    }
    
    if ([configDict objectForKey:@"moduleID"]) {
        self.moduleID = [configDict objectForKey:@"moduleID"];
    }
    
    if ([configDict objectForKey:@"category"]) {
        self.category = [configDict objectForKey:@"category"];
    }
    
    if ([configDict objectForKey:@"version"]) {
        self.version = [configDict objectForKey:@"version"];
    }
    
    if ([configDict objectForKey:@"descInfo"]) {
        self.descInfo = [configDict objectForKey:@"descInfo"];
    }
    
    if ([configDict objectForKey:@"operationState"]) {
        self.operationState = [[configDict objectForKey:@"operationState"] integerValue];
    }

}

@end
