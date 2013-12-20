//
//  LSTools.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-8-22.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSTools : NSObject

//检查邮箱格式
+(BOOL)checkEmail:(NSString*)email;
//检查手机号格式
+(BOOL)checkPhone:(NSString*)phone;

//获取唯一标识
//获取手机网卡地址
+ (NSString*)makeMacAddress;
//获取开源唯一标识符
+ (NSString*)makeOpenUDID;

//转换时间格式
+ (NSString*)convertTimeString:(NSString*)timeString toCustomTimeFomatter:(NSString*)fomatter;//时间间隔
+ (NSString*)nowTimeString;

//解压当前的压缩文件，如果filePath为nil，则不保存
+ (NSData*)unzipToFilePath:(NSString *)filePath;//解压文件

//判断当前设备类型
+ (NSString*)platform;
+ (NSString*)deviceType;

//生成安全数据
+ (void)makeSafeData:(id)data;

//用于强制升级
+ (NSString *)stid;

//计算两坐标之间的距离，返回合理字符串
+ (NSString*)distanceWithLongitude1:(double)lon1 latitude1:(double)lat1 longitude2:(double)lon2 latitude2:(double)lat2;

@end
