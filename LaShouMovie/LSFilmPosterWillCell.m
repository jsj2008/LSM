//
//  LSFilmPosterWillCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-19.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSFilmPosterWillCell.h"
#define gap 10.f

@implementation LSFilmPosterWillCell

@synthesize filmImageView=_filmImageView;
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
        _filmImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_filmImageView];
        [_filmImageView release];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
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
    
    //imax:28  3D:17  预售:35
    
    NSString* text=nil;
    
    text=_film.filmName;
    CGRect nameRect=[text boundingRectWithSize:CGSizeMake(rect.size.width-contentX-5.f-(_film.isPresell?(35.f+5.f):0.f)-(_film.dimensional==LSFilmDimensional3D?(17.f+5.f):0.f)-(_film.isIMAX?(28.f+5.f):0.f)-gap, INT32_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[LSAttribute attributeFont:LSFontFilmName] context:nil];
    
    [text drawInRect:CGRectMake(contentX, contentY, nameRect.size.width, 25.f) withAttributes:[LSAttribute attributeFont:LSFontFilmName color:LSColorWhite lineBreakMode:NSLineBreakByTruncatingTail]];
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
    contentY+=30.f;
    
    //绘制上映日期
    text=[NSString stringWithFormat:@"上映日期：%@", _film.releaseDate];
    [text drawInRect:CGRectMake(contentX, contentY, rect.size.width-contentX-gap, 20.f) withAttributes:[LSAttribute attributeFont:LSFontFilmInfo color:LSColorWhite lineBreakMode:NSLineBreakByTruncatingTail]];
    
    contentY+=20.f;
    text=_film.brief;
    [text drawInRect:CGRectMake(contentX, contentY, rect.size.width-contentX-gap, 20.f) withAttributes:[LSAttribute attributeFont:LSFontFilmInfo color:LSColorWhite lineBreakMode:NSLineBreakByTruncatingTail]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
