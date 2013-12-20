//
//  LSRegisterFooterView.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-18.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSRegisterFooterView.h"

@implementation LSRegisterFooterView

@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _registerButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _registerButton.layer.cornerRadius=3.f;
        _registerButton.backgroundColor=LSColorButtonNormalRed;
        _registerButton.titleLabel.font=LSFont14;
        [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
        [_registerButton addTarget:self action:@selector(registerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_registerButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _registerButton.frame=CGRectInset(self.frame, 10.f, 20.f);
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

#pragma mark- 私有方法
- (void)registerButtonClick:(UIButton*)sender
{
    [_delegate LSRegisterFooterView:self didClickRegisterButton:sender];
}

@end
