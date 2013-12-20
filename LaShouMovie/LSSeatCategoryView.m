//
//  LSSeatCategoryView.m
//  LaShouMovie
//
//  Created by Li XiangYu on 13-9-15.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSSeatCategoryView.h"

@implementation LSSeatCategoryView

@synthesize screenTitle=_screenTitle;

#pragma mark- 生命周期
- (void)dealloc
{
    self.screenTitle=nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [[UIImage lsImageNamed:@"seat_canbuy.png"] drawInRect:CGRectMake(2, 19, 16, 14)];
    [[UIImage lsImageNamed:@"seat_sold.png"] drawInRect:CGRectMake(76, 19, 16, 14)];
    [[UIImage lsImageNamed:@"seat_love.png"] drawInRect:CGRectMake(150, 19, 16, 14)];
    [[UIImage lsImageNamed:@"seat_my.png"] drawInRect:CGRectMake(224, 19, 16, 14)];
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);

    [@"可选座位" drawInRect:CGRectMake(20, 19, 56, 16) withFont:LSFont12 lineBreakMode:NSLineBreakByClipping];

    [@"已售座位" drawInRect:CGRectMake(94, 19, 56, 16) withFont:LSFont12 lineBreakMode:NSLineBreakByClipping];

    [@"情侣座位" drawInRect:CGRectMake(168, 19, 56, 16) withFont:LSFont12 lineBreakMode:NSLineBreakByClipping];

    [@"已选座位" drawInRect:CGRectMake(242, 19, 56, 16) withFont:LSFont12 lineBreakMode:NSLineBreakByClipping];
    
    if(_screenTitle)
    {
        [[UIImage stretchableImageWithImage:[UIImage lsImageNamed:@"seat_screen.png"] top:14 left:4 bottom:14 right:4]  drawInRect:CGRectMake(5, 41, 290, 28)];
        
        CGContextSetFillColorWithColor(contextRef, [UIColor redColor].CGColor);
        [_screenTitle drawInRect:CGRectMake(5, 47, 290, 16)  withFont:LSFont13 lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
    }
}


@end
