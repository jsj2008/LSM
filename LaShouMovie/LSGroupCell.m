//
//  LSGroupCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-9.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSGroupCell.h"

#define gapL 30.f
#define basicWidth 260.f
#define basicSize CGSizeMake(basicWidth, INT32_MAX)

@implementation LSGroupCell

@synthesize groupOrder=_groupOrder;

+ (CGFloat)heightForGroupOrder:(LSGroupOrder*)groupOrder
{
    CGFloat contentY=10.f;
    
    if(groupOrder.groupTitle!=nil)
    {
        CGSize size=[groupOrder.groupTitle sizeWithFont:LSFont15 constrainedToSize:basicSize lineBreakMode:NSLineBreakByCharWrapping];
        contentY+=(size.height+5.f);
    }
    
    NSString* text=[NSString stringWithFormat:@"数量%@  |  总价:",groupOrder.amount];
    CGSize size=[text sizeWithFont:LSFont15];
    
    contentY+=(size.height+5.f);
    return contentY;
}

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
        self.backgroundColor=[UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.contentView.clipsToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
    [self drawLineAtStartPointX:0 y:rect.size.height endPointX:rect.size.width y:rect.size.height strokeColor:LSColorLineLightGrayColor lineWidth:1];
    
    if (!_groupOrder.isPaid)
    {
        [[UIImage lsImageNamed:@"my_order_waiting.png"] drawInRect:CGRectMake(0, 0, 35, 35)];
    }
    else
    {
        [[UIImage lsImageNamed:@"my_order_payed.png"] drawInRect:CGRectMake(0, 0, 35, 35)];
    }
    
    CGFloat contentY=10.f;
    CGFloat contentX=gapL;
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextRef, LSColorBlackGrayColor.CGColor);

    if(_groupOrder.groupTitle!=nil)
    {
        CGSize size=[_groupOrder.groupTitle sizeWithFont:LSFont15 constrainedToSize:basicSize lineBreakMode:NSLineBreakByCharWrapping];
        [_groupOrder.groupTitle drawInRect:CGRectMake(contentX, contentY, size.width, size.height) withFont:LSFont15 lineBreakMode:NSLineBreakByCharWrapping];
        contentY+=(size.height+5.f);
    }
    
    CGContextSetFillColorWithColor(contextRef, [UIColor grayColor].CGColor);
    NSString* text=[NSString stringWithFormat:@"数量%@  |  总价:",_groupOrder.amount];
    CGSize size=[text sizeWithFont:LSFont15];
    [text drawInRect:CGRectMake(contentX, contentY, size.width, size.height) withFont:LSFont15];
    contentX+=size.width;
    
    CGContextSetFillColorWithColor(contextRef, LSColorBlackRedColor.CGColor);
    text=[NSString stringWithFormat:@"￥%@",_groupOrder.totalPrice];
    size=[text sizeWithFont:LSFont15];
    [text drawInRect:CGRectMake(contentX, contentY, size.width, size.height) withFont:LSFont15];
    
    contentY+=(size.height+5.f);
    
    [[UIImage lsImageNamed:@"cinemas_arrow.png"] drawInRect:CGRectMake(self.width - 30, (self.height-15)/2, 10, 15)];
}

#pragma mark- 重载触摸方法
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor=LSColorBgRedYellowColor;
    [super touchesBegan:touches withEvent:event];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor=[UIColor clearColor];
    [super touchesEnded:touches withEvent:event];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor=[UIColor clearColor];
    [super touchesCancelled:touches withEvent:event];
}

@end
