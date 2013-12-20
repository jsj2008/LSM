//
//  LSAlipay.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-29.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSAlipay.h"

@implementation LSAlipay

@synthesize accessToken=_accessToken;

static LSAlipay* alipay=nil;

+ (LSAlipay *)currentAlipay
{
    @synchronized(self)
    {
        if (alipay==nil)
        {
            alipay=[[super allocWithZone:NULL] init];
        }
    }
    return alipay;
}
+ (id)alloc
{
    return [[self currentAlipay] retain];
}
+ (id)allocWithZone:(NSZone *)zone
{
    return [[self currentAlipay] retain];
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

@end
