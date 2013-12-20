//
//  LSOrderView.m
//  LaShouMovie
//
//  Created by Li XiangYu on 13-9-23.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSOrderView.h"
#import "LSSeat.h"

#define gapL 20
#define basicWidth 225
#define basicHeight 23
#define basicFont LSFont15
#define basicSize CGSizeMake(basicWidth, INT32_MAX)

@implementation LSOrderView

@synthesize order=_order;
@synthesize contentY=_contentY;

- (void)setOrder:(LSOrder *)order
{
    if(![_order isEqual:order])
    {
        if(_order!=nil)
        {
            LSRELEASE(_order)
        }
        _order=[order retain];
        
        _contentY = 10;
        if (_order.film.filmName!=nil)
        {
            CGSize size=[_order.film.filmName sizeWithFont:LSFont18 constrainedToSize:basicSize lineBreakMode:NSLineBreakByClipping];
            _contentY+=(size.height+5);
        }
        
        if (_order.cinema.cinemaName!=nil)
        {
            _contentY+=basicHeight;
        }
        
        if (_order.schedule)
        {
            _contentY+=basicHeight;
        }
        
        if (_order.schedule)
        {
            _contentY+=basicHeight;
        }
        
        if (_order.selectSeatArray)
        {
            _contentY+=basicHeight;
            
            NSString* text=@"";
            for(LSSeat* seat in _order.selectSeatArray)
            {
                text=[text stringByAppendingString:[NSString stringWithFormat:@"%@排%@座 ",seat.realRowID,seat.realColumnID]];
            }
            
            CGSize size=[text sizeWithFont:basicFont constrainedToSize:basicSize lineBreakMode:NSLineBreakByWordWrapping];
            
            if(size.height>basicHeight)
            {
                _contentY+=(size.height+5);
            }
            else
            {
                _contentY+=basicHeight;
            }
        }
        
        if(_order.totalPrice)
        {
            _contentY+=3;
            _contentY+=basicHeight;
        }
        
        _contentY+=15;
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}

- (void)dealloc
{
    self.order=nil;
    [super dealloc];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    //
    //具有的宽度将会为265
    //
    
    _contentY = 10;
    
    [[UIImage lsImageNamed:@"corder_bg_t.png"] drawInRect:CGRectMake(0, 0, rect.size.width, 7)];
    [[UIImage lsImageNamed:@"corder_bg.png"] drawAsPatternInRect:CGRectMake(0, 7, rect.size.width, rect.size.height-7-10)];
    [[UIImage lsImageNamed:@"corder_bg_b.png"] drawInRect:CGRectMake(0, rect.size.height-7-10, rect.size.width, 10)];
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);
    if (_order.film.filmName!=nil)
    {
        CGSize size=[_order.film.filmName sizeWithFont:LSFont18 constrainedToSize:basicSize lineBreakMode:NSLineBreakByClipping];
        [_order.film.filmName drawInRect:CGRectMake(gapL, _contentY, basicWidth, size.height) withFont:LSFont18 lineBreakMode:NSLineBreakByTruncatingTail];
        _contentY+=(size.height+5);
    }
    
    if (_order.cinema.cinemaName!=nil)
    {
        [_order.cinema.cinemaName drawInRect:CGRectMake(gapL, _contentY, basicWidth, basicHeight) withFont:basicFont lineBreakMode:NSLineBreakByTruncatingTail];
        _contentY+=basicHeight;
    }
    
    if (_order.schedule)
    {
        NSString* text=[NSString stringWithFormat:@"%@ %@ %@",_order.schedule.hall.hallName,_order.schedule.language,_order.schedule.isIMAX?@"数字":@""];
        [text drawInRect:CGRectMake(gapL, _contentY, basicWidth, basicHeight) withFont:basicFont lineBreakMode:NSLineBreakByClipping];
        _contentY+=basicHeight;
    }
    
    if (_order.schedule)
    {
        NSString* text=[NSString stringWithFormat:@"%@  %@",_order.schedule.startDate,_order.schedule.startTime];
        [text drawInRect:CGRectMake(gapL, _contentY, basicWidth, basicHeight) withFont:basicFont lineBreakMode:NSLineBreakByClipping];
        _contentY+=basicHeight;
    }
    
    if (_order.selectSeatArray)
    {
        NSString* text=[NSString stringWithFormat:@"已选座位: %d张",_order.selectSeatArray.count];
        [text drawInRect:CGRectMake(gapL, _contentY, basicWidth, basicHeight) withFont:basicFont lineBreakMode:NSLineBreakByClipping];
        _contentY+=basicHeight;
        
        text=@"";
        for(LSSeat* seat in _order.selectSeatArray)
        {
            text=[text stringByAppendingString:[NSString stringWithFormat:@"%@排%@座 ",seat.realRowID,seat.realColumnID]];
        }
        
        CGSize size=[text sizeWithFont:basicFont constrainedToSize:basicSize lineBreakMode:NSLineBreakByWordWrapping];
        
        if(size.height>basicHeight)
        {
            [text drawInRect:CGRectMake(gapL, _contentY, basicWidth, size.height) withFont:basicFont lineBreakMode:NSLineBreakByWordWrapping];
            _contentY+=(size.height+5);
        }
        else
        {
            [text drawInRect:CGRectMake(gapL, _contentY, basicWidth, basicHeight) withFont:basicFont lineBreakMode:NSLineBreakByWordWrapping];
            _contentY+=basicHeight;
        }
    }
    
    if(_order.totalPrice)
    {
        //为差号字做准备
        _contentY+=3;
        CGFloat contentX = gapL;
        
        NSString* text = @"应付金额: ";
        CGSize size=[text sizeWithFont:basicFont constrainedToSize:basicSize lineBreakMode:NSLineBreakByClipping];
        [text drawInRect:CGRectMake(contentX, _contentY, size.width, basicHeight) withFont:basicFont lineBreakMode:NSLineBreakByClipping];
        
        _contentY-=3;
        contentX+=size.width;
        
        CGContextSetFillColorWithColor(contextRef, LSColorBlackRedColor.CGColor);
        text = [[NSString stringWithFormat:@"￥%.2f", [_order.totalPrice floatValue]] stringByReplacingOccurrencesOfString:@".00" withString:@""];
        size=[text sizeWithFont:LSFont18 constrainedToSize:CGSizeMake(basicWidth-contentX, basicHeight+3) lineBreakMode:NSLineBreakByClipping];
        [text drawInRect:CGRectMake(contentX, _contentY, size.width, basicHeight+3) withFont:LSFont18 lineBreakMode:NSLineBreakByClipping];
        
        _contentY+=3;
        contentX+=size.width;
        
        CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);
        text = @" (含服务费)";
        size=[text sizeWithFont:basicFont constrainedToSize:basicSize lineBreakMode:NSLineBreakByClipping];
        [text drawInRect:CGRectMake(contentX, _contentY, size.width, basicHeight) withFont:basicFont lineBreakMode:NSLineBreakByClipping];
        
        _contentY+=basicHeight;
    }
    
    _contentY+=15;
}


@end
