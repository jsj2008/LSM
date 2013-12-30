//
//  LSGroupCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-9.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSGroupCell.h"

#define gap 10.f

@implementation LSGroupCell

@synthesize groupOrder=_groupOrder;

- (void)dealloc
{
    self.groupOrder=nil;
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
    
    NSString* text=_groupOrder.groupTitle;
    
    [text drawInRect:CGRectMake(contentX, contentY, 230.f, 25.f) withAttributes:[LSAttribute attributeFont:LSFontGroupsTitle lineBreakMode:NSLineBreakByTruncatingTail]];
    contentY+=25.f;
    
    text=[NSString stringWithFormat:@"数量%@ | 总价:￥%@",_groupOrder.amount,_groupOrder.totalPrice];
    [text drawInRect:CGRectMake(contentX, contentY, 230.f, 15.f) withAttributes:[LSAttribute attributeFont:LSFontGroupsSubtitle color:LSColorTextGray lineBreakMode:NSLineBreakByTruncatingTail]];
    
    contentX=230.f+gap*2;
    
    text=_groupOrder.orderStatus==LSGroupOrderStatusPaid?@"已付款":@"等待付款";
    CGSize statusSize=[text sizeWithAttributes:[LSAttribute attributeFont:LSFontGroupsSubtitle]];
    [text drawInRect:CGRectMake(contentX, (rect.size.height-statusSize.height)/2, 50.f, statusSize.height) withAttributes:[LSAttribute attributeFont:LSFontGroupsSubtitle color:(_groupOrder.orderStatus==LSGroupOrderStatusPaid?LSColorTextGray:LSColorTextRed) textAlignment:NSTextAlignmentRight]];
}

@end
