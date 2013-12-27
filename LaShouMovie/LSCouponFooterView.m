//
//  LSCouponFooterView.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-11-28.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSCouponFooterView.h"

@implementation LSCouponFooterView
@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _useButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _useButton.layer.cornerRadius=3.f;
        _useButton.backgroundColor=LSColorButtonNormalRed;
        _useButton.titleLabel.font=LSFontButton;
        [_useButton setTitleColor:LSColorWhite forState:UIControlStateNormal];
        [_useButton setTitle:@"确认使用" forState:UIControlStateNormal];
        [_useButton addTarget:self action:@selector(useButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_useButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _useButton.frame=CGRectInset(self.frame, 10.f, 20.f);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
 */

- (void)useButtonClick:(UIButton*)sender
{
    [_delegate LSCouponFooterView:self didClickUseButton:sender];
}

@end
