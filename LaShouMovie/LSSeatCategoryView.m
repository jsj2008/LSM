//
//  LSSeatCategoryView.m
//  LaShouMovie
//
//  Created by Li XiangYu on 13-9-15.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSSeatCategoryView.h"

@implementation LSSeatCategoryView

#pragma mark- 生命周期
- (void)dealloc
{
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=LSColorBackgroundGray;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [[UIImage lsImageNamed:@""] drawInRect:CGRectMake(10.f, 5.f, 15.f, 15.f)];
    [@"可选座位" drawInRect:CGRectMake(25.f, 5.f, 60.f, 15.f) withAttributes:[LSAttribute attributeFont:LSFontSeatCategory color:LSColorTextGray]];
    [[UIImage lsImageNamed:@""] drawInRect:CGRectMake(85.f, 5.f, 15.f, 15.f)];
    [@"已售座位" drawInRect:CGRectMake(100.f, 5.f, 60.f, 15.f) withAttributes:[LSAttribute attributeFont:LSFontSeatCategory color:LSColorTextGray]];
    [[UIImage lsImageNamed:@""] drawInRect:CGRectMake(160.f, 5.f, 15.f, 15.f)];
    [@"情侣座位" drawInRect:CGRectMake(175.f, 5.f, 60.f, 15.f) withAttributes:[LSAttribute attributeFont:LSFontSeatCategory color:LSColorTextGray]];
    [[UIImage lsImageNamed:@""] drawInRect:CGRectMake(235.f, 5.f, 15.f, 15.f)];
    [@"已选座位" drawInRect:CGRectMake(250.f, 5.f, 60.f, 15.f) withAttributes:[LSAttribute attributeFont:LSFontSeatCategory color:LSColorTextGray]];
}


@end
