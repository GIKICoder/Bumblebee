//
//  BeeSystemUtil.m
//  Bumblebee
//
//  Created by GIKI on 2017/2/25.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "BeeSystemUtil.h"
#import <sys/stat.h>
#import <mach-o/dyld.h>

@implementation BeeSystemUtil


/**
 检测手机是否越狱
 越狱需要做混淆处理
 @return YES/NO
 */
+ (BOOL)checkIphoneJailbreak
{
    return ([self getiPhoneFileUnce]
            || [self getiPhoneSybUnce]
            || [self getiPHoneDlUnce]
            );

}

+ (BOOL)getiPhoneFileUnce
{
    struct stat s;
    if (!stat("/Applications/Cydia.app", &s)) {
        return YES;
    }
    else if (!stat("/Library/MobileSubstrate/MobileSubstrate.dylib", &s)) {
        return YES;
    }
    else if (!stat("/var/cache/apt", &s)) {
        return YES;
    }
    else if (!stat("/var/lib/cydia", &s)) {
        return YES;
    }
    else if (!stat("/var/log/syslog", &s)) {
        return YES;
    }
    else if (!stat("/var/tmp/cydia.log", &s)) {
        return YES;
    }
    else if (!stat("/bin/bash", &s)) {
        return YES;
    }
    else if (!stat("/bin/sh", &s)) {
        return YES;
    }
    else if (!stat("/usr/sbin/sshd", &s)) {
        return YES;
    }
    else if (!stat("/usr/libexec/ssh-keysign", &s)) {
        return YES;
    }
    else if (!stat("/etc/ssh/sshd_config", &s)) {
        return YES;
    }
    else if (!stat("/etc/apt", &s)) {
        return YES;
    }
    
    return NO;
}


+ (BOOL)getiPhoneSybUnce
{
    struct stat s;
    if (!lstat("/Applications", &s)) {
        if (s.st_mode & S_IFLNK) return YES;
    }
    else if (!lstat("/Library/Ringtones", &s)) {
        if (s.st_mode & S_IFLNK) return YES;
    }
    else if (!lstat("/Library/Wallpaper", &s)) {
        if (s.st_mode & S_IFLNK) return YES;
    }
    else if (!lstat("/usr/arm-apple-darwin9", &s)) {
        if (s.st_mode & S_IFLNK) return YES;
    }
    else if (!lstat("/usr/include", &s)) {
        if (s.st_mode & S_IFLNK) return YES;
    }
    else if (!lstat("/usr/libexec", &s)) {
        if (s.st_mode & S_IFLNK) return YES;
    }
    else if (!lstat("/usr/share", &s)) {
        if (s.st_mode & S_IFLNK) return YES;
    }
    
    return NO;
}


+ (BOOL)getiPHoneDlUnce
{
    //Get count of all currently loaded DYLD
    uint32_t count = _dyld_image_count();
    for(uint32_t i = 0; i < count; i++)
    {
        //Name of image (includes full path)
        const char *dyld = _dyld_get_image_name(i);
        if(!strstr(dyld, "MobileSubstrate")) {
            continue;
        }
        else {
            return YES;
        }
    }
    return NO;
}

@end
