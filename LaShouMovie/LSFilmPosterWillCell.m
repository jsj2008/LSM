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
    _filmImageView.frame=CGRectMake(0.f, 0.f, self.width, self.height);
}

- (void)drawRect:(CGRect)rect
{
    CGFloat contentX = gap;
    CGFloat contentY = rect.size.height-(gap+70.f+gap);
    
    [self drawRectangleInRect:CGRectMake(0.f, contentY, rect.size.width, gap+70.f+gap) fillColor:[UIColor whiteColor]];
    
    //imax:28  3D:17  预售:35
    CGRect nameRect = [_film.filmName boundingRectWithSize:CGSizeMake(rect.size.width-contentX-(_film.isPresell?(35.f+5.f):0.f)-(_film.dimensional==LSFilmDimensional3D?(17.f+5.f):0.f)-(_film.isIMAX?(28.f+5.f):0.f)-10.f, INT32_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[LSAttribute attributeFont:LSFontFilmName] context:nil];
    
    [_film.filmName drawInRect:CGRectMake(contentX, contentY, rect.size.width-contentX-(_film.isPresell?(35.f+5.f):0.f)-(_film.dimensional==LSFilmDimensional3D?(17.f+5.f):0.f)-(_film.isIMAX?(28.f+5.f):0.f)-10.f, INT32_MAX) withAttributes:[LSAttribute attributeFont:LSFontFilmName lineBreakMode:NSLineBreakByTruncatingTail]];
    contentX+=(nameRect.size.width+5.f);
    
    //绘制imax
    if(_film.isIMAX)
    {
        [[UIImage lsImageNamed:@"film_imax.png" ] drawInRect:CGRectMake(contentX, contentY+2.f, 28.f, 11.f)];
        contentX+=28.f+5.f;
    }
    
    //绘制dimensional
    if(_film.dimensional==LSFilmDimensional3D)
    {
        [[UIImage lsImageNamed:@"film_3d.png" ] drawInRect:CGRectMake(contentX, contentY+2.f, 17.f, 11.f)];
        contentX+=17.f+5.f;
    }
    
    //绘制是否预售
    if(_film.isPresell)
    {
        [[UIImage lsImageNamed:@"icon_presell.png" ] drawInRect:CGRectMake(contentX, contentY+2.f, 35.f, 11.f)];
        contentX+=35.f;
    }
    
    contentX = gap;
    contentY += 30.f;
    
    //绘制上映日期
    NSString* text=[NSString stringWithFormat:@"上映日期：%@", _film.releaseDate];
    [text drawInRect:CGRectMake(contentX, contentY, rect.size.width-contentX-10.f, 20.f) withAttributes:[LSAttribute attributeFont:LSFontFilmInfo lineBreakMode:NSLineBreakByTruncatingTail]];
    
    contentY += 20.f;
    
    [_film.brief drawInRect:CGRectMake(contentX, contentY, rect.size.width-contentX-10.f, 20.f) withAttributes:[LSAttribute attributeFont:LSFontFilmInfo lineBreakMode:NSLineBreakByTruncatingTail]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
