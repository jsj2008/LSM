//
//  LSCreateOrderView.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-26.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSCreateOrderView.h"
#import "LSSeat.h"

#define gap 20.f

@implementation LSCreateOrderView

@synthesize order=_order;
@synthesize contentY=_contentY;

#pragma mark- 生存周期
- (void)dealloc
{
    self.order=nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [[UIImage stretchableImageWithImageName:@"" top:0.f left:0.f bottom:0.f right:0.f] drawInRect:CGRectZero];
    [[UIImage stretchableImageWithImageName:@"" top:0.f left:0.f bottom:0.f right:0.f] drawInRect:CGRectZero];
    
    _contentY=30.f;
    CGFloat contentX=gap;
    CGFloat basicWith=rect.size.width-gap*2-20.f;
    NSString* text=nil;
    
    //影片
    [[UIImage lsImageNamed:@""] drawInRect:CGRectMake(contentX, _contentY+10.f, 20.f, 20.f)];
    text=_order.film.filmName;
    CGRect nameRect= [text boundingRectWithSize:CGSizeMake(basicWith, INT32_MAX) options:NSStringDrawingTruncatesLastVisibleLine attributes:[LSAttribute attributeFont:LSFontCreateOrderFilm] context:nil];
    [text drawInRect:CGRectMake(contentX+20.f, _contentY, nameRect.size.width, 30.f) withAttributes:[LSAttribute attributeFont:LSFontCreateOrderFilm]];
    contentX+=(20.f+nameRect.size.width+10.f);
    
    if(_order.schedule.dimensional==LSFilmDimensional2D)
    {
        text=[NSString stringWithFormat:@"%@ 2D",_order.schedule.language];
    }
    else if(_order.schedule.dimensional==LSFilmDimensional3D)
    {
        text=[NSString stringWithFormat:@"%@ 3D",_order.schedule.language];
    }
    else
    {
        text=[NSString stringWithFormat:@"%@",_order.schedule.language];
    }
    [text drawInRect:CGRectMake(contentX, _contentY+10.f, rect.size.width-contentX-gap, 20.f) withAttributes:[LSAttribute attributeFont:LSFontCreateOrderTitle]];
    
    _contentY+=30.f;
    
    contentX=gap;
    
    //影厅
    [[UIImage lsImageNamed:@""] drawInRect:CGRectMake(contentX, _contentY, 20.f, 20.f)];
    text=[NSString stringWithFormat:@"%@ %@",_order.cinema.cinemaName,_order.schedule.hall.hallName];
    [text drawInRect:CGRectMake(contentX+20.f, _contentY, basicWith, 20.f) withAttributes:[LSAttribute attributeFont:LSFontCreateOrderTitle]];
    
    _contentY+=20.f;
    
    //时间
    [[UIImage lsImageNamed:@""] drawInRect:CGRectMake(contentX, _contentY, 20.f, 20.f)];
    text=[NSString stringWithFormat:@"%@ %@",_order.schedule.startDate,_order.schedule.startTime];
    [text drawInRect:CGRectMake(contentX+20.f, _contentY, basicWith, 20.f) withAttributes:[LSAttribute attributeFont:LSFontCreateOrderTitle]];
    
    _contentY+=20.f;
    
    //座位
    int totalNumber=0;
    for(NSArray* selectSeatArray in [_order.selectSeatArrayDic allValues])
    {
        totalNumber+=selectSeatArray.count;
    }
    [[UIImage lsImageNamed:@""] drawInRect:CGRectMake(contentX, _contentY, 20.f, 20.f)];
    text=[NSString stringWithFormat:@"已选座位%d张",totalNumber];
    [text drawInRect:CGRectMake(contentX+20.f, _contentY, basicWith, 20.f) withAttributes:[LSAttribute attributeFont:LSFontCreateOrderTitle]];
    
    _contentY+=20.f;
    
    for(NSArray* selectSeatArray in [_order.selectSeatArrayDic allValues])
    {
        text=@"";
        for(LSSeat* seat in selectSeatArray)
        {
            text=[text stringByAppendingString:[NSString stringWithFormat:@"%@排%@座|",seat.realRowID,seat.realColumnID]];
        }
        [text drawInRect:CGRectMake(contentX+20.f, _contentY, basicWith, 15.f) withAttributes:[LSAttribute attributeFont:LSFontCreateOrderSubtitle]];
        
        _contentY+=15.f;
    }
    
    //总价
    [[UIImage lsImageNamed:@""] drawInRect:CGRectMake(contentX, _contentY, 20.f, 20.f)];
    
    text=[NSString stringWithFormat:@"￥%@",_order.totalPrice];
    CGRect priceRect= [text boundingRectWithSize:CGSizeMake(basicWith, INT32_MAX) options:NSStringDrawingTruncatesLastVisibleLine attributes:[LSAttribute attributeFont:LSFontCreateOrderTitle] context:nil];
    [text drawInRect:CGRectMake(contentX+20.f, _contentY, priceRect.size.width, 20.f) withAttributes:[LSAttribute attributeFont:LSFontCreateOrderTitle color:LSColorTextRed]];
    contentX+=(20.f+priceRect.size.width+10.f);
    
    text=@"(含服务费)";
    [text drawInRect:CGRectMake(contentX, _contentY, rect.size.width-contentX-gap, 20.f) withAttributes:[LSAttribute attributeFont:LSFontCreateOrderTitle]];
    
    _contentY+=20.f;
    
    _contentY+=20.f;
}

@end
