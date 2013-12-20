//
//  LSUnpayOrderCell.m
//  LaShouMovie
//
//  Created by Li XiangYu on 13-10-2.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSUnpayOrderCell.h"
#import "LSSeat.h"

#define gapL 45.f
#define basicWidth 200.f
#define basicHeight 23.f
#define basicSize CGSizeMake(basicWidth, INT32_MAX)

@implementation LSUnpayOrderCell

@synthesize order=_order;
@synthesize delegate=_delegate;

+ (CGFloat)heightOfOrder:(LSOrder*)order
{
    CGFloat contentY = 33;
    
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
    
    if(order.schedule.startDate!=nil && order.schedule.startTime!=nil)
    {
        contentY+=basicHeight;
    }
    
    if (order.selectSeatArray!=nil)
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
    
    contentY+=10;
    
    contentY+=44;
    contentY+=15;
    
    return contentY;
}

#pragma mark- 生命周期
- (void)dealloc
{
    self.order=nil;
    [_simpleCountDownView stopCountDown];
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
        
        
        _simpleCountDownView=[[LSSimpleCountDownView alloc] initWithFrame:CGRectZero];
        _simpleCountDownView.delegate=self;
        [self addSubview:_simpleCountDownView];
        [_simpleCountDownView release];
        
        
        _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _payButton.frame = CGRectZero;
        [_payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _payButton.titleLabel.font = LSFontBold18;
        [_payButton setTitle:@"立即付款" forState:UIControlStateNormal];
        [_payButton addTarget:self action:@selector(payButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_payButton];
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
    _simpleCountDownView.frame=CGRectMake(gapL+65,self.height-10-40, 55, 25);
    _payButton.frame=CGRectMake(gapL+130,self.height-10-49, 115, 40);
    
    [_simpleCountDownView stopCountDown];
    _simpleCountDownView.minute=[_order expireSecond]/60;
    _simpleCountDownView.second=[_order expireSecond]%60;
    [_simpleCountDownView startCountDown];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(contextRef, LSColorBlackRedColor.CGColor);
    CGContextSetFillColorWithColor(contextRef, LSColorBlackRedColor.CGColor);
	
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
    CGContextAddArcToPoint(contextRef, x+130.f, y-2.f, x+130.f, y+4.f, 1.f);
    CGContextAddArcToPoint(contextRef, x+130.f, y+10.f, x+70.f, y+10.f, 1.f);
    CGContextAddArcToPoint(contextRef, x+15.f, y+10.f, x+15.f, y+7.f, 1.f);
    CGContextAddLineToPoint(contextRef, x+15.f, y+7.f);
    
    CGContextClosePath(contextRef);
    CGContextDrawPath(contextRef, kCGPathFillStroke);
    
    if(_order.orderTime!=nil)
    {
        CGContextSetFillColorWithColor(contextRef, [UIColor whiteColor].CGColor);
        [[_order.orderTime stringValueByFormatter:@"yyyy-MM-dd HH:mm:ss"] drawInRect:CGRectMake(gapL-10, 8.f, 200.f, 14.f) withFont:LSFont11];
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
        NSString* text = [[NSString stringWithFormat:@"总价: ￥%.2f (含服务费)", [_order.originTotalPrice floatValue]] stringByReplacingOccurrencesOfString:@".00" withString:@""];
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
    
    if (_order.selectSeatArray!=nil)
    {
        NSString* text=[NSString stringWithFormat:@"已选座位: %d张",_order.selectSeatArray.count];
        [text drawInRect:CGRectMake(gapL, contentY, basicWidth, basicHeight) withFont:LSFont15 lineBreakMode:NSLineBreakByClipping];
        contentY+=basicHeight;
        
        text=@"";
        for(LSSeat* seat in _order.selectSeatArray)
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
    
    CGContextSetStrokeColorWithColor(contextRef, [UIColor lightGrayColor].CGColor);
    CGContextSetLineWidth(contextRef, 1.0);
    CGFloat dashArray[] = {2,2};
    CGContextSetLineDash(contextRef, 8, dashArray, 2);
    
    CGContextMoveToPoint(contextRef, gapL, contentY);
    CGContextAddLineToPoint(contextRef, gapL+245,contentY);
    CGContextStrokePath(contextRef);

    CGContextMoveToPoint(contextRef, gapL+basicWidth, 33);
    CGContextAddLineToPoint(contextRef, gapL+basicWidth, contentY);
    CGContextStrokePath(contextRef);
    
    contentY+=10;
    
    [[UIImage lsImageNamed:@"o_p.png"] drawInRect:CGRectMake(gapL, contentY, 245, 40)];
    [[UIImage lsImageNamed:@"o_time.png"] drawInRect:CGRectMake(gapL+50, contentY+12, 16, 16)];
    contentY+=44;
    
    contentY+=15;
}

#pragma mark- 按钮的单击方法
- (void)mapButtonClick:(UIButton*)sender
{
    if([_delegate respondsToSelector:@selector(LSUnpayOrderCell: didClickMapButtonForOrder:)])
    {
        [_delegate LSUnpayOrderCell:self didClickMapButtonForOrder:_order];
    }
}

- (void)phoneButtonClick:(UIButton*)sender
{
    if([_delegate respondsToSelector:@selector(LSUnpayOrderCell: didClickPhoneButtonForOrder:)])
    {
        [_delegate LSUnpayOrderCell:self didClickPhoneButtonForOrder:_order];
    }
}

- (void)payButtonClick:(UIButton*)sender
{
    if([_delegate respondsToSelector:@selector(LSUnpayOrderCell: didClickPayButtonForOrder:)])
    {
        [_delegate LSUnpayOrderCell:self didClickPayButtonForOrder:_order];
    }
}

#pragma mark- LSSimpleCountDownView的委托方法
- (void)LSSimpleCountDownViewDidTimeout
{
    if([_delegate respondsToSelector:@selector(LSUnpayOrderCell: didTimeoutForOrder:)])
    {
        [_delegate LSUnpayOrderCell:self didTimeoutForOrder:_order];
    }
}

@end
