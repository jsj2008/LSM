//
//  LSCouponCommonCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-11-28.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSUseCouponCommonCell.h"

#define gap 12.5f
#define basicWidth 280.f

@implementation LSUseCouponCommonCell

@synthesize coupon=_coupon;
@synthesize topMargin=_topMargin;
@synthesize delegate=_delegate;

#pragma mark- 生命周期
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
        _deleteButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage lsImageNamed:@"btn_close_nor.png"] forState:UIControlStateNormal];
        [_deleteButton setImage:[UIImage lsImageNamed:@"btn_close_sel.png"] forState:UIControlStateHighlighted];
        [_deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteButton];
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
    _deleteButton.frame=CGRectMake(270.f, 2.5f+_topMargin, 40.f, 40.f);
    if(_coupon.couponValid==LSCouponValidInvalid || _coupon.couponStatus==LSCouponStatusUnuse)
    {
        _deleteButton.hidden=YES;
    }
    else
    {
        _deleteButton.hidden=NO;
    }
}

- (void)drawRect:(CGRect)rect
{
    CGFloat contentX=gap;
    CGFloat contentY=gap+_topMargin;
    
    NSString* text = nil;
    
    //
    text=@"通兑券";
    [text drawInRect:CGRectMake(contentX, contentY, 40.f, 15.f) withAttributes:[LSAttribute attributeFont:LSFontCouponSubtitle]];
    contentX+=50.f;
    
    //
    text=_coupon.couponID;
    [_coupon.couponID drawInRect:CGRectMake(contentX, contentY, 200.f, 15.f) withAttributes:[LSAttribute attributeFont:LSFontCouponSubtitle]];
    
    contentY+=15.f;
    contentX=gap;
    
    if(_coupon.couponValid==LSCouponValidInvalid)
    {
        text = @"券不可用";
        [text drawInRect:CGRectMake(contentX, contentY, 260.f, 15.f) withAttributes:[LSAttribute attributeFont:LSFontCouponSubtitle color:LSColorTextRed lineBreakMode:NSLineBreakByCharWrapping]];
    }
    else if(_coupon.couponStatus==LSCouponStatusUnuse)
    {
        text = @"券未使用";
        [text drawInRect:CGRectMake(contentX, contentY, 260.f, 15.f) withAttributes:[LSAttribute attributeFont:LSFontCouponSubtitle color:LSColorTextRed lineBreakMode:NSLineBreakByCharWrapping]];
    }
    else
    {
        
        text = [NSString stringWithFormat:@"%@ %@",_coupon.exchangeWay,_coupon.lessPriceRemind];
        [text drawInRect:CGRectMake(contentX, contentY, 260.f, 15.f) withAttributes:[LSAttribute attributeFont:LSFontCouponSubtitle color:LSColorTextRed lineBreakMode:NSLineBreakByCharWrapping]];
        
        text=_coupon.expireTime;
        [text drawInRect:CGRectMake(contentX, contentY, 250.f, 15.f) withAttributes:[LSAttribute attributeFont:LSFontCouponSubtitle color:LSColorTextGray textAlignment:NSTextAlignmentRight]];
    }
}

- (void)deleteButtonClick:(UIButton*)sender
{
    [_delegate LSUseCouponCommonCell:self didClickDeleteButton:sender];
}

@end
