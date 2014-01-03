//
//  UIImage+Extension.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-8-30.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

static BOOL isRetina=NO;
+ (void)setIsRetina
{
    LSLOG(@"%f,%f",[UIScreen mainScreen].currentMode.size.width,[UIScreen mainScreen].currentMode.size.width);
    isRetina=[UIScreen instancesRespondToSelector:@selector(currentMode)]?CGSizeEqualToSize(CGSizeMake(640, 960), [UIScreen mainScreen].currentMode.size):NO;
    isRetina=YES;
}

+ (UIImage*)lsImageNamed:(NSString*)name
{
    NSString* path=nil;
    if([name rangeOfString:@".png"].location!=NSNotFound)
    {
        path=[[name substringToIndex:name.length-4] stringByAppendingString:(isRetina?@"@2x":@"")];
        //NSLog(@"%@",path);
    }
    else
    {
        path=[name stringByAppendingString:(isRetina?@"@2x":@"")];
    }
    path=[[NSBundle mainBundle] pathForResource:path ofType:@"png"];
    return [UIImage  imageWithContentsOfFile:path];
}

+ (UIImage*)lsImageNamed:(NSString*)name is568:(BOOL)is568
{
    NSString* path=nil;
    if([name rangeOfString:@".png"].location!=NSNotFound)
    {
        path=[name substringToIndex:name.length-4];
        path=[path stringByAppendingString:(is568?@"-568h":@"")];
        path=[path stringByAppendingString:(isRetina?@"@2x":@"")];
        //NSLog(@"%@",path);
    }
    else
    {
        path=[name stringByAppendingString:(is568?@"-568h":@"")];
        path=[path stringByAppendingString:(isRetina?@"@2x":@"")];
    }
    path=[[NSBundle mainBundle] pathForResource:path ofType:@"png"];
    return [UIImage  imageWithContentsOfFile:path];
}

+ (UIImage *)stretchableImageWithImageName:(NSString *)name top:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right
{
    return [UIImage stretchableImageWithImage:[UIImage lsImageNamed:name] top:top left:left bottom:bottom right:right];
}

+ (UIImage *)stretchableImageWithImage:(UIImage *)image top:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right
{
    if(image)
    {
        if ([image respondsToSelector:@selector(resizableImageWithCapInsets:)])
        {
            return [image resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, bottom, right)];
        }
        else
        {
            return [image stretchableImageWithLeftCapWidth:left topCapHeight:top];
        }
    }
    return nil;
}

+ (UIImage*)scaleToSizeWithImageName:(NSString *)name size:(CGSize)size
{
    return [UIImage scaleToSizeWithImage:[UIImage lsImageNamed:name] size:size];
}

+ (UIImage*)scaleToSizeWithImage:(UIImage *)image size:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0.f, 0.f, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}


@end
