//
//  LSSeatsInfoView.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-16.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSSeatsInfoView.h"
#import "LSSeat.h"

#define gapL 20.f
#define basicWidth 200.f
#define basicSize CGSizeMake(basicWidth, INT32_MAX)

@implementation LSSeatsInfoView

@synthesize order=_order;
@synthesize delegate=_delegate;

#pragma mark- 生命周期
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
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        
        _sectionButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _sectionButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        _sectionButton.titleLabel.font = LSFontBold16;
        [_sectionButton addTarget:self action:@selector(sectionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_sectionButton];
        
        _confirmButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.frame = CGRectMake(240.f, 20.f, 60.f, 37.f);
        _confirmButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        _confirmButton.titleLabel.font = LSFontBold14;
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmButton setBackgroundImage:[UIImage stretchableImageWithImage:[UIImage lsImageNamed:@"seat_confirm.png"] top:16 left:6 bottom:16 right:6] forState:UIControlStateNormal];
        [_confirmButton setBackgroundImage:[UIImage stretchableImageWithImage:[UIImage lsImageNamed:@"seat_confirm_d.png"] top:16 left:6 bottom:16 right:6] forState:UIControlStateHighlighted];
        [_confirmButton setTitle:@"确 定" forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_confirmButton];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    [[UIImage lsImageNamed:@"seat_info_bg.png"] drawInRect:CGRectMake(12, 14, 295, 80)];
    [[UIImage lsImageNamed:@"seat_line.png"] drawInRect:CGRectMake(12, (self.height -6), 295, 1)];
    
    CGFloat contentY=16.f;
    CGFloat contentX=gapL;
    CGContextRef contextRef = UIGraphicsGetCurrentContext();

    CGSize size;
    //绘制开始日期
    if (_order.schedule.startDate)
    {
        CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);
        size=[_order.schedule.startDate sizeWithFont:LSFont16];
        [_order.schedule.startDate drawInRect:CGRectMake(contentX, contentY, size.width, size.height) withFont:LSFont16];
        contentX+=(size.width+20.f);
    }
    
    //绘制开始时间
    if (_order.schedule.startTime)
    {
        CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);
        size=[_order.schedule.startTime sizeWithFont:LSFont16];
        [_order.schedule.startTime drawInRect:CGRectMake(contentX, contentY, size.width, size.height) withFont:LSFont16];
        contentX+=(size.width+10.f);
    }
    
    //绘制总价
    if (_order.totalPrice)
    {
        NSString* text = nil;
        CGContextSetFillColorWithColor(contextRef, LSColorBlackRedColor.CGColor);
        text = @"￥";
        CGSize size=[text sizeWithFont:LSFont15];
        [text drawInRect:CGRectMake(contentX, contentY+2.f, size.width, size.height) withFont:LSFont15];
        contentX+=size.width;
        
        text=[[NSString stringWithFormat:@"%.2f",[_order.totalPrice floatValue]] stringByReplacingOccurrencesOfString:@".00" withString:@""];
        size=[text sizeWithFont:LSFont17];
        [text drawInRect:CGRectMake(contentX, contentY, size.width, size.height) withFont:LSFont17];
    }
    
    contentY+=(size.height+5.f);
    contentX=gapL;
    
    CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);
    //绘制座位提示
    NSString* text=@"已选座位：";
    size=[text sizeWithFont:LSFont16];
    [text drawInRect:CGRectMake(contentX, contentY, size.width, size.height) withFont:LSFont16];
    contentX+=size.width;

    if(_order.section!=nil)
    {
        //显示区域名称
        CGSize size=[_order.section.sectionName sizeWithFont:LSFont16];
        _sectionButton.frame = CGRectMake(contentX, contentY-2.f, size.width+24.f, size.height+4.f);
        contentX+=size.width;
        if(_order.sectionArray.count==1)
        {
            [_sectionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _sectionButton.enabled=NO;
        }
        else
        {
            [_sectionButton setTitleColor:LSColorBlackRedColor forState:UIControlStateNormal];
            [_sectionButton setBackgroundImage:[UIImage stretchableImageWithImage:[UIImage lsImageNamed:@"seat_sections.png"] top:25 left:5 bottom:25 right:15] forState:UIControlStateNormal];
            [_sectionButton setBackgroundImage:[UIImage stretchableImageWithImage:[UIImage lsImageNamed:@"seat_sections_d.png"] top:25 left:5 bottom:25 right:15] forState:UIControlStateHighlighted];
        }
        [_sectionButton setTitle:_order.section.sectionName forState:UIControlStateNormal];
        //这里可以画一个三角标识
    }
    
    contentY+=(size.height+5.f);
    contentX=gapL;
    
    CGContextSetFillColorWithColor(contextRef, [UIColor lightGrayColor].CGColor);
    //绘制座位信息
    if (_order.selectSeatArray.count>0)
    {
        text=@"";
        for(LSSeat* seat in _order.selectSeatArray)
        {
            text=[text stringByAppendingString:[NSString stringWithFormat:@"%@排%@座 ",seat.realRowID,seat.realColumnID]];
        }
        [text drawInRect:CGRectMake(contentX, contentY, 300.f, 16.f) withFont:LSFont13 lineBreakMode:NSLineBreakByClipping];
    }
    else
    {
        text = [NSString stringWithFormat:@"最多可选%d个座位",_order.section.maxTicketNumber];
        [text drawInRect:CGRectMake(contentX, contentY, 300.f, 16.f) withFont:LSFont13 lineBreakMode:NSLineBreakByClipping];
    }
}

#pragma mark- 按钮点击方法
- (void)sectionButtonClick:(UIButton*)sender
{
    if([_delegate respondsToSelector:@selector(LSSeatsInfoView: didClickSectionButton:)])
    {
        [_delegate LSSeatsInfoView:self didClickSectionButton:sender];
    }
}
- (void)confirmButtonClick:(UIButton*)sender
{
    if([_delegate respondsToSelector:@selector(LSSeatsInfoView: didClickConfirmButton:)])
    {
        [_delegate LSSeatsInfoView:self didClickConfirmButton:sender];
    }
}

@end
