//
//  UIView+Extension.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-2.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (void)removeAllSubview
{
    for (UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }
}

- (CGFloat)left
{
	return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x
{
	CGRect frame = self.frame;
	frame.origin.x = x;
	self.frame = frame;
}

- (CGFloat)top
{
	return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y
{
	CGRect frame = self.frame;
	frame.origin.y = y;
	self.frame = frame;
}

- (CGFloat)right
{
	return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right
{
	CGRect frame = self.frame;
	frame.origin.x = right - frame.size.width;
	self.frame = frame;
}

- (CGFloat)bottom
{
	return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom
{
	CGRect frame = self.frame;
	frame.origin.y = bottom - frame.size.height;
	self.frame = frame;
}

- (CGFloat)width
{
	return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
	CGRect frame = self.frame;
	frame.size.width = width;
	self.frame = frame;
}

- (CGFloat)height
{
	return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
	CGRect frame = self.frame;
	frame.size.height = height;
	self.frame = frame;
}

- (void)drawRectangleInRect:(CGRect)rect fillColor:(UIColor*)fillColor
{
    [self drawRectangleInRect:rect borderWidth:0.f fillColor:fillColor strokeColor:fillColor];
}

- (void)drawRectangleInRect:(CGRect)rect borderWidth:(CGFloat)borderWidth fillColor:(UIColor*)fillColor strokeColor:(UIColor *)strokeColor
{
    [self drawRectangleInRect:rect borderWidth:borderWidth fillColor:fillColor strokeColor:strokeColor topRadius:0.f bottomRadius:0.f];
}

- (void)drawRectangleInRect:(CGRect)rect borderWidth:(CGFloat)borderWidth fillColor:(UIColor*)fillColor strokeColor:(UIColor *)strokeColor topRadius:(CGFloat)topRadius bottomRadius:(CGFloat)bottomRadius
{
	CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(contextRef,true);//取消锯齿
    
	CGContextSetStrokeColorWithColor(contextRef, strokeColor.CGColor);
    CGContextSetFillColorWithColor(contextRef, fillColor.CGColor);

    CGContextSetLineWidth(contextRef, borderWidth);
	CGRect rrect = CGRectMake((rect.origin.x + borderWidth), (rect.origin.y + borderWidth), (rect.size.width - borderWidth*2), rect.size.height - borderWidth);
	
	CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
	CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
	CGContextMoveToPoint(contextRef, minx, midy);
	CGContextAddArcToPoint(contextRef, minx, miny, midx, miny, topRadius);
	CGContextAddArcToPoint(contextRef, maxx, miny, maxx, midy, topRadius);
	CGContextAddArcToPoint(contextRef, maxx, maxy, midx, maxy, bottomRadius);
	CGContextAddArcToPoint(contextRef, minx, maxy, minx, midy, bottomRadius);
	CGContextClosePath(contextRef);
	CGContextDrawPath(contextRef, kCGPathFillStroke);
}

- (void)drawLineAtStartPointX:(CGFloat)x1 y:(CGFloat)y1 endPointX:(CGFloat)x2 y:(CGFloat)y2 strokeColor:(UIColor *)strokeColor lineWidth:(CGFloat)lineWidth
{
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    if(lineWidth>0.f)
    {
        CGContextSetLineWidth(contextRef, lineWidth);
    }
    else
    {
        CGContextSetLineWidth(contextRef, 1.f);
    }
    CGContextSetLineWidth(contextRef, lineWidth);
    CGContextBeginPath(contextRef);//准备画线
    CGContextMoveToPoint(contextRef, x1, y1-lineWidth);//设置起始点
    CGContextAddLineToPoint(contextRef, x2, y2-lineWidth);//设置结束点
    CGContextSetStrokeColorWithColor(contextRef, strokeColor.CGColor);//设置画笔颜色
    CGContextStrokePath(contextRef);//上色
}

@end
