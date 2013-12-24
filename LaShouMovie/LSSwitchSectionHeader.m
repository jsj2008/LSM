//
//  LSSwitchSectionHeader.m
//  LaShouMovie
//
//  Created by Li XiangYu on 13-9-15.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSSwitchSectionHeader.h"

@implementation LSSwitchSectionHeader

@synthesize delegate=_delegate;
@synthesize isSpread=_isSpread;
@synthesize schedule=_schedule;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UITapGestureRecognizer* tapGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfTap:)];
        [self addGestureRecognizer:tapGestureRecognizer];
        [tapGestureRecognizer release];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    NSString* text=[NSString stringWithFormat:@"%@ %@",_schedule.startDate,_schedule.startTime];
    CGRect titleRect=[text boundingRectWithSize:CGSizeMake(rect.size.width, INT32_MAX) options:NSStringDrawingTruncatesLastVisibleLine attributes:[LSAttribute attributeFont:LSFontScheduleTitle] context:nil];
    [text drawInRect:CGRectMake(0.f, (rect.size.height-titleRect.size.height)/2, titleRect.size.width, titleRect.size.height) withAttributes:[LSAttribute attributeFont:LSFontScheduleTitle color:LSColorTextGray textAlignment:NSTextAlignmentCenter]];
    
    if(_isSpread)
    {
        [[UIImage lsImageNamed:@""] drawInRect:rect];
    }
    else
    {
        [[UIImage lsImageNamed:@""] drawInRect:rect];
    }
}

- (void)selfTap:(UITapGestureRecognizer*)recognizer
{
    _isSpread=!_isSpread;
    [self setNeedsDisplay];
    [_delegate LSSwitchSectionHeader:self isSpread:_isSpread];
}

@end
