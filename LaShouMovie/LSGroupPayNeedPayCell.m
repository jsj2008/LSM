//
//  LSGroupInfoNeedPayCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-10.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSGroupPayNeedPayCell.h"

#define basicFont LSFont15

@implementation LSGroupPayNeedPayCell

@synthesize topRadius=_topRadius;
@synthesize bottomRadius=_bottomRadius;
@synthesize isBottomLine=_isBottomLine;
@synthesize needPay=_needPay;

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
    self.textLabel.font=LSFont15;
    self.textLabel.textColor=LSRGBA(138, 138,138, 1.f);
    self.textLabel.frame=CGRectMake(self.textLabel.left+10, self.textLabel.top, self.textLabel.width, self.textLabel.height);
    self.textLabel.backgroundColor=[UIColor clearColor];
}

- (void)drawRect:(CGRect)rect
{
    [self drawRoundRectangleInRect:CGRectMake(10.f, 0.f, rect.size.width-2*10.f, rect.size.height) topRadius:_topRadius bottomRadius:_bottomRadius isBottomLine:_isBottomLine fillColor:LSColorBgWhiteColor strokeColor:LSColorLineLightGrayColor borderWidth:0.5f];
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    NSString* text=nil;
    float contentWidth=0.f;
    
    text=@"还需要支付";
    CGSize size0=[text sizeWithFont:basicFont];
    contentWidth+=size0.width;
    
    text=[NSString stringWithFormat:@"%.2f",[_needPay floatValue]];
    CGSize size1=[text sizeWithFont:[UIFont systemFontOfSize:22.f]];
    contentWidth+=size1.width;
    
    text=@"元";
    CGSize size2=[text sizeWithFont:basicFont];
    contentWidth+=size2.width;
    
    CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);
    float contentX=rect.size.width-contentWidth-20;
    text=@"还需要支付";
    [text drawInRect:CGRectMake(contentX, (rect.size.height-size0.height)/2+1, size0.width, size0.height) withFont:basicFont];
    contentX+=size0.width;
    
    CGContextSetFillColorWithColor(contextRef, LSColorBlackRedColor.CGColor);
    text=[NSString stringWithFormat:@"%.2f",[_needPay floatValue]];
    [text drawInRect:CGRectMake(contentX, (rect.size.height-size1.height)/2, size1.width, size1.height) withFont:[UIFont systemFontOfSize:22.f]];
    contentX+=size1.width;
    
    CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);
    text=@"元";
    [text drawInRect:CGRectMake(contentX, (rect.size.height-size2.height)/2+1, size2.width, size2.height) withFont:basicFont];
    contentX+=size2.width;
}

@end
