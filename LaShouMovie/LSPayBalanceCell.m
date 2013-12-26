//
//  LSPayBalanceCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-11-27.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSPayBalanceCell.h"

#define gap 10.f

@implementation LSPayBalanceCell

@synthesize order=_order;

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
    CGFloat contentX=gap;
    
    NSString* text = @"拉手余额:";
    CGSize titleSize=[text sizeWithAttributes:[LSAttribute attributeFont:LSFontPayTitle]];
    [text drawInRect:CGRectMake(contentX, (rect.size.height-titleSize.height)/2, titleSize.width, titleSize.height) withAttributes:[LSAttribute attributeFont:LSFontPayTitle]];
    
    contentX=rect.size.width-gap;
    
    text=_order.totalPrice;
    CGSize priceSize=[text sizeWithAttributes:[LSAttribute attributeFont:LSFontPayPrice]];
    [text drawInRect:CGRectMake(contentX, (rect.size.height-priceSize.height)/2-(priceSize.height-titleSize.height)/2, priceSize.width, priceSize.height) withAttributes:[LSAttribute attributeFont:LSFontPayPrice]];
    
    contentX-=(priceSize.width+5.f);
    
    text = @"￥";
    CGSize ySize=[text sizeWithAttributes:[LSAttribute attributeFont:LSFontPayY]];
    [text drawInRect:CGRectMake(contentX, (rect.size.height-ySize.height)/2+(titleSize.height-ySize.height)/2, ySize.width, ySize.height) withAttributes:[LSAttribute attributeFont:LSFontPayY]];
}

@end
