//
//  LSBindFooterView.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-18.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSBindFooterView.h"

@implementation LSBindFooterView

@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _bindButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _bindButton.layer.cornerRadius=3.f;
        _bindButton.backgroundColor=LSColorButtonNormalRed;
        _bindButton.titleLabel.font=LSFont14;
        [_bindButton setTitle:@"验证" forState:UIControlStateNormal];
        [_bindButton addTarget:self action:@selector(bindButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_bindButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _bindButton.frame=CGRectInset(self.frame, 10.f, 20.f);
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
- (void)bindButtonClick:(UIButton*)sender
{
    [_delegate LSBindFooterView:self didClickBindButton:sender];
}

@end
