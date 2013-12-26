//
//  LSPayShouldPayCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-11-27.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSPayShouldPayCell.h"

#define gap 10.f

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
    CGFloat contentX=gap;
    
    NSString* text = @"应付金额:";
    CGSize size=[text sizeWithAttributes:[LSAttribute attributeFont:LSFontPayTitle]];
    [text drawInRect:<#(CGRect)#> withAttributes:<#(NSDictionary *)#>];
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
