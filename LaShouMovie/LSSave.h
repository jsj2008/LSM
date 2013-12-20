//
//  LSSave.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-6.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LSUSER              @"LSUSER"
#define ALIUSER             @"ALIUSER"

@interface LSSave : NSObject

//此方法在应用启动时执行，激活LSUser
+ (void)setUserDefaults;

//用户保存和关键值保存都使用NSUserDefault
+ (BOOL)saveUser;
+ (LSUser*)obtainUser;

+ (BOOL)saveObject:(NSString*)object forKey:(NSString*)key;
+ (id)obtainForKey:(NSString*)key;

//密码保存使用STKeychain
+ (BOOL)savePassword;
+ (NSString*)obtainPassword;

@end
