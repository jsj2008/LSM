//
//  LSCreateOrderFooterView.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-25.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSCreateOrderFooterView.h"

#define gap 10.f

@implementation LSCreateOrderFooterView

@synthesize phoneTextField=_phoneTextField;
@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _phoneTextField=[[UITextField alloc] initWithFrame:CGRectZero];
        _phoneTextField.layer.cornerRadius=3.f;
        _phoneTextField.backgroundColor=LSColorWhite;
        _phoneTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
        _phoneTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _phoneTextField.placeholder=@"输入接收订座凭证的手机号";
        _phoneTextField.keyboardType=UIKeyboardTypeNumberPad;
        [self addSubview:_phoneTextField];
        [_phoneTextField release];
        
        _submitButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _submitButton.layer.cornerRadius=3.f;
        _submitButton.backgroundColor=LSColorButtonNormalRed;
        _submitButton.titleLabel.font=LSFontButton;
        [_submitButton setTitle:@"提交订单" forState:UIControlStateNormal];
        [_submitButton addTarget:self action:@selector(submitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_submitButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _phoneTextField.frame=CGRectMake(gap, gap, self.width-gap*2, 44.f);
    _submitButton.frame=CGRectMake(gap, gap+44.f+gap*2, self.width-gap*2, 44.f);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)submitButtonClick:(UIButton*)sender
{
    [_delegate LSCreateOrderFooterView:self didClickSubmitButton:sender];
}
@end
