//
//  LSFilmInfoInfoCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-5.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSFilmInfoInfoCell.h"

#define gap 100.f
#define InfoWidth 210.f
#define InfoHeight 18.f

@implementation LSFilmInfoInfoCell

@synthesize film=_film;

#pragma mark- 属性方法
- (void)setFilm:(LSFilm *)film
{
    if(![_film isEqual:film])
    {
        if(_film!=nil)
        {
            LSRELEASE(_film)
        }
        _film=[film retain];
        [self.imageView setImageWithURL:[NSURL URLWithString:_film.imageURL] placeholderImage:LSPlaceholderImage];
    }
}

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
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.clipsToBounds = YES;
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
    self.imageView.frame=CGRectMake(10.f, 10.f, 75.f, 100.f);
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);
    
    NSString *text = nil;
    
    text = [NSString stringWithFormat:@"导演：%@", _film.director==nil?@"--":_film.director];
    [text drawInRect:CGRectMake(gap, 6, InfoWidth, InfoHeight) withFont:LSFont14 lineBreakMode:NSLineBreakByTruncatingTail];
    
    text = [NSString stringWithFormat:@"主演：%@", _film.actor==nil?@"--":_film.actor];
    [text drawInRect:CGRectMake(gap, 24, InfoWidth, InfoHeight) withFont:LSFont14 lineBreakMode:NSLineBreakByTruncatingTail];
    
    text = [NSString stringWithFormat:@"类型：%@", _film.filmType==nil?@"--":_film.filmType];
    [text drawInRect:CGRectMake(gap, 42, InfoWidth, InfoHeight) withFont:LSFont14 lineBreakMode:NSLineBreakByTruncatingTail];
    
    text = [NSString stringWithFormat:@"国家：%@", _film.country==nil?@"--":_film.country];
    [text drawInRect:CGRectMake(gap, 60, InfoWidth, InfoHeight) withFont:LSFont14 lineBreakMode:NSLineBreakByTruncatingTail];
    
    text = [NSString stringWithFormat:@"片长：%@分钟", _film.duration==nil?@"--":_film.duration];
    [text drawInRect:CGRectMake(gap, 78, InfoWidth, InfoHeight) withFont:LSFont14 lineBreakMode:NSLineBreakByTruncatingTail];
    
    text = [NSString stringWithFormat:@"上映：%@", _film.releaseDate==nil?@"--":_film.releaseDate];
    [text drawInRect:CGRectMake(gap, 96, InfoWidth, InfoHeight) withFont:LSFont14 lineBreakMode:NSLineBreakByTruncatingTail];
    
    CGSize size=[text sizeWithFont:LSFont14];
    //绘制是否预售
    if(_film.isPresell)
    {
        [[UIImage lsImageNamed:@"icon_presell.png" ] drawInRect:CGRectMake(gap+size.width+5.f, 100, 33.f, 11.f)];
    }
}

@end
