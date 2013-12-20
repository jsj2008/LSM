//
//  LSPaidOrderCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-29.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSPaidOrderCell.h"
#import "LSSeat.h"

#define gapL 45.f
#define basicWidth 200.f
#define basicHeight 23.f
#define basicSize CGSizeMake(basicWidth, INT32_MAX)

@implementation LSPaidOrderCell

@synthesize order=_order;
@synthesize delegate=_delegate;

+ (CGFloat)heightOfOrder:(LSOrder*)order
{
    CGFloat contentY = 33.f;
    
    if (order.film.filmName!=nil)
    {
        CGSize size=[order.film.filmName sizeWithFont:LSFont18 constrainedToSize:basicSize lineBreakMode:NSLineBreakByClipping];
        contentY+=(size.height+5);
    }
    
    if (order.cinema.cinemaName!=nil)
    {
        contentY+=basicHeight;
    }
    
    if(order.totalPrice!=nil)
    {
        contentY+=basicHeight;
    }
    
    if (order.schedule.hall.hallName!=nil)
    {
        contentY+=basicHeight;
    }
    
    if(order.schedule.startTime!=nil)
    {
        contentY+=basicHeight;
    }
    
    if (order.section.seatArray)
    {
        contentY+=basicHeight;
        
        NSString* text=@"";
        for(LSSeat* seat in order.section.seatArray)
        {
            text=[text stringByAppendingString:[NSString stringWithFormat:@"%@排%@座 ",seat.realRowID,seat.realColumnID]];
        }
        
        CGSize size=[text sizeWithFont:LSFont15 constrainedToSize:basicSize lineBreakMode:NSLineBreakByWordWrapping];
        if(size.height>basicHeight)
        {
            contentY+=(size.height+5);
        }
        else
        {
            contentY+=basicHeight;
        }
    }
    
    NSString* text=nil;
    if(0)
    {
        text=[NSString stringWithFormat:@"取票码: %@",order.message];
    }
    else
    {
        text=[NSString stringWithFormat:@"取票码: %@",order.message];
    }
    CGSize size=[text sizeWithFont:LSFont15 constrainedToSize:basicSize lineBreakMode:NSLineBreakByCharWrapping];
    if(size.height>basicHeight)
    {
        contentY+=(size.height+5);
    }
    else
    {
        contentY+=basicHeight;
    }
    
    contentY+=15;
    
    return contentY;
}

