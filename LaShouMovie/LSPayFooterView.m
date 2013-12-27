//
//  LSPayFooterView.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-27.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSPayFooterView.h"

@implementation LSPayFooterView

@synthesize title=_title;
@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _payButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _payButton.layer.cornerRadius=3.f;
        _payButton.backgroundColor=LSColorButtonNormalRed;
        _payButton.titleLabel.font=LSFontButton;
        [_payButton setTitleColor:LSColorWhite forState:UIControlStateNormal];
        [_payButton addTarget:self action:@selector(payButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_payButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _payButton.frame=CGRectInset(self.frame, 10.f, 20.f);
    [_payButton setTitle:_title forState:UIControlStateNormal];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)payButtonClick:(UIButton*)sender
{
    [_delegate LSPayFooterView:self didClickPayButton:sender];
}

@end
