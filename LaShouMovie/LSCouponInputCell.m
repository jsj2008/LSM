//
//  LSCouponInputCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-11-28.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSCouponInputCell.h"

#define gapL 10.f
#define basicWidth 280.f
#define basicSize CGSizeMake(basicWidth, INT32_MAX)

@implementation LSCouponInputCell

@synthesize delegate=_delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.clipsToBounds = YES;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor=[UIColor clearColor];
        
        _couponTextField = [[UITextField alloc] init];
        _couponTextField.delegate = self;
        _couponTextField.placeholder = @"通兑券或代金券密码";
        _couponTextField.textColor = [UIColor blackColor];
        _couponTextField.borderStyle = UITextBorderStyleNone;
        _couponTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _couponTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _couponTextField.returnKeyType = UIReturnKeySend;
        _couponTextField.keyboardType = UIKeyboardTypeDefault;
        [self addSubview:_couponTextField];
        [_couponTextField release];
        
        _useButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [_useButton setBackgroundImage:[UIImage stretchableImageWithImage:[UIImage lsImageNamed:@"btn_sub_nor.png"] top:24 left:6 bottom:24 right:6] forState:UIControlStateNormal];
        [_useButton setBackgroundImage:[UIImage stretchableImageWithImage:[UIImage lsImageNamed:@"btn_sub_sel.png"] top:24 left:6 bottom:24 right:6] forState:UIControlStateHighlighted];
        [_useButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _useButton.titleLabel.font = LSFont15;
        [_useButton setTitle:@"使用" forState:UIControlStateNormal];
        [_useButton addTarget:self action:@selector(useButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_useButton];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _couponTextField.frame=CGRectMake(gapL+5.f, gapL, 214.f, self.height-gapL*2);
    _useButton.frame=CGRectMake(self.width-gapL-66.f, gapL, 66.f, self.height-gapL*2);
}

- (void)drawRect:(CGRect)rect
{
    [self drawRoundRectangleInRect:CGRectMake(gapL, gapL, 224.f, self.height-gapL*2) topRadius:3.f bottomRadius:3.f isBottomLine:YES fillColor:LSColorBgWhiteColor strokeColor:LSColorLineGrayColor borderWidth:0.5];
}

#pragma mark- 私有方法
- (void)useButtonClick:(UIButton*)sender
{
    [_couponTextField resignFirstResponder];
    
    if(_couponTextField.text!=nil)
    {
        if([_delegate respondsToSelector:@selector(LSCouponInputCellDidUseCoupon:)])
        {
            [_delegate LSCouponInputCellDidUseCoupon:[_couponTextField.text lowercaseString]];
        }
    }
}

#pragma mark- UITextField的委托方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_couponTextField resignFirstResponder];
    
    if(textField.text!=nil)
    {
        if([_delegate respondsToSelector:@selector(LSCouponInputCellDidUseCoupon:)])
        {
            [_delegate LSCouponInputCellDidUseCoupon:[textField.text lowercaseString]];
        }
    }
    return YES;
}

@end
