//
//  LSTicketInfoPositionCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-17.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTicketInfoPositionCell.h"
#import "NSDate+Extension.h"

#define gapL 20.f
#define basicWidth 265.f
#define basicSize CGSizeMake(basicWidth, INT32_MAX)

@implementation LSTicketInfoPositionCell

@synthesize ticket=_ticket;

+ (CGFloat)heightOfTicket:(LSTicket *)ticket
{
    CGFloat contentY = 20.f;
    
    NSString* text=@"查看商家地址";
    CGSize size = [text sizeWithFont:LSFont15];
    contentY+=(size.height+5.f);
    
    if (ticket.buyTime!=nil)
    {
        text =[NSString stringWithFormat:@"成交日期：%@",[ticket.buyTime stringValueByFormatter:@"yyyy-MM-dd"]];
        size=[text sizeWithFont:LSFont10];
        contentY+=(size.height+7.f);
    }
    return contentY;
}

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

- (void)drawRect:(CGRect)rect
{
    CGRect bgRect=CGRectMake(10.f, 10.f, rect.size.width-2*10.f, rect.size.height-10.f);
    
    CGFloat contentY = 20.f;
    CGFloat contentX=gapL;

    //绘制距离图标
    [[UIImage lsImageNamed:@"cinemas_distance.png"] drawInRect:CGRectMake(contentX, (rect.size.height-10.f-12.5)/2+10.f, 11.5f, 12.5f)];
    contentX+=15.f;
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);
    
    NSString* text=@"查看商家地址";
    CGSize size = [text sizeWithFont:LSFont15];
    [text drawInRect:CGRectMake(contentX, contentY, size.width, size.height) withFont:LSFont14];
    contentY+=(size.height+5.f);
    
    CGContextSetFillColorWithColor(contextRef, [UIColor grayColor].CGColor);
    if (_ticket.buyTime!=nil)
    {
        text =[NSString stringWithFormat:@"成交日期：%@",[_ticket.buyTime stringValueByFormatter:@"yyyy-MM-dd"]];
        size=[text sizeWithFont:LSFont10];
        [text drawInRect:CGRectMake(contentX, contentY, size.width, size.height) withFont:LSFont10];
        contentY+=(size.height+7.f);
    }

    [[UIImage lsImageNamed:@"cinemas_arrow.png"] drawInRect:CGRectMake(rect.size.width - 30.f, (rect.size.height-10.f-15.f)/2+10.f, 10.f, 15.f)];
}

@end
