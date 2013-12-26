//
//  LSSeatsInfoView.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-16.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSSeatsInfoView.h"
#import "LSSeat.h"

#define gap 10.f

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
        self.backgroundColor=LSColorTabBlack;
        
        _confirmButtonView=[[LSConfirmButtonView alloc] initWithFrame:CGRectZero];
        _confirmButtonView.delegate=self;
        [self addSubview:_confirmButtonView];
        [_confirmButtonView release];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _confirmButtonView.frame=CGRectMake(190.f, gap, 120.f, self.height-gap*2);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    NSString* text=@"";
    //绘制座位信息
    for(NSArray* selectSeatArray in [_order.selectSeatArrayDic allValues])
    {
        for(LSSeat* seat in selectSeatArray)
        {
            text=[text stringByAppendingString:[NSString stringWithFormat:@"%@排%@ ",seat.realRowID,seat.realColumnID]];
        }
    }
    
    if ([text isEqualToString:@""])
    {
        text = [NSString stringWithFormat:@"最多可选%d个座位",_order.maxTicketNumber];
    }
    
    [text drawInRect:CGRectMake(gap, gap, 180.f, self.height-gap*2) withAttributes:[LSAttribute attributeFont:LSFontSeatSelect color:LSColorWhite]];
    
    _confirmButtonView.price=_order.totalPrice;
    [_confirmButtonView setNeedsDisplay];
}

#pragma mark- 私有方法
- (void)LSConfirmButtonViewDidClick
{
    [_delegate LSSeatsInfoView:self didClickConfirmButtonView:_confirmButtonView];
}

@end
