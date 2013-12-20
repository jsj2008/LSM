//
//  LSSaveUserInfo.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-6.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSSave.h"
#import "STKeychain.h"

@implementation LSSave

static NSUserDefaults* userDefaults;
+ (void)setUserDefaults
{
    userDefaults=[NSUserDefaults standardUserDefaults];
}


+ (BOOL)saveUser
{
    NSData* data=[NSKeyedArchiver archivedDataWithRootObject:[LSUser currentUser]];
    [userDefaults setObject:data forKey:LSUSER];
    return [userDefaults synchronize];
}

+ (LSUser*)obtainUser
{
    id object=[userDefaults objectForKey:LSUSER];
    if(object==NULL || object==[NSNull null] || object==nil)
    {
        return nil;
    }
    else
    {
        return [NSKeyedUnarchiver unarchiveObjectWithData:object];
    }
}

+ (BOOL)saveObject:(NSString*)object forKey:(NSString*)key
{
    if(object!=nil)
    {
        [userDefaults setObject:object forKey:key];
    }
    else
    {
        [userDefaults removeObjectForKey:key];
    }
    return [userDefaults synchronize];
}

+ (id)obtainForKey:(NSString*)key
{
    id object=[userDefaults objectForKey:key];
    if(object==NULL || object==[NSNull null] || object==nil)
    {
        return nil;
    }
    else
    {
        return object;
    }
}

+ (BOOL)savePassword
{
    LSUser* user=[LSUser currentUser];
    return [STKeychain storeUsername:user.userName andPassword:user.password forServiceName:nil updateExisting:YES error:nil];
}

+ (NSString*)obtainPassword
{
    LSUser* user=[LSUser currentUser];
    return [STKeychain getPasswordForUsername:user.userName andServiceName:nil error:nil];
}

@end
