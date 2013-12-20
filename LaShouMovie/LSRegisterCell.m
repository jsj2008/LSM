//
//  LSRegisterCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-18.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSRegisterCell.h"

@implementation LSRegisterCell

@synthesize placeholder=_placeholder;
@synthesize imageName=_imageName;
@synthesize textField=_textField;
@synthesize keyboardType=_keyboardType;

#pragma mark- 属性方法
- (void)setKeyboardType:(UIKeyboardType)keyboardType
{
    _keyboardType=keyboardType;
    _textField.keyboardType=_keyboardType;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _textField=[[UITextField alloc] initWithFrame:CGRectZero];
        _textField.textColor = [UIColor blackColor];
        _textField.clearButtonMode=UITextFieldViewModeWhileEditing;
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.delegate=self;
        [self addSubview:_textField];
        [_textField release];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.image=[UIImage lsImageNamed:_imageName];
    _textField.frame=CGRectMake(60.f, 0.f, self.width-60.f, self.height);
    _textField.placeholder=_placeholder;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
