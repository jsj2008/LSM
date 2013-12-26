//
//  LSCountDownView.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-26.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSCountDownView.h"

@implementation LSCountDownView

@synthesize minute=_minute;
@synthesize second=_second;
@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=LSColorNavigationRed;
        _minute=-1;
        _second=-1;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    if (_timeout)
    {
        NSString* text = @"已超时";
        [text drawInRect:rect withAttributes:[LSAttribute attributeFont:LSFontPayTime color:LSColorWhite textAlignment:NSTextAlignmentCenter]];
    }
    else
    {
        if(_minute>=0 && _second>=0)
        {
            NSString* text = [NSString stringWithFormat:@"支付剩余时间：%02d分%02d",_minute,_second];
            [text drawInRect:rect withAttributes:[LSAttribute attributeFont:LSFontPayTime color:LSColorWhite textAlignment:NSTextAlignmentCenter]];
        }
        else
        {
            NSString* text = @"计时器错误";
            [text drawInRect:rect withAttributes:[LSAttribute attributeFont:LSFontPayTime color:LSColorWhite textAlignment:NSTextAlignmentCenter]];
        }
    }
}

#pragma mark- 计时相关
- (void)startCountDown
{
    [self stopCountDown];
    _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerGoing) userInfo:nil repeats:YES];
    LSLOG(@"计时器启动");
}

- (void)stopCountDown
{
    if(_timer!=nil && _timer.isValid)
    {
        [_timer invalidate];
        _timer=nil;
        LSLOG(@"计时器销毁");
    }
}

#pragma mark- 私有方法
- (void)timerGoing
{
    _second--;
    if(_second<0)
    {
        _minute--;
        if(_minute<0)
        {
            _timeout=YES;
            [self stopCountDown];
            [_delegate LSCountDownViewDidTimeout];
        }
        else
        {
            _second=59;
        }
    }
    [self setNeedsDisplay];
}

@end
