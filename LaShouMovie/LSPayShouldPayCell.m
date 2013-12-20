//
//  LSPayShouldPayCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-11-27.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSPayShouldPayCell.h"

#define gapL 10.f
#define basicWidth 280.f
#define basicSize CGSizeMake(basicWidth, INT32_MAX)

@implementation LSPayShouldPayCell

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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.clipsToBounds = YES;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor=[UIColor clearColor];
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
    [self drawRoundRectangleInRect:CGRectMake(gapL, gapL, rect.size.width-2*gapL, rect.size.height-gapL) topRadius:3.f bottomRadius:0.f isBottomLine:NO fillColor:LSColorBgWhiteColor strokeColor:LSColorLineGrayColor borderWidth:0.5];
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGFloat contentX=gapL;
    
    CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);
    NSString* text = @"应付金额:";
    CGSize size=[text sizeWithFont:LSFont15];
    [text drawInRect:CGRectMake(contentX, (rect.size.height-gapL-size.height)/2+gapL, 80.f, size.height) withFont:LSFont15 lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentRight];
    contentX+=(80.f+5.f);
    
    text = @"￥";
    size=[text sizeWithFont:LSFont15];
    [text drawInRect:CGRectMake(contentX, (rect.size.height-gapL-size.height)/2+gapL+1.5f, size.width, size.height) withFont:LSFont15];
    contentX+=size.width;
    
    CGContextSetFillColorWithColor(contextRef, [UIColor grayColor].CGColor);
    text = [[NSString stringWithFormat:@"%.2f", [_order.originTotalPrice floatValue]] stringByReplacingOccurrencesOfString:@".00" withString:@""];
    size=[text sizeWithFont:LSFontBold20];
    [text drawInRect:CGRectMake(contentX, (rect.size.height-gapL-size.height)/2+gapL-1.f, size.width, size.height) withFont:LSFontBold20];
    contentX+=(size.width+5.f);
    
    CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);
    text = @"(含服务费)";
    size=[text sizeWithFont:LSFont15];
    [text drawInRect:CGRectMake(contentX, (rect.size.height-gapL-size.height)/2+gapL, size.width, size.height) withFont:LSFont15];
    contentX+=size.width;
}

@end
