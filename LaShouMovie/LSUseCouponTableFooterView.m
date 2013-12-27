//
//  LSCouponTableFooterView.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-27.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSUseCouponTableFooterView.h"

@implementation LSUseCouponTableFooterView

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
    NSString* info=@"说明:\n1.通兑券每个座位限用1张，个别限价影片需要补差价。\n2.限价片是指影片发行方或相关部门对于某些热门影片设置了最低票价，任何渠道的售价都不得低于该价格。\n3.代金券可使用多张，金额超出部分不设找赎。";
    
    [info drawInRect:CGRectMake(10.f, 10.f, rect.size.width-20.f, rect.size.width-20.f) withAttributes:[LSAttribute attributeFont:LSFontCouponSubtitle]];
}

@end
