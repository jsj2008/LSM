//
//  LSGroupCreateOrderSectionFooter.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-11.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSGroupCreateOrderSectionFooter.h"

@implementation LSGroupCreateOrderSectionFooter

@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setBackgroundImage:[UIImage stretchableImageWithImage:[UIImage lsImageNamed:@"corder_confirm.png"] top:23 left:4 bottom:23 right:4] forState:UIControlStateNormal];
        [_submitButton setBackgroundImage:[UIImage stretchableImageWithImage:[UIImage lsImageNamed:@"corder_confirm_d.png"] top:23 left:4 bottom:23 right:4] forState:UIControlStateHighlighted];
        _submitButton.titleLabel.font = LSFontBold18;
        [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitButton setTitle:@"提交订单" forState:UIControlStateNormal];
        [_submitButton addTarget:self action:@selector(submitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_submitButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _submitButton.frame = CGRectMake(10.f, 10.f, self.width-10.f*2, 44.f);
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
    if([_delegate respondsToSelector:@selector(LSGroupCreateOrderSectionFooter: didClickSubmitButton:)])
    {
        [_delegate LSGroupCreateOrderSectionFooter:self didClickSubmitButton:sender];
    }
}

@end
