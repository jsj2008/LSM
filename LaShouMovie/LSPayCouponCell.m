//
//  LSPayCouponCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-11-27.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSPayCouponCell.h"

#define gap 10.f

@implementation LSPayCouponCell

@synthesize order=_order;
@synthesize delegate=_delegate;

#pragma mark- 生命周期
- (void)dealloc
{
    self.order=nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _couponButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_couponButton setBackgroundImage:[UIImage lsImageNamed:@""]  forState:UIControlStateNormal];
        [_couponButton setBackgroundImage:[UIImage lsImageNamed:@"btn_coupon_sel.png"] forState:UIControlStateHighlighted];
        [_couponButton addTarget:self action:@selector(couponButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_couponButton];
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
    _couponButton.frame=CGRectMake(self.width-gap-30.f, (self.height-30.f)/2, 30.f, 30.f);
}

- (void)drawRect:(CGRect)rect
{
    CGFloat contentX=gap;
    
    NSString* text = @"优惠券:";
    CGSize titleSize=[text sizeWithAttributes:[LSAttribute attributeFont:LSFontPayTitle]];
    [text drawInRect:CGRectMake(contentX, (rect.size.height-titleSize.height)/2, titleSize.width, titleSize.height) withAttributes:[LSAttribute attributeFont:LSFontPayTitle]];
    
    contentX=rect.size.width-gap*2-30.f;
    
    text = @"张";
    CGSize subSize=[text sizeWithAttributes:[LSAttribute attributeFont:LSFontPaySubtitle]];
    [text drawInRect:CGRectMake(contentX-subSize.width, (rect.size.height-subSize.height)/2+(titleSize.height-subSize.height)/2, subSize.width, subSize.height) withAttributes:[LSAttribute attributeFont:LSFontPaySubtitle color:LSColorTextGray]];
    
    contentX-=subSize.width;
    
    text=[NSString stringWithFormat:@"%d",_order.couponArray.count];
    CGSize priceSize=[text sizeWithAttributes:[LSAttribute attributeFont:LSFontPayPrice]];
    [text drawInRect:CGRectMake(contentX, (rect.size.height-priceSize.height)/2-(priceSize.height-titleSize.height)/2, priceSize.width, priceSize.height) withAttributes:[LSAttribute attributeFont:LSFontPayPrice]];
}

#pragma mark- 私有方法
- (void)couponButtonClick:(UIButton*)sender
{
    [_delegate LSPayCouponCell:self didClickCouponButton:sender];
}

@end
