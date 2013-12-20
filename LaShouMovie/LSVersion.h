//
//  LSVersion.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-8-29.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSVersion : NSObject
{
    //{
    //    isForceUpgrade = 0;
    //    isPromptUpgrade = 1;
    //    newestVersion = "1.2.3";
    //    url = "https://itunes.apple.com/cn/app/id599209062?mt=8";
    //    versionDescript = "\U53d1\U73b0\U65b0\U7248\U672c\Uff0c\U9700\U8981\U5347\U7ea7\U3002\U5f71\U7247\U5f71\U9662\U6392\U671f\U63a5\U53e3\U5347\U7ea7\Uff0c\U901f\U5ea6\U63d0\U5347\Uff1b\U652f\U4ed8\U5b9d\U63a5\U53e3\U4f18\U5316\Uff0c\U652f\U4ed8\U66f4\U65b9\U4fbf\U3002";
    //}
    
    NSString* _version;//版本
    BOOL _isForce;//强制升级
    BOOL _isPrompt;//提醒强度(是否弹窗)
    NSString* _downloadURL;
    NSString* _message;
}

@property(nonatomic,retain) NSString* version;
@property(nonatomic,assign) BOOL isForce;
@property(nonatomic,assign) BOOL isPrompt;
@property(nonatomic,retain) NSString* downloadURL;
@property(nonatomic,retain) NSString* message;

+ (LSVersion *)currentVersion;
- (void)reset;
- (void)completePropertyWithDictionary:(NSDictionary*)safeDic;

@end
