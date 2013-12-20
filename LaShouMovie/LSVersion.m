//
//  LSVersion.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-8-29.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSVersion.h"

@implementation LSVersion

@synthesize version=_version;
@synthesize isForce=_isForce;
@synthesize isPrompt=_isPrompt;
@synthesize downloadURL=_downloadURL;
@synthesize message=_message;

static LSVersion* version=nil;

+(LSVersion *)currentVersion
{
    @synchronized(self)
    {
        if (version==nil)
        {
            version=[[super allocWithZone:NULL] init];
        }
    }
    return version;
}
+ (id)alloc
{
    return [[self currentVersion] retain];
}
+ (id)allocWithZone:(NSZone *)zone
{
    return [[self currentVersion] retain];
}
- (id)copyWithZone:(NSZone *)zone;
{
    return self; //确保copy对象也是唯一
}
- (id)retain
{
    return self; //确保计数唯一
}
- (NSUInteger)retainCount
{
    return NSUIntegerMax;  //这样打印出来的计数永远为-1
}
- (oneway void)release
{
    //do nothing
}
+ (void)release
{
    //do nothing
}
- (id)autorelease
{
    return self;//确保计数唯一
}

#pragma 公共方法
- (void)reset
{
    version.version=nil;
    version.isForce=NO;
    version.isPrompt=NO;
    version.downloadURL=nil;
    version.message=nil;
}

- (void)completePropertyWithDictionary:(NSDictionary*)safeDic
{
    //{
    //    isForceUpgrade = 0;
    //    isPromptUpgrade = 1;
    //    newestVersion = "1.2.3";
    //     = "https://itunes.apple.com/cn/app/id599209062?mt=8";
    //    versionDescript = "\U53d1\U73b0\U65b0\U7248\U672c\Uff0c\U9700\U8981\U5347\U7ea7\U3002\U5f71\U7247\U5f71\U9662\U6392\U671f\U63a5\U53e3\U5347\U7ea7\Uff0c\U901f\U5ea6\U63d0\U5347\Uff1b\U652f\U4ed8\U5b9d\U63a5\U53e3\U4f18\U5316\Uff0c\U652f\U4ed8\U66f4\U65b9\U4fbf\U3002";
    //}
    version.version=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"newestVersion"]];
    version.isForce=[[safeDic objectForKey:@"isForceUpgrade"] boolValue];
    version.isPrompt=[[safeDic objectForKey:@"isPromptUpgrade"] boolValue];
    version.downloadURL=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"url"]];
    version.message=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"versionDescript"]];
}

@end
