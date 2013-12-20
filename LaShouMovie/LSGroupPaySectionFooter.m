//
//  LSGroupInfoSectionFooter.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-10.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSGroupPaySectionFooter.h"

@implementation LSGroupPaySectionFooter

@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _cancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"取消订单" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelButton setBackgroundImage:[UIImage stretchableImageWithImage:[UIImage lsImageNamed:@"my_group_order_detail_tag_l_up.png"] top:6 left:6 bottom:6 right:6] forState:UIControlStateNormal];
        [_cancelButton setBackgroundImage:[UIImage stretchableImageWithImage:[UIImage lsImageNamed:@"my_group_order_detail_tag_l_down.png"] top:6 left:6 bottom:6 right:6] forState:UIControlStateHighlighted];
        [_cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelButton];
        
        _payButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [_payButton setTitle:@"继续支付" forState:UIControlStateNormal];
        [_payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_payButton setBackgroundImage:[UIImage stretchableImageWithImage:[UIImage lsImageNamed:@"my_group_order_detail_tag_r_up.png"] top:4 left:4 bottom:8 right:4] forState:UIControlStateNormal];
        [_payButton setBackgroundImage:[UIImage stretchableImageWithImage:[UIImage lsImageNamed:@"my_group_order_detail_tag_r_down.png"] top:4 left:4 bottom:8 right:4] forState:UIControlStateHighlighted];
        [_payButton addTarget:self action:@selector(payButtonClick:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_payButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _payButton.frame = CGRectMake(self.width-10.f-123.f,(self.height-44.f)/2,123.f,44.f);
    _cancelButton.frame = CGRectMake(self.width-10.f-123.f-10.f-123.f,(self.height-40.f)/2,123.f,40.f);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)cancelButtonClick:(UIButton*)sender
{
    if([_delegate respondsToSelector:@selector(LSGroupPaySectionFooter: didClickCancelButton:)])
    {
        [_delegate LSGroupPaySectionFooter:self didClickCancelButton:sender];
    }
}

- (void)payButtonClick:(UIButton*)sender
{
    if([_delegate respondsToSelector:@selector(LSGroupPaySectionFooter: didClickPayButton:)])
    {
        [_delegate LSGroupPaySectionFooter:self didClickPayButton:sender];
    }
}

@end
