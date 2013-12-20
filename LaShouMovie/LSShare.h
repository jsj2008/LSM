//
//  LSShare.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-21.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSShare : NSObject

+ (BOOL)sinaWBShareAuthStatus;
+ (BOOL)qqWBShareAuthStatus;
+ (void)logoutSinaWB;
+ (void)logoutQQWB;
@end
