//
//  LSAttribute.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-18.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSAttribute : NSObject

#pragma mark- 以下方法可用于测量和绘制
+ (NSDictionary*)attributeFont:(UIFont*)font;
+ (NSDictionary*)attributeFont:(UIFont*)font lineBreakMode:(NSLineBreakMode)lineBreakMode;

#pragma mark- 以下方法更加侧重于绘制
+ (NSDictionary*)attributeFont:(UIFont*)font color:(UIColor*)color;
+ (NSDictionary*)attributeFont:(UIFont*)font color:(UIColor*)color lineBreakMode:(NSLineBreakMode)lineBreakMode;
+ (NSDictionary*)attributeFont:(UIFont*)font color:(UIColor*)color textAlignment:(NSTextAlignment)textAlignment;
+ (NSDictionary*)attributeFont:(UIFont*)font lineBreakMode:(NSLineBreakMode)lineBreakMode textAlignment:(NSTextAlignment)textAlignment;
+ (NSDictionary*)attributeFont:(UIFont*)font textAlignment:(NSTextAlignment)textAlignment;
+ (NSDictionary*)attributeFont:(UIFont*)font color:(UIColor*)color lineBreakMode:(NSLineBreakMode)lineBreakMode textAlignment:(NSTextAlignment)textAlignment;

@end
