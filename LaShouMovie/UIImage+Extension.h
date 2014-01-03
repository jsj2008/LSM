//
//  UIImage+Extension.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-8-30.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

//设置是否高清屏
+ (void)setIsRetina;

//使用不占用内存的图片
+ (UIImage*)lsImageNamed:(NSString*)name;
+ (UIImage*)lsImageNamed:(NSString*)name is568:(BOOL)is568;
+ (UIImage *)stretchableImageWithImageName:(NSString *)name top:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right;
+ (UIImage *)stretchableImageWithImage:(UIImage *)image top:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right;
+ (UIImage*)scaleToSizeWithImageName:(NSString *)name size:(CGSize)size;
+ (UIImage*)scaleToSizeWithImage:(UIImage *)image size:(CGSize)size;
//计算图片宽高
//{
//    h,
//    w
//}
//- (NSDictionary*)calculateImageHeightAndWidth;
//- (UIImage *)imageCompressWithScale:(float)scaleSize;
//- (UIImage *)imageCompress;

@end
