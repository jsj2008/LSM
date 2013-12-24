//
//  LSCinemaInfoScheduleCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-12.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSCinemaInfoScheduleCell.h"

#define gap 10.f

@implementation LSCinemaInfoScheduleCell

@synthesize schedule=_schedule;

- (void)dealloc
{
    self.schedule=nil;
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
    [self drawLineAtStartPointX:gap y:rect.size.height endPointX:rect.size.width-gap*2 y:rect.size.height strokeColor:LSColorBlack lineWidth:1.f];
    
    CGFloat contentX=gap;
    CGFloat contentY=gap;

    [_schedule.startTime drawInRect:CGRectMake(contentX, contentY, 100.f, 25.f) withAttributes:[LSAttribute attributeFont:LSFontScheduleTitle]];
    [_schedule.expectEndTime drawInRect:CGRectMake(contentX, contentY+25.f, 100.f, 15.f) withAttributes:[LSAttribute attributeFont:LSFontScheduleSubtitle]];
    
    contentX=+100.f;
    
    NSString* text=nil;
    if(_schedule.dimensional==LSFilmDimensional2D)
    {
        text=[NSString stringWithFormat:@"%@ 2D",_schedule.language];
    }
    else if(_schedule.dimensional==LSFilmDimensional3D)
    {
        text=[NSString stringWithFormat:@"%@ 3D",_schedule.language];
    }
    else
    {
        text=[NSString stringWithFormat:@"%@",_schedule.language];
    }
    [text drawInRect:CGRectMake(contentX, contentY, 140.f, 25.f) withAttributes:[LSAttribute attributeFont:LSFontScheduleTitle]];
    [text drawInRect:CGRectMake(contentX, contentY+25.f, 140.f, 15.f) withAttributes:[LSAttribute attributeFont:LSFontScheduleTitle]];
    
    contentX+=140.f;

    text = @"￥";
    CGRect yRect=[text boundingRectWithSize:CGSizeMake(70.f, INT32_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[LSAttribute attributeFont:LSFontScheduleY] context:nil];
    [text drawInRect:CGRectMake(contentX, (rect.size.height-yRect.size.height)/2, yRect.size.width, yRect.size.height) withAttributes:[LSAttribute attributeFont:LSFontScheduleY color:LSColorTextRed]];

    contentX+=yRect.size.width;
    
    CGRect priceRect=[_schedule.price boundingRectWithSize:CGSizeMake(70.f, INT32_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[LSAttribute attributeFont:LSFontSchedulePrice] context:nil];
    [_schedule.price drawInRect:CGRectMake(contentX, (rect.size.height-yRect.size.height)/2-(priceRect.size.height-yRect.size.height)/2, priceRect.size.width, priceRect.size.height) withAttributes:[LSAttribute attributeFont:LSFontSchedulePrice color:LSColorTextRed]];
}

@end
