//
//  LSConfirmButtonView.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-24.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSConfirmButtonView.h"
#define gap 10.f

@implementation LSConfirmButtonView

@synthesize price=_price;
@synthesize delegate=_delegate;

- (void)dealloc
{
    self.price=nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.cornerRadius=3.f;
        self.backgroundColor=LSColorButtonNormalRed;
        
        UITapGestureRecognizer* tapGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfTap:)];
        [self addGestureRecognizer:tapGestureRecognizer];
        [tapGestureRecognizer release];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGRect priceRect=[_price boundingRectWithSize:CGSizeMake(50.f, INT32_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[LSAttribute attributeFont:LSFontSchedulePrice] context:nil];
    [_price drawInRect:CGRectMake(20.f, (rect.size.height-priceRect.size.height)/2, priceRect.size.width, priceRect.size.height) withAttributes:[LSAttribute attributeFont:LSFontSchedulePrice color:LSColorWhite]];
    
    CGRect yRect=[@"￥" boundingRectWithSize:CGSizeMake(10.f, INT32_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[LSAttribute attributeFont:LSFontScheduleY] context:nil];
    [@"￥" drawInRect:CGRectMake(10.f, (rect.size.height-yRect.size.height)/2+(yRect.size.height-priceRect.size.height)/2, yRect.size.width, yRect.size.height) withAttributes:[LSAttribute attributeFont:LSFontScheduleY color:LSColorWhite]];
    
    CGRect buyRect=[@"购买" boundingRectWithSize:CGSizeMake(40.f, INT32_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[LSAttribute attributeFont:LSFontScheduleTitle] context:nil];
    [@"购买" drawInRect:CGRectMake(70.f, (rect.size.height-buyRect.size.height)/2+(buyRect.size.height-priceRect.size.height)/2, buyRect.size.width, buyRect.size.height) withAttributes:[LSAttribute attributeFont:LSFontScheduleTitle color:LSColorWhite textAlignment:NSTextAlignmentCenter]];
}

#pragma mark- 私有方法
- (void)selfTap:(UITapGestureRecognizer*)recognizer
{
    [_delegate LSConfirmButtonViewDidClick];
}

@end
