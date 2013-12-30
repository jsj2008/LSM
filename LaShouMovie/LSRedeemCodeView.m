//
//  LSRedeemCodeView.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-30.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSRedeemCodeView.h"

@implementation LSRedeemCodeView

@synthesize order=_order;

- (void)dealloc
{
    self.order=nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [[UIImage lsImageNamed:@""] drawInRect:CGRectInset(rect, 10.f, 0.f)];
    
    [self drawRectangleInRect:CGRectInset(rect, 30.f, 20.f) borderWidth:0.f fillColor:LSColorBackgroundGray strokeColor:LSColorBackgroundGray topRadius:3.f bottomRadius:3.f];
    
    CGSize statusSize;
    if(_order.confirmStatus==LSConfirmStatusDone)
    {
        NSString* text=[NSString stringWithFormat:@"取票码：%@",_order.confirmationID];
        statusSize=[text sizeWithAttributes:[LSAttribute attributeFont:LSFontPaySubtitle]];
        [text drawInRect:CGRectMake(40.f, (rect.size.height-statusSize.height)/2, 240.f, statusSize.height) withAttributes:[LSAttribute attributeFont:LSFontPaidOrderSubtitle]];
    }
    else
    {
        statusSize=[_order.confirmationID sizeWithAttributes:[LSAttribute attributeFont:LSFontPaySubtitle]];
        [_order.confirmationID drawInRect:CGRectMake(40.f, (rect.size.height-statusSize.height)/2, 240.f, statusSize.height) withAttributes:[LSAttribute attributeFont:LSFontPaidOrderSubtitle color:LSColorTextGray]];
    }
    
}

@end
