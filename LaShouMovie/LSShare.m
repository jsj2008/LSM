//
//  LSShare.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-21.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSShare.h"

@implementation LSShare

+ (BOOL)sinaWBShareAuthStatus
{
    if([LSSave obtainForKey:LSSinaWBAccessToken]!=nil)
    {
        if([LSSave obtainForKey:LSSinaWBExpireTime]!=nil)
        {
            NSString* expireTime=[LSSave obtainForKey:LSSinaWBExpireTime];
            if([[NSDate dateWithTimeIntervalSince1970:[expireTime doubleValue]] timeIntervalSinceNow] > 0)
            {
                if([LSSave obtainForKey:LSSinaWBUID]!=nil)
                {
                    if([LSSave obtainForKey:LSSinaWBUserName]!=nil)
                    {
                        return YES;
                    }
                    else
                    {
                        [self logoutSinaWB];
                    }
                }
                else
                {
                    [self logoutSinaWB];
                }
            }
            else
            {
                [self logoutSinaWB];
            }
        }
        else
        {
            [self logoutSinaWB];
        }
    }
    else
    {
        [self logoutSinaWB];
    }
    return NO;
}

+ (BOOL)qqWBShareAuthStatus
{
    if([LSSave obtainForKey:LSQQWBAccessToken]!=nil)
    {
        if([LSSave obtainForKey:LSQQWBExpireTime]!=nil)
        {
            NSString* expireTime=[LSSave obtainForKey:LSQQWBExpireTime];
            if([[NSDate dateWithTimeIntervalSince1970:[expireTime doubleValue]] timeIntervalSinceNow] > 0)
            {
                if([LSSave obtainForKey:LSQQWBUID]!=nil)
                {
                    if([LSSave obtainForKey:LSQQWBUserName]!=nil)
                    {
                        return YES;
                    }
                    else
                    {
                        [self logoutQQWB];
                    }
                }
                else
                {
                    [self logoutQQWB];
                }
            }
            else
            {
                [self logoutQQWB];
            }
        }
        else
        {
            [self logoutQQWB];
        }
    }
    else
    {
        [self logoutQQWB];
    }
    return NO;
}

+ (void)logoutSinaWB
{
    [LSSave saveObject:nil forKey:LSSinaWBAccessToken];
    [LSSave saveObject:nil forKey:LSSinaWBExpireTime];
    [LSSave saveObject:nil forKey:LSSinaWBUID];
    [LSSave saveObject:nil forKey:LSSinaWBUserName];
}
+ (void)logoutQQWB
{
    [LSSave saveObject:nil forKey:LSQQWBAccessToken];
    [LSSave saveObject:nil forKey:LSQQWBExpireTime];
    [LSSave saveObject:nil forKey:LSQQWBUID];
    [LSSave saveObject:nil forKey:LSQQWBUserName];
}

@end
