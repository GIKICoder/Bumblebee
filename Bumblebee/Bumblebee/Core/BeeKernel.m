//
//  BeeKernel.m
//  Bumblebee
//
//  Created by GIKI on 17/1/10.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "BeeKernel.h"
#import "BeeDefine.h"
#import "BeeSafeDictionary.h"
#import "BeeSafeArray.h"
#import "BeeModuleConfig.h"
#import "BeeObject.h"

@interface BeeKernel ()

/** 组件配置文件路径*/
@property (nonatomic, strong, readonly) NSString * modulePath;
/** 网络组件下载路径*/
@property (nonatomic, strong, readonly) NSString * netModulePath;
/** 组件资源路径*/
@property (nonatomic, strong, readonly) NSString * moduleResourcePath;
/** 组件配置对象列表*/
@property (nonatomic, strong) BeeSafeArray * moduleConfigArray;
/** 组件entity 字典*/
@property (nonatomic, strong) BeeSafeDictionary * moduleEntityTable;
/** 
 用户组件注册表，表示是各个组件在工程中com_register_table.plist中注册的组件id
 优化内存，在安装完组件后，务必清除其内存
 */
@property (nonatomic, strong) NSMutableDictionary  *moduleRegistryTable;
/** 组件入口状态标示*/
@property (nonatomic, assign) kBeeMoudleEntranceState  moudleEntranceState;

@end

@implementation BeeKernel

#pragma mark -- init

- (instancetype) initBeeKernelWithModulePath:(NSString *)modulePath
{
    NSAssert(modulePath, @"modulePath can not be nil");
    
    if (self = [super init]) {
        [self InitializeConifgs:modulePath];
    }
    return self;
}

- (void)dealloc
{
    @try {
        NSNotificationCenter* notifyCenter = [NSNotificationCenter defaultCenter];
        [notifyCenter removeObserver:self
                                name:kReleaseModuleEntranceKey
                              object:nil];
    }
    @catch (NSException *exception) {
    }
    @finally {
    }

}

#pragma mark - private Method

- (void) InitializeConifgs:(NSString*)modulePath
{
    [self InitializeObserver];
    [self InitializeModuleConfig:modulePath];
}


- (void) InitializeObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(releaseModuleEntrance:) name:kReleaseModuleEntranceKey object:nil];
}

- (void) InitializeModuleConfig:(NSString*)modulePath
{
    _moduleResourcePath = [NSString stringWithFormat:@"%@/plugin",[[NSBundle mainBundle] bundlePath]];
     _modulePath = [NSString stringWithFormat:@"%@/com_register_table.plist",_moduleResourcePath];
    
    self.moduleEntityTable = [BeeSafeDictionary dictionary];
    
    self.moduleConfigArray = [BeeSafeArray array];
    
    self.moduleRegistryTable = [[NSMutableDictionary alloc] initWithContentsOfFile:_modulePath];
 
    self.moudleEntranceState = kBeeMoudleEntranceState_InstallFromResource;
}

#pragma mark -- private Method

- (void) releaseModuleEntrance:(NSNotification*)notify
{
    id obj = [notify object];
    
    if ([obj isKindOfClass:[NSString class]]) {
        NSString* moduleID = (NSString*)obj;
        
        if (moduleID.length <= 0) {
            NSLog(@"生命周期发生错误");
        } else {
            [self.moduleEntityTable removeObjectForKey:moduleID];
        }
    }

}

- (void)setMoudleEntranceState:(kBeeMoudleEntranceState)moudleEntranceState
{
    BOOL haveOp = NO;
    switch (moudleEntranceState) {
        case kBeeMoudleEntranceState_InstallFromResource:
            if (_moudleEntranceState == kBeeMoudleEntranceState_IdleMode) {
                [self loadModuleEntityTable];
                haveOp = YES;
            }
            break;
        case kBeeMoudleEntranceState_InstallComplete:
        {
           // __weak typeof(self) weakself = self;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                //save RegisterConfigs
            });
    
            haveOp = YES;
        }
            break;
            
        default:
            break;
    }
    
}

/**
 加载组件
 */
- (void)loadModuleEntityTable
{
    [self installAllModuleConfig];
}

/**
 重资源中安装全部组件信息
 */
