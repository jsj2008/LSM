//
//  LSQuickBuyView.m
//  LaShouMovie
//
//  Created by LiXiangYu on 14-1-3.
//  Copyright (c) 2014年 LiXiangYu. All rights reserved.
//

#import "LSQuickBuyView.h"

@implementation LSQuickBuyView

@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=LSColorNavigationRed;
        
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
    [[UIImage lsImageNamed:@"icon_quick_seat.png"] drawInRect:CGRectMake(28.f, 25.f, 16.f, 15.f)];
    NSString* text=@"订座";
    [text drawInRect:CGRectMake(0.f, 50.f, 70.f, 25.f) withAttributes:[LSAttribute attributeFont:LSFontButton color:LSColorWhite textAlignment:NSTextAlignmentCenter]];
}

#pragma mark- 私有方法
- (void)selfTap:(UITapGestureRecognizer*)recognizer
{
    [_delegate LSQuickBuyViewDidClick:self];
}

@end
