//
//  LSGroupInfoInfoCell.m
//  LaShouMovie
//
//  Created by Li XiangYu on 13-10-10.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSGroupInfoInfoCell.h"

#define gapL 20.f
#define basicWidth 280.f
#define basicSize CGSizeMake(basicWidth, INT32_MAX)

@implementation LSGroupInfoInfoCell

@synthesize group=_group;

+ (CGFloat)heightOfGroup:(LSGroup*)group
{
    CGFloat contentY=15.f;
    
    if(group.groupTitle!=nil)
    {
        CGSize size=[group.groupTitle sizeWithFont:LSFontBold15 constrainedToSize:basicSize lineBreakMode:NSLineBreakByCharWrapping];
        contentY+=(size.height+5);
    }

    contentY+=17.f;
    contentY+=5;
    contentY+=5;
    
    NSString* text=[NSString stringWithFormat:@"人"];
    CGSize size=[text sizeWithFont:LSFontBold15];
    contentY+=(size.height+5);
    
    return contentY;
}

#pragma mark- 生命周期
- (void)dealloc
{
    self.group=nil;
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
    CGRect bgRect=CGRectMake(10, 10, rect.size.width-2*10, rect.size.height-10);
    [self drawRoundRectangleInRect:bgRect topRadius:3.f bottomRadius:3.f isBottomLine:YES fillColor:LSColorBgWhiteColor strokeColor:LSColorLineLightGrayColor borderWidth:0.5f];
    
    CGContextRef contextRef=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextRef, LSColorBlackRedColor.CGColor);
    CGFloat contentY=15.f;
    
    CGSize size;
    if(_group.groupTitle!=nil)
    {
        size=[_group.groupTitle sizeWithFont:LSFontBold15 constrainedToSize:basicSize lineBreakMode:NSLineBreakByCharWrapping];
        [_group.groupTitle drawInRect:CGRectMake(gapL, contentY, basicWidth, size.height) withFont:LSFontBold15 lineBreakMode:NSLineBreakByCharWrapping];
        contentY+=(size.height+5);
    }

    CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);
    CGFloat contentX=gapL;
    //七天退款
    NSString* text=nil;
    if (_group.isSevenRefund)
    {
        [[UIImage lsImageNamed:@"iconRight.png"]  drawInRect:CGRectMake(contentX, contentY, 17.f, 17.f)];
        text=@"支持七天退款";
    }
    else
    {
        [[UIImage lsImageNamed:@"iconWrong.png"]  drawInRect:CGRectMake(contentX, contentY, 17.f, 17.f)];
        text=@"不支持七天退款";
    }
    contentX+=17.f;
    size=[text sizeWithFont:LSFont10];
    [text drawInRect:CGRectMake(contentX, contentY+17.f-size.height, size.width, size.height) withFont:LSFont10];
    contentX+=(size.width+33.f);
    
    //自动退款
    if (_group.isAutoRefund)
    {
        [[UIImage lsImageNamed:@"iconRight.png"]  drawInRect:CGRectMake(contentX, contentY, 17.f, 17.f)];
        text=@"支持过期退款";
    }
    else
    {
        [[UIImage lsImageNamed:@"iconWrong.png"]  drawInRect:CGRectMake(contentX, contentY, 17.f, 17.f)];
        text=@"不支持过期退款";
    }
    contentX+=17.f;
    size=[text sizeWithFont:LSFont10];
    [text drawInRect:CGRectMake(contentX, contentY+17.f-size.height, size.width, size.height) withFont:LSFont10];
    contentX+=(size.width+33.f);
    
    contentY+=17.f;
    
    contentY+=5;
    
    CGContextSetStrokeColorWithColor(contextRef, [UIColor lightGrayColor].CGColor);
    CGContextSetLineWidth(contextRef, 1.0);
    CGFloat dashArray[] = {1,1};
    CGContextSetLineDash(contextRef, 8, dashArray, 2);
    
    CGContextMoveToPoint(contextRef, gapL, contentY);
    CGContextAddLineToPoint(contextRef, gapL+basicWidth,contentY);
    CGContextStrokePath(contextRef);
    
    CGContextMoveToPoint(contextRef, gapL+basicWidth/2, contentY);
    CGContextAddLineToPoint(contextRef, gapL+basicWidth/2, rect.size.height);
    CGContextStrokePath(contextRef);
    
    contentY+=5;
    
    contentX=gapL;
    if (_group.aleadyBought!=nil)
    {
        [[UIImage lsImageNamed:@"alreadyBuy.png"]  drawInRect:CGRectMake(contentX, contentY, 17.f, 17.f)];
        contentX+=18.f;
        
        NSString* text=[NSString stringWithFormat:@"%@人",_group.aleadyBought];
        size=[text sizeWithFont:LSFontBold15];
        [text drawInRect:CGRectMake(contentX, contentY, size.width, size.height) withFont:LSFontBold15];
        contentX+=size.width;
        
        text=@"已购买";
        [text drawInRect:CGRectMake(contentX, contentY+4, 100-size.width, 17.f) withFont:LSFont10];
    }
    
    contentX=gapL+basicWidth/2+5;
    if (_group.endTime!=nil)
    {
        [[UIImage lsImageNamed:@"clock.png"] drawInRect:CGRectMake(contentX, contentY, 17.f, 17.f)];
        contentX+=18.f;
        
        NSString* text=[NSString stringWithFormat:@"%@过期",[_group.endTime stringValueByFormatter:@"yyyy年MM月dd日"]];
        [text drawInRect:CGRectMake(contentX, contentY+2, 100, 17.f) withFont:LSFont10];
    }
    
    contentY+=(17.f+5.f);
}

@end
