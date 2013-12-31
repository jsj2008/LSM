//
//  LSTicketInfoInfoCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-17.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTicketInfoInfoCell.h"

#define gapL 20.f
#define basicWidth 200.f
#define basicSize CGSizeMake(basicWidth, INT32_MAX)

@implementation LSTicketInfoInfoCell

@synthesize ticket=_ticket;

- (void)setTicket:(LSTicket *)ticket
{
    if(![_ticket isEqual:ticket])
    {
        if(_ticket!=nil)
        {
            LSRELEASE(_ticket)
        }
        _ticket=[ticket retain];
        [self.imageView setImageWithURL:[NSURL URLWithString:_ticket.smallImageURL] placeholderImage:LSPlaceholderImage];
    }
}

+ (CGFloat)heightOfTicket:(LSTicket*)ticket
{
    CGFloat contentY=20.f;
    
    NSString* text=@"￥";
    CGSize size=[text sizeWithFont:LSFontBold15];
    contentY+=size.height;
    
    contentY+=5.f;
    
    if(ticket.groupTitle!=nil)
    {
        CGSize size=[ticket.groupTitle sizeWithFont:LSFontBold15 constrainedToSize:basicSize lineBreakMode:NSLineBreakByCharWrapping];
        contentY+=(size.height+5);
    }
    
    contentY+=17.f;
    
    contentY+=5;
    return contentY;
}

#pragma mark- 生命周期
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
        self.backgroundView=nil;
        self.backgroundColor=[UIColor clearColor];
        self.clipsToBounds=YES;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
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
    self.imageView.frame=CGRectMake(gapL, 20.f, 80.f, 57.f);
}

- (void)drawRect:(CGRect)rect
{
    CGRect bgRect=CGRectMake(10.f, 10.f, rect.size.width-2*10.f, rect.size.height-10.f);

    CGContextRef contextRef=UIGraphicsGetCurrentContext();
    CGFloat contentY=20.f;
    CGFloat contentX=gapL+85.f;
    
    NSString* text=[[NSString stringWithFormat:@"￥%f",_ticket.price] stringByReplacingOccurrencesOfString:@".00" withString:@""];
    CGSize size=[text sizeWithFont:LSFontBold15];
    [text drawInRect:CGRectMake(contentX, contentY, size.width, size.height) withFont:LSFontBold15];
    contentX+=(size.width+2.f);
    contentY+=size.height;
    
    CGContextSetFillColorWithColor(contextRef, [UIColor grayColor].CGColor);
    text=[[NSString stringWithFormat:@"(￥%.2f)",_ticket.initialPrice] stringByReplacingOccurrencesOfString:@".00)" withString:@")"];
    size=[text sizeWithFont:LSFont10];
    [text drawInRect:CGRectMake(contentX, contentY-size.height, size.width, size.height) withFont:LSFont10];
    
    contentY+=5.f;
    
    contentX=gapL+85.f;
    CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);
    if(_ticket.groupTitle!=nil)
    {
        CGSize size=[_ticket.groupTitle sizeWithFont:LSFontBold15 constrainedToSize:basicSize lineBreakMode:NSLineBreakByCharWrapping];
        [_ticket.groupTitle drawInRect:CGRectMake(contentX, contentY, basicWidth, size.height) withFont:LSFontBold15 lineBreakMode:NSLineBreakByCharWrapping];
        contentY+=(size.height+5);
    }
    
    CGContextSetFillColorWithColor(contextRef, [UIColor grayColor].CGColor);
    //七天退款
    if (_ticket.isSevenRefund)
    {
        [[UIImage lsImageNamed:@"iconRight.png"]  drawInRect:CGRectMake(contentX, contentY, 17.f, 17.f)];
        text=@"支持随时退款";
    }
    else
    {
        [[UIImage lsImageNamed:@"iconWrong.png"]  drawInRect:CGRectMake(contentX, contentY, 17.f, 17.f)];
        text=@"不支持随时退款";
    }
    contentX+=17.f;
    size=[text sizeWithFont:LSFont10];
    [text drawInRect:CGRectMake(contentX, contentY+17.f-size.height, size.width, size.height) withFont:LSFont10];
    contentX+=(size.width+23.f);
    
    //自动退款
    if (_ticket.isAutoRefund)
    {
        [[UIImage lsImageNamed:@"iconRight.png"]  drawInRect:CGRectMake(contentX, contentY, 17.f, 17.f)];
        text=@"支持过期自动退款";
    }
    else
    {
        [[UIImage lsImageNamed:@"iconWrong.png"]  drawInRect:CGRectMake(contentX, contentY, 17.f, 17.f)];
        text=@"不支持过期自动退款";
    }
    contentX+=17.f;
    size=[text sizeWithFont:LSFont10];
    [text drawInRect:CGRectMake(contentX, contentY+17.f-size.height, size.width, size.height) withFont:LSFont10];
    contentX+=(size.width+33.f);

    contentY+=17.f;
    
    contentY+=5;
}

@end
