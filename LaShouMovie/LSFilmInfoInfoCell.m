//
//  LSFilmInfoInfoCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-5.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSFilmInfoInfoCell.h"
#import "FXBlurView.h"

#define gap 10.f

@implementation LSFilmInfoInfoCell

@synthesize film=_film;

#pragma mark- 生命周期

- (void)dealloc
{
    self.film=nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.isClearBG=YES;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame=CGRectMake(10.f, 10.f, 80.f, 100.f);
    
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
//    [self drawRectangleInRect:rect fillColor:LSRGBA(0, 0, 0, 0.5)];
    
    CGFloat contentX=gap+80.f+gap;
    CGFloat contentY=gap;
    CGFloat width=rect.size.width-(gap+80.f+gap)-gap;
    NSString* text=nil;
    
    NSDictionary* attDic=[[LSAttribute attributeFont:LSFontFilmDetail color:LSColorWhite lineBreakMode:NSLineBreakByTruncatingTail] retain];
    
    text = [NSString stringWithFormat:@"导演：%@", _film.director==nil?@"--":_film.director];
    [text drawInRect:CGRectMake(contentX, contentY, width, 16.5f) withAttributes:attDic];
    contentY+=16.5f;
    
    text = [NSString stringWithFormat:@"主演：%@", _film.actor==nil?@"--":_film.actor];
    [text drawInRect:CGRectMake(contentX, contentY, width, 16.5f) withAttributes:attDic];
    contentY+=16.5f;
    
    text = [NSString stringWithFormat:@"类型：%@", _film.filmType==nil?@"--":_film.filmType];
    [text drawInRect:CGRectMake(contentX, contentY, width, 16.5f) withAttributes:attDic];
    contentY+=16.5f;
    
    text = [NSString stringWithFormat:@"国家：%@", _film.country==nil?@"--":_film.country];
    [text drawInRect:CGRectMake(contentX, contentY, width, 16.5f) withAttributes:attDic];
    contentY+=16.5f;
    
    text = [NSString stringWithFormat:@"片长：%@分钟", _film.duration==nil?@"--":_film.duration];
    [text drawInRect:CGRectMake(contentX, contentY, width, 16.5f) withAttributes:attDic];
    contentY+=16.5f;
    
    text = [NSString stringWithFormat:@"上映：%@", _film.releaseDate==nil?@"--":_film.releaseDate];
    [text drawInRect:CGRectMake(contentX, contentY, width, 16.5f) withAttributes:attDic];
    
    LSRELEASE(attDic)
    
    //绘制是否预售
    if(_film.isPresell)
    {
        [[UIImage lsImageNamed:@"" ] drawInRect:CGRectMake(10.f, 99.f, 35.f, 11.f)];
    }
}

@end
