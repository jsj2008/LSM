//
//  LSCinemaInfoGroupCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-12.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSCinemaInfoGroupCell.h"
#define gap 10.f

@implementation LSCinemaInfoGroupCell

@synthesize iconImageView=_iconImageView;
@synthesize title=_title;
@synthesize topRadius=_topRadius;
@synthesize bottomRadius=_bottomRadius;
@synthesize isBottomLine=_isBottomLine;

#pragma mark- 生命周期
- (void)dealloc
{
    self.title=nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_iconImageView];
        [_iconImageView release];
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
    [self drawRectangleInRect:CGRectInset(rect, gap, 0.f) borderWidth:0.f fillColor:LSColorBackgroundGray strokeColor:LSColorBackgroundGray topRadius:_topRadius bottomRadius:_bottomRadius];
    if(_isBottomLine)
    {
        [self drawLineAtStartPointX:gap y:rect.size.height endPointX:rect.size.width-gap*2 y:rect.size.height strokeColor:LSColorTextBlack lineWidth:1.f];
    }
    
    CGRect titleRect=[_title boundingRectWithSize:CGSizeMake(rect.size.width-gap*2-30.f-gap-gap*2, INT32_MAX) options:NSStringDrawingTruncatesLastVisibleLine attributes:[LSAttribute attributeFont:LSFontCinemaGroup] context:nil];
    [_title drawInRect:CGRectMake(gap*2+30.f+gap, (rect.size.height-titleRect.size.height)/2, titleRect.size.width, titleRect.size.height) withAttributes:[LSAttribute attributeFont:LSFontCinemaGroup lineBreakMode:NSLineBreakByTruncatingTail]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _iconImageView.frame=CGRectMake(20.f, (self.height-30.f)/2, 30.f, 30.f);
}

@end
