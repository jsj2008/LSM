//
//  LSUnpayOrderCell.m
//  LaShouMovie
//
//  Created by Li XiangYu on 13-10-2.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSUnpayOrderCell.h"

#define gap 10.f

@implementation LSUnpayOrderCell

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
        self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
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
    CGFloat contentY=gap;
    CGFloat contentX=gap;
    
    NSString* text=_order.film.filmName;
    
    [text drawInRect:CGRectMake(contentX, contentY, 230.f, 25.f) withAttributes:[LSAttribute attributeFont:LSFontUnpaidOrderTitle lineBreakMode:NSLineBreakByTruncatingTail]];
    contentY+=25.f;
    
    text=[NSString stringWithFormat:@"%@ %@", _order.schedule.startDate, _order.schedule.startTime];
    [text drawInRect:CGRectMake(contentX, contentY, 230.f, 15.f) withAttributes:[LSAttribute attributeFont:LSFontUnpaidOrderSubtitle color:LSColorTextGray lineBreakMode:NSLineBreakByTruncatingTail]];
    
    contentX=230.f+gap*2;
    
    text=@"重新购买";
    CGSize statusSize=[text sizeWithAttributes:[LSAttribute attributeFont:LSFontUnpaidOrderSubtitle]];
    [text drawInRect:CGRectMake(contentX, (rect.size.height-statusSize.height)/2, 50.f, statusSize.height) withAttributes:[LSAttribute attributeFont:LSFontPaidOrderSubtitle color:LSColorTextRed textAlignment:NSTextAlignmentRight]];
}

@end
