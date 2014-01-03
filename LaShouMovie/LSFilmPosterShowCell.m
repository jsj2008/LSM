//
//  LSFilmPosterShowCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-19.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSFilmPosterShowCell.h"
#define gap 10.f

@implementation LSFilmPosterShowCell

@synthesize film=_film;
@synthesize filmImageView=_filmImageView;

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
        _filmImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_filmImageView];
        [_filmImageView release];
        
        _starImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _starImageView.clipsToBounds = YES;
        _starImageView.contentMode = UIViewContentModeLeft;
        [self addSubview:_starImageView];
        [_starImageView release];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    //设置点亮的星星
    _starImageView.frame=CGRectMake(gap, self.height-(gap+70.f+gap)+50.f+1.f, 67.f*[_film.grade floatValue]/10, 11.f);
    _starImageView.image = [UIImage imageNamed:@"stars_full.png"];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if(_filmImageView.image)
    {
        [_filmImageView.image drawInRect:rect];
    }
    
    CGFloat contentX = gap;
    CGFloat contentY = rect.size.height-(gap+70.f+gap);
    
    [self drawRectangleInRect:CGRectMake(0.f, contentY, rect.size.width, gap+70.f+gap) fillColor:LSColorBackgroundBlack];
    
    contentY+=gap;
    
    NSString* text=nil;
    
    //imax:28  3D:17  预售:35
    
    text=_film.filmName;
    CGRect nameRect = [text boundingRectWithSize:CGSizeMake(rect.size.width-contentX-5.f-(_film.isPresell?(35.f+5.f):0.f)-(_film.dimensional==LSFilmDimensional3D?(17.f+5.f):0.f)-(_film.isIMAX?(28.f+5.f):0.f)-gap, INT32_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[LSAttribute attributeFont:LSFontFilmName] context:nil];
    
    [text drawInRect:CGRectMake(contentX, contentY, nameRect.size.width, 25.f) withAttributes:[LSAttribute attributeFont:LSFontFilmName color:LSColorWhite  lineBreakMode:NSLineBreakByTruncatingTail]];
    contentX+=(nameRect.size.width+5.f);
    
    //绘制imax
    if(_film.isIMAX)
    {
        [[UIImage lsImageNamed:@"icon_imax.png"] drawInRect:CGRectMake(contentX, contentY+3.f, 28.f, 14.f)];
        contentX+=28.f+5.f;
    }
    
    //绘制dimensional
    if(_film.dimensional==LSFilmDimensional3D)
    {
        [[UIImage lsImageNamed:@"icon_3d.png"] drawInRect:CGRectMake(contentX, contentY+3.f, 17.f, 14.f)];
        contentX+=17.f+5.f;
    }
    
    //绘制是否预售
    if(_film.isPresell)
    {
        [[UIImage lsImageNamed:@"icon_presell.png"] drawInRect:CGRectMake(contentX, contentY+3.f, 35.f, 14.f)];
        contentX+=35.f;
    }
    
    contentX = gap;
    contentY += 25.f;
    
    text=_film.brief;
    [text drawInRect:CGRectMake(contentX, contentY, rect.size.width-contentX-20.f-gap, 15.f) withAttributes:[LSAttribute attributeFont:LSFontFilmInfo color:LSColorWhite lineBreakMode:NSLineBreakByTruncatingTail]];
    
    contentY+=15.f;
    
    //绘制星级
    [[UIImage lsImageNamed:@"stars_empty.png"] drawInRect:CGRectMake(contentX, contentY+1.f, 67.f, 11.f)];
    
    contentY+=1.f;
    text = [NSString stringWithFormat:@"%@分", _film.grade];
    [text drawInRect:CGRectMake(contentX+67.f+5.f, contentY, rect.size.width, 15.f) withAttributes:[LSAttribute attributeFont:LSFontFilmInfo color:LSColorWhite lineBreakMode:NSLineBreakByTruncatingTail]];
    
    contentY+=15.f;
    
    //绘制上映信息
    if(_film.showCinemasCount>0 && _film.showSchedulesCount>0)
    {
        text=[NSString stringWithFormat:@"%d家影院上映%d场", _film.showCinemasCount, _film.showSchedulesCount];
    }
    else
    {
        text=@"没有上映影院";
    }
    [text drawInRect:CGRectMake(contentX, contentY, rect.size.width, 15.f) withAttributes:[LSAttribute attributeFont:LSFontFilmInfo color:LSColorWhite lineBreakMode:NSLineBreakByTruncatingTail]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
