//
//  LSCouponHeaderView.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-27.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSUseCouponHeaderView.h"

@implementation LSUseCouponHeaderView

@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=LSColorNavigationRed;
        
        _couponTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _couponTextField.layer.cornerRadius=3.f;
        _couponTextField.backgroundColor=LSColorWhite;
        _couponTextField.placeholder = @"输入通兑券或代金券密码";
        _couponTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _couponTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _couponTextField.returnKeyType = UIReturnKeySend;
        _couponTextField.keyboardType = UIKeyboardTypeDefault;
        _couponTextField.delegate=self;
        [self addSubview:_couponTextField];
        [_couponTextField release];
        
        _addButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setTitleColor:LSColorWhite forState:UIControlStateNormal];
        _addButton.titleLabel.font = LSFontCouponAdd;
        [_addButton setTitle:@"添加" forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_addButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _couponTextField.frame=CGRectMake(10.f, 10.f, 240.f, self.height-10.f*2);
    _addButton.frame=CGRectMake(260.f, 10.f, 50.f, self.height-10.f*2);
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
- (void)useButtonClick:(UIButton*)sender
{
    if(_couponTextField.text!=nil)
    {
        [_delegate LSUseCouponHeaderView:self didClickAddButton:sender withCouponTextField:_couponTextField];
    }
}

#pragma mark- UITextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.text!=nil)
    {
        [_delegate LSUseCouponHeaderView:self didClickAddButton:_addButton withCouponTextField:textField];
    }
    return YES;
}

@end
