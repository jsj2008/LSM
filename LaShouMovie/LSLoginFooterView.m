//
//  LSLoginFooterView.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-18.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSLoginFooterView.h"

@implementation LSLoginFooterView

@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _loginButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.layer.cornerRadius=3.f;
        _loginButton.backgroundColor=LSColorButtonNormalRed;
        _loginButton.titleLabel.font=LSFontButton;
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_loginButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _loginButton.frame=CGRectInset(self.frame, 10.f, 20.f);
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
- (void)loginButtonClick:(UIButton*)sender
{
    [_delegate LSLoginFooterView:self didClickLoginButton:sender];
}

@end
