//
//  LSBindPhoneCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-18.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSBindPhoneCell.h"

@implementation LSBindPhoneCell

@synthesize placeholder=_placeholder;
@synthesize imageName=_imageName;
@synthesize textField=_textField;
@synthesize delegate=_delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _textField=[[UITextField alloc] initWithFrame:CGRectZero];
        _textField.textColor = [UIColor blackColor];
        _textField.clearButtonMode=UITextFieldViewModeWhileEditing;
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textField.keyboardType=UIKeyboardTypeNumberPad;
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.delegate=self;
        [self addSubview:_textField];
        [_textField release];
        
        _label=[[UILabel alloc] initWithFrame:CGRectZero];
        _label.textColor=LSColorTextRed;
        _label.textAlignment=NSTextAlignmentRight;
        _label.text=@"发送验证码";
        [self addSubview:_label];
        [_label release];
        
        UITapGestureRecognizer* gestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTap:)];
        [_label addGestureRecognizer:gestureRecognizer];
        [gestureRecognizer release];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.image=[UIImage lsImageNamed:_imageName];
    
    NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:LSFont14, NSFontAttributeName, nil];
    CGSize size=[_label.text sizeWithFont:<#(UIFont *)#> constrainedToSize:<#(CGSize)#> lineBreakMode:<#(NSLineBreakMode)#>];
    
    _textField.frame=CGRectMake(60.f, 0.f, self.width-60.f-size.width-10.f, self.height);
    _textField.placeholder=_placeholder;
    
    _label.frame=CGRectMake(self.width-size.width-10.f, 0.f, size.width, self.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark- 私有方法
- (void)labelTap:(UITapGestureRecognizer*)recognizer
{
    if(_textField.text!=nil && _textField.text.length==11)
    {
        _label.text=@"重新获取";
        [_delegate LSBindPhoneCell:self didTapLabel:(UILabel*)(recognizer.view)];
    }
}

@end
