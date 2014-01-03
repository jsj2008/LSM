//
//  LSTicketCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-16.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTicketCell.h"

#define gap 10.f

@implementation LSTicketCell

@synthesize ticket=_ticket;

- (void)dealloc
{
    self.ticket=nil;
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
    CGFloat contentY=gap;
    CGFloat contentX=gap;

    NSString* text=nil;
    
    text=_ticket.groupTitle;
    [text drawInRect:CGRectMake(contentX, contentY, 300.f, 20.f) withAttributes:[LSAttribute attributeFont:LSFontGroupsTitle color:(_ticket.ticketStatus==LSTicketStatusUnuse?LSColorTextBlack:LSColorTextGray) lineBreakMode:NSLineBreakByTruncatingTail]];
    
    contentY+=20.f;
    
    text=[NSString stringWithFormat:@"拉手券号：%@",_ticket.ticketID];
    [text drawInRect:CGRectMake(contentX, contentY, 300.f, 15.f) withAttributes:[LSAttribute attributeFont:LSFontGroupsSubtitle color:(_ticket.ticketStatus==LSTicketStatusUnuse?LSColorTextBlack:LSColorTextGray) lineBreakMode:NSLineBreakByTruncatingTail]];
    
    contentY+=15.f;
    
    text=[NSString stringWithFormat:@"有效期至：%@",_ticket.expireTime];
    [text drawInRect:CGRectMake(contentX, contentY, 240.f, 15.f) withAttributes:[LSAttribute attributeFont:LSFontGroupsSubtitle color:(_ticket.ticketStatus==LSTicketStatusUnuse?LSColorTextBlack:LSColorTextGray) lineBreakMode:NSLineBreakByTruncatingTail]];

    if(_ticket.ticketStatus==LSTicketStatusUnuse)
    {
        text=@"未使用";
    }
    else if(_ticket.ticketStatus==LSTicketStatusUsed)
    {
        text=@"未使用";
    }
    else
    {
        text=@"未使用";
    }
    CGSize statusSize=[text sizeWithAttributes:[LSAttribute attributeFont:LSFontGroupsSubtitle]];
    [text drawInRect:CGRectMake(contentX, (rect.size.height-statusSize.height)/2, 50.f, statusSize.height) withAttributes:[LSAttribute attributeFont:LSFontGroupsSubtitle color:(_ticket.ticketStatus==LSTicketStatusUnuse?LSColorTextRed:LSColorTextGray) textAlignment:NSTextAlignmentRight]];
}

@end
