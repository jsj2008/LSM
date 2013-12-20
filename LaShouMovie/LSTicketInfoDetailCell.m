//
//  LSTicketInfoDetailCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-17.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTicketInfoDetailCell.h"

#define gapL 20.f
#define basicWidth 200.f
#define basicSize CGSizeMake(basicWidth, INT32_MAX)

@implementation LSTicketInfoDetailCell

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
    //
    //因为涉及了一张固定的背景与一张固定的图片，所以不能使用计算大小
    //
    
    [[UIImage lsImageNamed:@"my_group_ticket_detail_quan_bg.png"] drawInRect:CGRectMake(10.f, 10.f, rect.size.width-10.f*2, 85.f)];
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(contextRef, [UIColor grayColor].CGColor);
    
    CGFloat contentY=20.f;
    CGFloat contentX=gapL;
    
    NSString* text=@"券号";
    CGSize size=[text sizeWithFont:LSFont13];
    [text drawInRect:CGRectMake(contentX, contentY, size.width, size.height) withFont:LSFont13];
    contentX+=(size.width+3.f);
 
    if(_ticket.ticketID!=nil)
    {
        CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);
        size=[_ticket.ticketID sizeWithFont:LSFont13];
        [_ticket.ticketID drawInRect:CGRectMake(contentX, contentY, size.width, size.height) withFont:LSFont13];
    }
    contentY+=(size.height+5.f);
    contentX=gapL;
    
    if(_ticket.expireTime!=nil)
    {
        CGContextSetFillColorWithColor(contextRef, [UIColor grayColor].CGColor);
        text=[NSString stringWithFormat:@"有效期至 %@",_ticket.expireTime];
        CGSize size=[text sizeWithFont:LSFont10];
        [text drawInRect:CGRectMake(contentX, contentY, size.width, size.height) withFont:LSFont10];
        
        contentY+=(size.height+5.f);
    }
    
    [self drawLineAtStartPointX:gapL y:contentY endPointX:basicWidth y:contentY strokeColor:[UIColor grayColor] lineWidth:1.f];
    contentY+=5.f;
    
    text=@"密码";
    size=[text sizeWithFont:LSFont13];
    [text drawInRect:CGRectMake(contentX, contentY+3.f, size.width, size.height) withFont:LSFont13];
    contentX+=(size.width+3.f);
    
    if(_ticket.ticketPassword!=nil)
    {
        CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);
        CGSize size=[_ticket.ticketPassword sizeWithFont:LSFont15];
        [_ticket.ticketPassword drawInRect:CGRectMake(contentX, contentY, size.width, size.height) withFont:LSFont15];
    }
    contentX+=(size.height+5.f);
    
    if (_ticket.ticketStatus ==LSTicketStatusUnuse)
    {
        [[UIImage lsImageNamed:@"my_group_ticket_detail_wsy.png"] drawInRect:CGRectMake(183.f , 18.f, 77.f, 72.f)];
    }
    else if (_ticket.ticketStatus ==LSTicketStatusUnuse)
    {
        [[UIImage lsImageNamed:@"my_group_ticket_detail_ysx.png"] drawInRect:CGRectMake(183.f , 18.f, 77.f, 72.f)];
    }
    else if (_ticket.ticketStatus ==LSTicketStatusUnuse)
    {
        [[UIImage lsImageNamed:@"my_group_ticket_detail_ygq.png"] drawInRect:CGRectMake(183.f , 18.f, 77.f, 72.f)];
    }
    else if (_ticket.ticketStatus ==LSTicketStatusRefund)
    {
        [[UIImage lsImageNamed:@"my_group_ticket_detail_ytk.png"] drawInRect:CGRectMake(183.f , 18.f, 77.f, 72.f)];
    }
    else if (_ticket.ticketStatus ==LSTicketStatusRefunding)
    {
        [[UIImage lsImageNamed:@"my_group_ticket_detail_tkz.png"] drawInRect:CGRectMake(183.f , 18.f, 77.f, 72.f)];
    }
    
    [@"拉手券" drawInRect:CGRectMake(270,26,25,58) withFont:LSFontBold16 lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
}

@end
