//
//  LSAttribute.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-18.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSAttribute.h"

@implementation LSAttribute

#pragma mark- 以下方法可用于测量和绘制
+ (NSDictionary*)attributeFont:(UIFont*)font
{
    return [self attributeFont:font lineBreakMode:NSLineBreakByCharWrapping];
}

+ (NSDictionary*)attributeFont:(UIFont*)font lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    return [self attributeFont:font lineBreakMode:lineBreakMode textAlignment:NSTextAlignmentLeft];
}

#pragma mark- 以下方法更加侧重于绘制
+ (NSDictionary*)attributeFont:(UIFont*)font color:(UIColor*)color
{
    return [self attributeFont:font color:color lineBreakMode:NSLineBreakByWordWrapping];
}

+ (NSDictionary*)attributeFont:(UIFont*)font color:(UIColor*)color lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    return [self attributeFont:font color:color lineBreakMode:lineBreakMode textAlignment:NSTextAlignmentLeft];
}

+ (NSDictionary*)attributeFont:(UIFont*)font color:(UIColor*)color textAlignment:(NSTextAlignment)textAlignment
{
    return [self attributeFont:font color:color lineBreakMode:NSLineBreakByCharWrapping textAlignment:textAlignment];
}

+ (NSDictionary*)attributeFont:(UIFont*)font lineBreakMode:(NSLineBreakMode)lineBreakMode textAlignment:(NSTextAlignment)textAlignment
{
    return [self attributeFont:font color:[UIColor blackColor] lineBreakMode:lineBreakMode textAlignment:textAlignment];
}

+ (NSDictionary*)attributeFont:(UIFont*)font textAlignment:(NSTextAlignment)textAlignment
{
    return [self attributeFont:font color:[UIColor blackColor] lineBreakMode:NSLineBreakByCharWrapping textAlignment:textAlignment];
}

+ (NSDictionary*)attributeFont:(UIFont*)font color:(UIColor*)color lineBreakMode:(NSLineBreakMode)lineBreakMode textAlignment:(NSTextAlignment)textAlignment
{
    NSMutableDictionary* mDic=[NSMutableDictionary dictionaryWithCapacity:0];
    if(font)
    {
        [mDic setObject:font forKey:NSFontAttributeName];
    }
    
    if(color)
    {
        [mDic setObject:color forKey:NSForegroundColorAttributeName];
    }
    
    /*
     @property(readwrite) CGFloat lineSpacing;
     @property(readwrite) CGFloat paragraphSpacing;
     @property(readwrite) NSTextAlignment alignment;
     @property(readwrite) CGFloat firstLineHeadIndent;
     @property(readwrite) CGFloat headIndent;
     @property(readwrite) CGFloat tailIndent;
     @property(readwrite) NSLineBreakMode lineBreakMode;
     @property(readwrite) CGFloat minimumLineHeight;
     @property(readwrite) CGFloat maximumLineHeight;
     @property(readwrite) NSWritingDirection baseWritingDirection;
     @property(readwrite) CGFloat lineHeightMultiple;
     @property(readwrite) CGFloat paragraphSpacingBefore;
     @property(readwrite) float hyphenationFactor;
     @property(readwrite,copy,NS_NONATOMIC_IOSONLY) NSArray *tabStops NS_AVAILABLE_IOS(7_0);
     @property(readwrite,NS_NONATOMIC_IOSONLY) CGFloat defaultTabInterval NS_AVAILABLE_IOS(7_0);
     */
    
    /*
     NSLineBreakByWordWrapping = 0,
     NSLineBreakByCharWrapping,
     NSLineBreakByClipping,
     NSLineBreakByTruncatingHead,
     NSLineBreakByTruncatingTail,
     NSLineBreakByTruncatingMiddle
     */
    
    /*
    NSTextAlignmentLeft      = 0,
    NSTextAlignmentCenter    = 1,
    NSTextAlignmentRight     = 2,
    NSTextAlignmentJustified = 3,
    NSTextAlignmentNatural   = 4,
     */
    
    NSMutableParagraphStyle* paragraphStyle=[[[NSMutableParagraphStyle alloc] init] autorelease];
    if(lineBreakMode)
    {
        paragraphStyle.lineBreakMode=lineBreakMode;
    }
    
    if(textAlignment)
    {
        paragraphStyle.alignment=textAlignment;
    }
    
    [mDic setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    
    return mDic;
}

@end
