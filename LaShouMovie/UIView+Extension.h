//
//  UIView+Extension.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-2.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <Foundation/Foundation.h>

@interface UIView (Extension)

@property(nonatomic,assign) CGFloat left;
@property(nonatomic,assign) CGFloat top;
@property(nonatomic,assign) CGFloat right;
@property(nonatomic,assign) CGFloat bottom;

@property(nonatomic,assign) CGFloat width;
@property(nonatomic,assign) CGFloat height;

- (void)removeAllSubview;

- (void)drawRectangleInRect:(CGRect)rect fillColor:(UIColor*)fillColor;
- (void)drawRectangleInRect:(CGRect)rect borderWidth:(CGFloat)borderWidth fillColor:(UIColor*)fillColor strokeColor:(UIColor *)strokeColor;
- (void)drawRectangleInRect:(CGRect)rect borderWidth:(CGFloat)borderWidth fillColor:(UIColor*)fillColor strokeColor:(UIColor *)strokeColor topRadius:(CGFloat)topRadius bottomRadius:(CGFloat)bottomRadius;

- (void)drawLineAtStartPointX:(CGFloat)x1 y:(CGFloat)y1 endPointX:(CGFloat)x2 y:(CGFloat)y2 strokeColor:(UIColor *)strokeColor lineWidth:(CGFloat)lineWidth;

@end
