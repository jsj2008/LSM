//
//  LSCinemaInfoScheduleCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-12.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSCinemaInfoScheduleCell.h"

#define gapL 30.f

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
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor= [UIColor clearColor];
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

- (void)drawRect:(CGRect)rect
{
    [[UIImage stretchableImageWithImage:[UIImage lsImageNamed:@"schedule_bg.png"] top:22 left:7 bottom:22 right:7] drawInRect:CGRectMake(10.f, 0.f, rect.size.width-20.f, rect.size.height)];
    
    [self drawLineAtStartPointX:20.f y:rect.size.height endPointX:rect.size.width-20.f y:rect.size.height strokeColor:LSColorLineLightGrayColor lineWidth:1.f];

    CGFloat contentX=gapL;
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);
    if (_schedule.startTime)
    {
        CGSize size=[_schedule.startTime sizeWithFont:LSFont15];
        [_schedule.startTime drawInRect:CGRectMake(contentX, (rect.size.height-size.height)/2, size.width, size.height) withFont:LSFont15];
    }
    contentX+=50.f;//此处必须增加
    
    if (_schedule.language)
    {
        NSString* text=nil;
        if(_schedule.dimensional==LSFilmDimensional2D)
        {
            text=[NSString stringWithFormat:@"%@/2D",_schedule.language];
        }
        else if(_schedule.dimensional==LSFilmDimensional3D)
        {
            text=[NSString stringWithFormat:@"%@/3D",_schedule.language];
        }
        else
        {
            text=[NSString stringWithFormat:@"%@",_schedule.language];
        }
        
        CGSize size=[text sizeWithFont:LSFont15];
        [text drawInRect:CGRectMake(contentX, (rect.size.height-size.height)/2, size.width, size.height) withFont:LSFont15];
    }
    contentX+=75.f;
    
    if (_schedule.hall.hallName!=nil)
    {
        CGSize size=[_schedule.hall.hallName sizeWithFont:LSFont15 constrainedToSize:CGSizeMake(70.f, rect.size.height) lineBreakMode:NSLineBreakByTruncatingTail];
        [_schedule.hall.hallName drawInRect:CGRectMake(contentX, (rect.size.height-size.height)/2, 70.f, size.height) withFont:LSFont15  lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentRight];
    }
    
    
    contentX=240.f;
    CGContextSetFillColorWithColor(contextRef, LSColorBlackRedColor.CGColor);
    NSString* text = @"￥";
    CGSize size=[text sizeWithFont:LSFont13];
    [text drawInRect:CGRectMake(contentX,(rect.size.height-size.height)/2+2.f, size.width, size.height) withFont:LSFont13];
    contentX+=size.width;
    
    text=[[NSString stringWithFormat:@"%.2f", _schedule.price] stringByReplacingOccurrencesOfString:@".00" withString:@""];
    size=[text sizeWithFont:LSFont15];
    [text drawInRect:CGRectMake(contentX, (rect.size.height-size.height)/2, size.width, size.height) withFont:LSFont15];
    
    [[UIImage lsImageNamed:@"cinemas_arrow.png"] drawInRect:CGRectMake(rect.size.width-30.f, (rect.size.height-15.f)/2, 10.f, 15.f)];
}


#pragma mark- 重载触摸方法
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor=LSColorBgRedYellowColor;
    [super touchesBegan:touches withEvent:event];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor=[UIColor clearColor];
    [super touchesEnded:touches withEvent:event];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor=[UIColor clearColor];
    [super touchesCancelled:touches withEvent:event];
}

@end
