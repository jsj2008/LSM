//
//  LSPaidWrongView.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-30.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSPaidWrongView.h"

@implementation LSPaidWrongView

@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _rebuyButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _rebuyButton.layer.cornerRadius=3.f;
        _rebuyButton.backgroundColor=LSColorButtonNormalRed;
        _rebuyButton.titleLabel.font=LSFontButton;
        [_rebuyButton setTitleColor:LSColorWhite forState:UIControlStateNormal];
        [_rebuyButton addTarget:self action:@selector(rebuyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rebuyButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _rebuyButton.frame=CGRectMake(10.f, 140.f, 300.f, 44.f);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [[UIImage lsImageNamed:@""] drawInRect:CGRectZero];
    
    CGFloat contentY=50.f;
    
    NSString* text=@"出票失败";
    [text drawInRect:CGRectMake(0.f, contentY, 320.f, 25.f) withAttributes:[LSAttribute attributeFont:LSFontPaidOrderInfoWrong textAlignment:NSTextAlignmentCenter]];
    
    text=[NSString stringWithFormat:@"非常抱歉，因一些特殊原因出票失败。\n您所付票款已经全额返还到你的支付账户，最迟三天到账。\n客服电话%@",lsServicePhoneReal];
    [text drawInRect:CGRectMake(0.f, contentY, 320.f, 55.f) withAttributes:[LSAttribute attributeFont:LSFontPaidOrderInfoSubtitle textAlignment:NSTextAlignmentCenter]];
}

#pragma mark- 私有方法
- (void)rebuyButtonClick:(UIButton*)sender
{
    [_delegate LSPaidWrongView:self didClickRebuyButton:sender];
}

@end
