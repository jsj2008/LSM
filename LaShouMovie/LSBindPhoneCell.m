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
        _textField.clearButtonMode=UITextFieldViewModeWhileEditing;
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textField.keyboardType=UIKeyboardTypeNumberPad;
        _textField.returnKeyType = UIReturnKeyDone;
        [self addSubview:_textField];
        [_textField release];
        
        _sendButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setTitleColor:LSColorButtonNormalRed forState:UIControlStateNormal];
        [_sendButton setTitleColor:LSColorButtonHighlightedRed forState:UIControlStateNormal];
        _sendButton.titleLabel.textAlignment=NSTextAlignmentRight;
        [_sendButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        _sendButton.titleLabel.font=LSFontButton;
        [_sendButton addTarget:self action:@selector(sendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_sendButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.image=[UIImage lsImageNamed:_imageName];
    
    _textField.frame=CGRectMake(60.f, 0.f, self.width-60.f-54.f-10.f, self.height);
    _textField.placeholder=_placeholder;
    
    _sendButton.frame=CGRectMake(self.width-54.f-10.f, 0.f, 54.f, self.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark- 私有方法
- (void)sendButtonClick:(UIButton*)sender
{
    if(_textField.text!=nil && _textField.text.length==11)
    {
        [_sendButton setTitle:@"重新获取" forState:UIControlStateNormal];
        [_delegate LSBindPhoneCell:self didClickSendButton:_sendButton];
    }
}

@end
