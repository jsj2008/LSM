//
//  UINavigationBar+Extension.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-5.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "UINavigationBar+Extension.h"

@implementation UINavigationBar (Extension)

//- (void)drawRect:(CGRect)rect
//{
//    [super drawRect:rect];
//    UIImage* image = [UIImage lsImageNamed:@"nav_bg.png"];
//    [image drawInRect:CGRectMake(0, 0, rect.size.width, rect.size.height)];
//}

- (void)setNeedsLayout
{
	[super setNeedsLayout];
    
	//self.clipsToBounds = YES;
    //判断iOS版本是否为5.0或者以上
    if([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [self setBackgroundImage:[UIImage lsImageNamed:@"nav_bg.png"] forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        [self setNeedsDisplay];
    }
}

@end
