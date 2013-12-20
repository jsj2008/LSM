//
//  LSFilmInfoDescriptionCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-5.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSFilmInfoDescriptionCell.h"

#define gap 10.f

@implementation LSFilmInfoDescriptionCell

@synthesize isSpread=_isSpread;
@synthesize film=_film;

+ (CGFloat)heightOfFilm:(LSFilm*)film
{
    return [film.description boundingRectWithSize:CGSizeMake(300.f, INT32_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:[LSAttribute attributeFont:LSFontFilmBrief] context:nil].size.height+44.f;
}

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
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect
{
    //绘制信息
    if(_film.description)
    {
        [_film.description drawInRect:CGRectMake(gap, gap, rect.size.width-gap*2, rect.size.height-44.f) withAttributes:[LSAttribute attributeFont:LSFontFilmBrief lineBreakMode:NSLineBreakByTruncatingTail]];
    }
    
    [[UIImage lsImageNamed:_isSpread?@"":@""] drawInRect:CGRectMake(gap, rect.size.height-44.f, rect.size.width-gap*2, 44.f)];
}

@end