- (void)installAllModuleConfig
{
    NSMutableArray *moduleBundles = [NSMutableArray array];
    
    //从组件的注册配置信息列表中找到组件对应的bundle
    NSArray *allKeys = [self.moduleRegistryTable allKeys];
    for (NSString *bundleKey in allKeys) {
         NSString* fullPath = [self.moduleResourcePath stringByAppendingFormat:@"/%@.bundle", bundleKey];
        [moduleBundles addObject:fullPath];
    }
    
    __weak typeof(self) weakSelf = self;
    
    [self installModulesFormBundles:moduleBundles installComplete:^{
        weakSelf.moudleEntranceState = kBeeMoudleEntranceState_InstallComplete;
        weakSelf.moduleRegistryTable = nil;
    }];
}

/**
 安装组件

 @param bundles 本地组件bundle
 @param complete 安装完成回调
 */
- (void)installModulesFormBundles:(NSArray*)bundles installComplete:(void(^)(void))complete
{
    __block void(^completeBlock)(void) = complete;
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
       
        for (NSString * bundlePath  in bundles) {
            
            if (bundlePath.length <= 0) return;
            
            BeeModuleConfig *moduleConfig = [BeeModuleConfig beeModuleFormBundlePath:bundlePath];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:moduleConfig.category object:@(YES)];
                [weakSelf.moduleConfigArray addObject:moduleConfig];
            });

        }
        
        if (completeBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completeBlock();
                completeBlock = nil;
            });
        }
    });
}

#pragma mark -- Public Method

/**
 根据组件名称创建组件Entity
 
 @param entranceName 组件类名
 @return YES/NO
 */
- (BOOL)createModuleEntrance:(NSString*)entranceName
{
    if (entranceName.length <= 0) {
        return NO;
    }
    
    //获取注册的组件配置
    BeeModuleConfig *config = [self getModuleConfigByName:entranceName];
    if (!config) {
        NSLog(@"Warning: %@组件没有注册成功", config.category);
        return NO;
    }
    if (!config.moduleID) {
        NSLog(@"Warning: %@组件ID为空，请检查组件配置信息", config.category);
        return NO;
    }
    BeeObject * moduleEntity = [self.moduleEntityTable objectForKey:config.moduleID];
    if (!moduleEntity) {
        
        Class entranceClass = NSClassFromString(config.name);
        id entrance = [[entranceClass alloc] init];
        if (![entrance isKindOfClass:[BeeObject class]]) {
            NSLog(@"Warning: %@组件必须为BeeObject的子类，请检查组件配置信息", config.category);
            return NO;
        }
        
        [self.moduleEntityTable setObject:entrance forKey:config.moduleID];
        
    } else {
        [moduleEntity beeRetain]; //引用计数+1
    }

    return YES;
}

/**
 根据组件名称卸载组件
 
 @param entranceName 组件类名
 @return YES/NO
 */
- (BOOL)releaseModuleEntrace:(NSString*)entranceName
{
    if (entranceName.length <= 0) {
        return NO;
    }
    
    BeeModuleConfig *config = [self getModuleConfigByName:entranceName];
    if (!config || !config.moduleID) {
        NSLog(@"Warning: %@组件没有注册成功", config.category);
        return NO;
    }
    
    BeeObject *entity = [self.moduleEntityTable objectForKey:config.moduleID];
    if (entity) {
        [entity beeRelease];//引用计数-1
    }
    
    return YES;
}


/**
 根据组件名字获取组件配置信息
 
 @param name 组件名称
 @return BeeModuleConfig
 */
- (BeeModuleConfig *)getModuleConfigByName:(NSString*)name
{
    __block NSString* blockName = name;
    __block BeeModuleConfig * config =nil;
    [self.moduleConfigArray iterateWitHandler:^BOOL(BeeModuleConfig* element) {
        if ([element.name isEqualToString:blockName]) {
            config = element;
            return NO;
        }
        return NO;
    }];
    return config;
}

/**
 获取组件请求实例

 @param moudleID 组件id
 @return 组件请求实例
 */
- (BeeObject*)getBeeRequestByModuleID:(NSString*)moudleID
{
    if (!moudleID) {
        return nil;
    }
    return [self.moduleEntityTable objectForKey:moudleID];
}

/**
 根据组件ID,判断组件是否有效
 
 @param entranceName 组件ID
 @return YES/NO
 */
- (BOOL)beeModuleIsEnable:(NSString*)entranceName
{
    BeeModuleConfig *config = [self getModuleConfigByName:entranceName];
    if (config) {
        return YES;
    }
    return NO;
}


@end
