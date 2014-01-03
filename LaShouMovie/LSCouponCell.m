//
//  LSCouponCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-27.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSCouponCell.h"
#define gap 10.f

@implementation LSCouponCell

@synthesize coupon=_coupon;

- (void)dealloc
{
    self.coupon=nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect
{
    //初始化顶部距离
    CGFloat contentX=gap;
    CGFloat contentY=gap;
    NSString* text=nil;
    
    text=@"￥";
    [text drawInRect:CGRectMake(contentX, contentY+10.f, 10.f, 10.f) withAttributes:[LSAttribute attributeFont:LSFontCouponsY color:(_coupon.couponStatus==LSCouponStatusUnuse?LSColorTextRed:LSColorTextGray)]];
    
    contentX+=10.f;
    
    if(_coupon.couponType==LSCouponTypeMoney)
    {
        text=_coupon.price;
    }
    else
    {
        text=_coupon.exchangeWay;
    }
    //230=320-左10-Y10-间隔10-状态50-右10
    [text drawInRect:CGRectMake(contentX, contentY, 230.f, 25.f) withAttributes:[LSAttribute attributeFont:LSFontCouponsPrice color:(_coupon.couponStatus==LSCouponStatusUnuse?LSColorTextRed:LSColorTextGray)]];
    
    contentX=+240.f;
    
    if(_coupon.couponStatus==LSCouponStatusUnuse)
    {
        text=@"未使用";
    }
    else
    {
        text=@"已使用";
    }
    [text drawInRect:CGRectMake(contentX, contentY, 50.f, 25.f) withAttributes:[LSAttribute attributeFont:LSFontCouponsInfo color:(_coupon.couponStatus==LSCouponStatusUnuse?LSColorTextRed:LSColorTextGray) textAlignment:NSTextAlignmentRight]];
    
    contentX=gap;
    contentY+=25.f;
    
    text=_coupon.description;
    [text drawInRect:CGRectMake(contentX, contentY, 300.f, 15.f) withAttributes:[LSAttribute attributeFont:LSFontCouponsInfo color:(_coupon.couponStatus==LSCouponStatusUnuse?LSColorTextBlack:LSColorTextGray)]];
    
    contentY+=15.f;
    
    text=[NSString stringWithFormat:@"有效期：%@",_coupon.expireTime];
    //190=320-左10-间隔10-状态100-右10
    [text drawInRect:CGRectMake(contentX, contentY, 190.f, 15.f) withAttributes:[LSAttribute attributeFont:LSFontCouponsTime color:LSColorTextGray]];
    
    contentX+=200.f;
    
    if(_coupon.couponStatus==LSCouponStatusUnuse)
    {
        text=@"(还有N天过期)";
        [text drawInRect:CGRectMake(contentX, contentY, 190.f, 15.f) withAttributes:[LSAttribute attributeFont:LSFontCouponsInfo color:LSColorTextRed]];
    }
}

@end
