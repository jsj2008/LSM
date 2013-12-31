//
//  LSSecurityCodeView.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-29.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSSecurityCodeView.h"

@implementation LSSecurityCodeView

@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
        self.backgroundColor = LSRGBA(0, 0, 0, .7f);
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        _codeTextField = [[UITextField alloc] initWithFrame:CGRectMake(50, 108, 220, 44)];
        _codeTextField.placeholder = @"验证码";
        _codeTextField.textColor = [UIColor blackColor];
        _codeTextField.borderStyle = UITextBorderStyleNone;
        _codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _codeTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _codeTextField.keyboardType = UIKeyboardTypeDefault;
        [self addSubview:_codeTextField];
        [_codeTextField release];
        [_codeTextField becomeFirstResponder];
        
        UIButton* cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(50, 165, 100, 44);
        cancelButton.backgroundColor = [UIColor clearColor];
        [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelButton setBackgroundImage:[UIImage stretchableImageWithImage:[UIImage lsImageNamed:@"corder_bind.png"] top:14 left:5 bottom:14 right:5] forState:UIControlStateNormal];
        [cancelButton setBackgroundImage:[UIImage stretchableImageWithImage:[UIImage lsImageNamed:@"corder_bind_d.png"] top:14 left:5 bottom:14 right:5] forState:UIControlStateHighlighted];
        cancelButton.titleLabel.font = LSFontBold15;
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelButton];
        
        UIButton* payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        payButton.frame = CGRectMake(170, 165, 100, 44);
        payButton.backgroundColor = [UIColor clearColor];
        [payButton setBackgroundImage:[UIImage stretchableImageWithImage:[UIImage lsImageNamed:@"nav_n.png"] top:15 left:11 bottom:15 right:11] forState:UIControlStateNormal];
        [payButton setBackgroundImage:[UIImage stretchableImageWithImage:[UIImage lsImageNamed:@"nav_n_d.png"] top:15 left:11 bottom:15 right:11] forState:UIControlStateHighlighted];
        [payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        payButton.titleLabel.font = LSFontBold15;
        [payButton setTitle:@"支付" forState:UIControlStateNormal];
        [payButton addTarget:self action:@selector(payButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:payButton];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);
    
    NSString* text = @"输入验证码";
    [text drawInRect:CGRectMake(40, 70, 240, 26) withFont:[UIFont boldSystemFontOfSize:21.f] lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
}


#pragma mark- 按钮点击方法
- (void)cancelButtonClick:(UIButton*)sender
{
    [_codeTextField resignFirstResponder];
    [self removeFromSuperview];
}

- (void)payButtonClick:(UIButton*)sender
{
    if(_codeTextField.text!=nil)
    {
        if([_delegate respondsToSelector:@selector(LSSecurityCodeView: didPayWithSecurityCode:)])
        {
            [_delegate LSSecurityCodeView:self didPayWithSecurityCode:_codeTextField.text];
        }
        
        [_codeTextField resignFirstResponder];
        [self removeFromSuperview];
    }
}

@end