#pragma mark- 生命周期
- (void)dealloc
{
    self.order=nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.clipsToBounds = YES;
        self.backgroundColor=[UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        _mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _mapButton.frame = CGRectZero;
        [_mapButton setBackgroundImage:[UIImage lsImageNamed:@"cinema_info_map.png"] forState:UIControlStateNormal];
        [_mapButton setBackgroundImage:[UIImage lsImageNamed:@"cinema_info_map_d.png"] forState:UIControlStateHighlighted];
        [_mapButton addTarget:self action:@selector(mapButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_mapButton];
        
        
        _phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _phoneButton.frame = CGRectZero;
        [_phoneButton setBackgroundImage:[UIImage lsImageNamed:@"cinema_info_phone.png"] forState:UIControlStateNormal];
        [_phoneButton setBackgroundImage:[UIImage lsImageNamed:@"cinema_info_phone_d.png"] forState:UIControlStateHighlighted];
        [_phoneButton addTarget:self action:@selector(phoneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_phoneButton];
        
        
//        UIButton* cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        cancelButton.frame = CGRectZero;
//        [cancelButton setBackgroundImage:[UIImage lsImageNamed:@"o_cancel.png"] forState:UIControlStateNormal];
//        [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        cancelButton.titleLabel.font = LSFontBold18;
//        [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self.contentView addSubview:cancelButton];
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
    _mapButton.frame=CGRectMake(gapL+basicWidth+5,self.height/2-10-35, 45, 35);
    _phoneButton.frame=CGRectMake(gapL+basicWidth+5,self.height/2+10, 45, 35);
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(contextRef, LSRGBA(160, 179, 190, 1.f).CGColor);
    CGContextSetFillColorWithColor(contextRef, LSRGBA(160, 179, 190, 1.f).CGColor);
	
    CGContextSetAllowsAntialiasing(contextRef,true);
    CGContextSetLineWidth(contextRef, 1.f);
    
    CGFloat x=15.f;
    CGFloat y=10.f;
    
	CGContextMoveToPoint(contextRef, x, y+4);
	CGContextAddArcToPoint(contextRef, x, y, x+4, y, 4.f);
	CGContextAddArcToPoint(contextRef, x+8, y, x+8, y+4, 4.f);
	CGContextAddArcToPoint(contextRef, x+8, y+8, x+4, y+8, 4.f);
	CGContextAddArcToPoint(contextRef, x, y+8, x, y+4, 4.f);
	CGContextClosePath(contextRef);
	CGContextDrawPath(contextRef, kCGPathFillStroke);
    
    
    CGContextMoveToPoint(contextRef, x+4.f, y+10.f);
    CGContextAddLineToPoint(contextRef, x+4.f, rect.size.height);
    CGContextDrawPath(contextRef, kCGPathFillStroke);
    
    CGContextMoveToPoint(contextRef, x+11.f, y+4.f);
    CGContextAddLineToPoint(contextRef, x+15.f, y+1.f);
    
    CGContextAddArcToPoint(contextRef, x+15.f, y-2.f, x+70.f, y-2.f, 1.f);
    CGContextAddArcToPoint(contextRef, x+120.f, y-2.f, x+120.f, y+4.f, 1.f);
    CGContextAddArcToPoint(contextRef, x+120.f, y+10.f, x+70.f, y+10.f, 1.f);
    CGContextAddArcToPoint(contextRef, x+15.f, y+10.f, x+15.f, y+7.f, 1.f);
    CGContextAddLineToPoint(contextRef, x+15.f, y+7.f);
    
    CGContextClosePath(contextRef);
    CGContextDrawPath(contextRef, kCGPathFillStroke);
    
    if(_order.orderTime!=nil)
    {
        CGContextSetFillColorWithColor(contextRef, [UIColor whiteColor].CGColor);
        [[_order.orderTime stringValueByFormatter:@"yyyy-MM-dd HH:mm"] drawInRect:CGRectMake(gapL-5, 8.f, 200.f, 14.f) withFont:LSFont11];
    }
    
    [[UIImage lsImageNamed:@"o_bg_t.png"] drawInRect:CGRectMake(0, 24, 320, 7)];
    [[UIImage lsImageNamed:@"o_bg_m.png"] drawAsPatternInRect:CGRectMake(0, 31, 320, rect.size.height-23-17)];
    [[UIImage lsImageNamed:@"o_bg_b.png"] drawInRect:CGRectMake(0, rect.size.height-17-5, 320, 17)];
    
    CGFloat contentY = 33.f;
    
    CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);
    
    if (_order.film.filmName!=nil)
    {
        CGSize size=[_order.film.filmName sizeWithFont:LSFont18 constrainedToSize:basicSize lineBreakMode:NSLineBreakByClipping];
        [_order.film.filmName drawInRect:CGRectMake(gapL, contentY, basicWidth, size.height) withFont:LSFont18 lineBreakMode:NSLineBreakByTruncatingTail];
        contentY+=(size.height+5);
    }
    
    if (_order.cinema.cinemaName!=nil)
    {
        [_order.cinema.cinemaName drawInRect:CGRectMake(gapL, contentY, basicWidth, basicHeight) withFont:LSFont15 lineBreakMode:NSLineBreakByTruncatingTail];
        contentY+=basicHeight;
    }
    
    if(_order.totalPrice!=nil)
    {
        NSString* text = [[NSString stringWithFormat:@"应付金额: ￥%.2f (含服务费)", [_order.totalPrice floatValue]] stringByReplacingOccurrencesOfString:@".00" withString:@""];
        [text drawInRect:CGRectMake(gapL, contentY, basicWidth, basicHeight) withFont:LSFont15 lineBreakMode:NSLineBreakByClipping];
        contentY+=basicHeight;
    }
    
    if (_order.schedule.hall.hallName!=nil)
    {
        NSString* text = [NSString stringWithFormat:@"%@ %@ %@ %@",_order.schedule.hall.hallName , _order.schedule.language,(_order.schedule.isIMAX ? @"IMAX" : @""),(_order.schedule.dimensional == LSFilmDimensional3D ? @"3D" : @"")];
        [text drawInRect:CGRectMake(gapL, contentY, basicWidth, basicHeight) withFont:LSFont15 lineBreakMode:NSLineBreakByClipping];
        contentY+=basicHeight;
    }
    
    if(_order.schedule.startDate!=nil && _order.schedule.startTime!=nil)
    {
        NSString* text=[NSString stringWithFormat:@"场次: %@ %@", _order.schedule.startDate, _order.schedule.startTime];
        [text drawInRect:CGRectMake(gapL, contentY, basicWidth, basicHeight) withFont:LSFont15 lineBreakMode:NSLineBreakByClipping];
        contentY+=basicHeight;
    }
    
    
    if (_order.section.seatArray!=nil)
    {
        NSString* text=[NSString stringWithFormat:@"已选座位: %d张",_order.section.seatArray.count];
        [text drawInRect:CGRectMake(gapL, contentY, basicWidth, basicHeight) withFont:LSFont15 lineBreakMode:NSLineBreakByClipping];
        contentY+=basicHeight;
        
        text=@"";
        for(LSSeat* seat in _order.section.seatArray)
        {
            text=[text stringByAppendingString:[NSString stringWithFormat:@"%@排%@座 ",seat.realRowID,seat.realColumnID]];
        }
        
        CGSize size=[text sizeWithFont:LSFont15 constrainedToSize:basicSize lineBreakMode:NSLineBreakByWordWrapping];
        if(size.height>basicHeight)
        {
            [text drawInRect:CGRectMake(gapL, contentY, basicWidth, size.height) withFont:LSFont15 lineBreakMode:NSLineBreakByWordWrapping];
            contentY+=(size.height+5);
        }
        else
        {
            [text drawInRect:CGRectMake(gapL, contentY, basicWidth, basicHeight) withFont:LSFont15 lineBreakMode:NSLineBreakByWordWrapping];
            contentY+=basicHeight;
        }
    }
    
    if(_order.message!=nil)
    {
        NSString* text=nil;
        if(0)
        {
            text=[NSString stringWithFormat:@"取票码: %@",_order.message];
        }
        else
        {
            text=[NSString stringWithFormat:@"取票码: %@",_order.message];
        }
        CGSize size=[text sizeWithFont:LSFont15 constrainedToSize:basicSize lineBreakMode:NSLineBreakByCharWrapping];
        if(size.height>basicHeight)
        {
            [text drawInRect:CGRectMake(gapL, contentY, basicWidth, size.height) withFont:LSFont15 lineBreakMode:NSLineBreakByCharWrapping];
            contentY+=(size.height+5);
        }
        else
        {
            [text drawInRect:CGRectMake(gapL, contentY, basicWidth, basicHeight) withFont:LSFont15 lineBreakMode:NSLineBreakByCharWrapping];
            contentY+=basicHeight;
        }
    }
    
    contentY+=10;
    
//    CGContextSetStrokeColorWithColor(contextRef, [UIColor lightGrayColor].CGColor);
//    CGContextSetLineWidth(contextRef, 1.0);
//    CGFloat dashArray[] = {2,2};
//    CGContextSetLineDash(contextRef, 8, dashArray, 2);
//    CGContextMoveToPoint(contextRef, gapL, _contentY);
//    CGContextAddLineToPoint(contextRef, basicWidth,_contentY);
//    CGContextStrokePath(contextRef);
}

#pragma mark- 按钮的单击方法
- (void)mapButtonClick:(UIButton*)sender
{
    if([_delegate respondsToSelector:@selector(LSPaidOrderCell: didClickMapButtonForOrder:)])
    {
        [_delegate LSPaidOrderCell:self didClickMapButtonForOrder:_order];
    }
}

- (void)phoneButtonClick:(UIButton*)sender
{
    if([_delegate respondsToSelector:@selector(LSPaidOrderCell: didClickPhoneButtonForOrder:)])
    {
        [_delegate LSPaidOrderCell:self didClickPhoneButtonForOrder:_order];
    }
}

- (void)cancelButton:(UIButton*)sender
{
    
}

@end
