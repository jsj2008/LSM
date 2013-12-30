//
//  LSPaidOrderCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-29.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSPaidOrderCell.h"

#define gap 10.f

@implementation LSPaidOrderCell

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
    
    [text drawInRect:CGRectMake(contentX, contentY, 230.f, 25.f) withAttributes:[LSAttribute attributeFont:LSFontPaidOrderTitle lineBreakMode:NSLineBreakByTruncatingTail]];
    contentY+=25.f;
    
    text=[NSString stringWithFormat:@"%@ %@", _order.schedule.startDate, _order.schedule.startTime];
    [text drawInRect:CGRectMake(contentX, contentY, 230.f, 15.f) withAttributes:[LSAttribute attributeFont:LSFontPaidOrderSubtitle color:LSColorTextGray lineBreakMode:NSLineBreakByTruncatingTail]];
    
    contentX=230.f+gap*2;
    
    if(_order.confirmStatus==LSConfirmStatusDone)
    {
        text=@"已出票";
    }
    else if(_order.confirmStatus==LSConfirmStatusDoing)
    {
        text=@"正在出票";
    }
    else
    {
        text=@"出票失败";
    }
    CGSize statusSize=[text sizeWithAttributes:[LSAttribute attributeFont:LSFontPaidOrderSubtitle]];
    if(_order.confirmStatus==LSConfirmStatusDoing)
    {
        [text drawInRect:CGRectMake(contentX, (rect.size.height-statusSize.height)/2, 50.f, statusSize.height) withAttributes:[LSAttribute attributeFont:LSFontPaidOrderSubtitle color:LSColorTextRed textAlignment:NSTextAlignmentRight]];
    }
    else
    {
        [text drawInRect:CGRectMake(contentX, (rect.size.height-statusSize.height)/2, 50.f, statusSize.height) withAttributes:[LSAttribute attributeFont:LSFontPaidOrderSubtitle color:LSColorTextGray textAlignment:NSTextAlignmentRight]];
    }
}

@end
