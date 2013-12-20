//
//  LSPayFooterView.m
//  LaShouMovie
//
//  Created by Li XiangYu on 13-11-27.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSPayFooterView.h"

@implementation LSPayFooterView

@synthesize order=_order;
@synthesize delegate=_delegate;

- (void)dealloc
{
    self.order=nil;
    [self stopCountDown];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _countDownView=[[LSCountDownView alloc] initWithFrame:CGRectMake((self.width-265.f)/2, 15.f, 265.f, 30.f)];
        _countDownView.delegate=self;
        [self addSubview:_countDownView];
        [_countDownView release];
        
        UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake((self.width-265.f)/2, 15.f+30.f, 265.f, 30.f)];
        label.textAlignment=NSTextAlignmentCenter;
        label.textColor=[UIColor grayColor];
        label.font=LSFont15;
        label.text=@"(有效支付时间为15分钟)";
        [self addSubview:label];
        [label release];

        _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _payButton.frame = CGRectMake((self.width-265.f)/2, 15.f+30.f+30.f, 265.f, 44.f);
        [_payButton setBackgroundImage:[UIImage stretchableImageWithImage:[UIImage lsImageNamed:@"corder_confirm.png"] top:23 left:4 bottom:23 right:4] forState:UIControlStateNormal];
        [_payButton setBackgroundImage:[UIImage stretchableImageWithImage:[UIImage lsImageNamed:@"corder_confirm_d.png"] top:23 left:4 bottom:23 right:4] forState:UIControlStateHighlighted];
        _payButton.titleLabel.font = LSFontBold18;
        [_payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_payButton addTarget:self action:@selector(payButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_payButton];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)layoutSubviews
{
    [super layoutSubviews];
    _countDownView.minute=[_order expireSecond]/60;
    _countDownView.second=[_order expireSecond]%60;
    [_countDownView startCountDown];
    
    if(_order.needPay==0.f)
    {
        _payButton.tag=LSPayTypeBalance;
        [_payButton setTitle:@"确认付款" forState:UIControlStateNormal];
    }
    else
    {
        _payButton.tag=LSPayTypeAlipay;
        [_payButton setTitle:@"支付宝付款" forState:UIControlStateNormal];
    }
}

#pragma mark- 私有方法
- (void)stopCountDown
{
    [_countDownView stopCountDown];
}

- (void)resetCountDown
{
    _countDownView.minute=[_order expireSecond]/60;
    _countDownView.second=[_order expireSecond]%60;
}

- (void)payButtonClick:(UIButton*)sender
{
    if([_delegate respondsToSelector:@selector(LSPayFooterViewDidToPayByPayType:)])
    {
        [_delegate LSPayFooterViewDidToPayByPayType:sender.tag];
    }
}

#pragma mark- LSCountDownView的委托方法
- (void)LSCountDownViewDidTimeout
{
    if([_delegate respondsToSelector:@selector(LSPayFooterViewDidTimeOut)])
    {
        [_delegate LSPayFooterViewDidTimeOut];
    }
}

@end
