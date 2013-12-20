//
//  LSFeedbackView.m
//  LaShouMovie
//
//  Created by Li XiangYu on 13-10-4.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSFeedbackView.h"

@implementation LSFeedbackView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);
    NSString* text = @"您的意见和建议:";
    [text drawInRect:CGRectMake(15.f, 10.f, 290.f, 19.f) withFont:LSFont15];

    [self drawRoundRectangleInRect:CGRectMake(15.f, 40.f, basicTextViewWidth, feedbackTextViewHeight) topRadius:3.f bottomRadius:3.f isBottomLine:YES fillColor:LSColorBgWhiteColor strokeColor:LSColorLineLightGrayColor borderWidth:0.5f];
    
    CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);
    text = @"联系方式:";
    [text drawInRect:CGRectMake(15.f, 200.f, 290.f, 19.f) withFont:LSFont15];
    
    [self drawRoundRectangleInRect:CGRectMake(15.f, 230.f, basicTextViewWidth, phoneTextViewHeight) topRadius:3.f bottomRadius:3.f isBottomLine:YES fillColor:LSColorBgWhiteColor strokeColor:LSColorLineLightGrayColor borderWidth:0.5f];
    
    
    [[UIImage lsImageNamed:@"feed_f.png"] drawInRect:CGRectMake(0.f, 340.f, 320.f, 64.f)];
}


@end
