//
//  LSSimpleCountDownView.m
//  LaShouMovie
//
//  Created by Li XiangYu on 13-10-3.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSSimpleCountDownView.h"

@implementation LSSimpleCountDownView
@synthesize minute=_minute;
@synthesize second=_second;
@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
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
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextRef, [UIColor whiteColor].CGColor);
    
    if (_timeout)
    {
        NSString* text = @"已超时";
        [text drawInRect:CGRectMake(0, 0, rect.size.width, rect.size.height) withFont:LSFontBold18 lineBreakMode:NSLineBreakByClipping  alignment:NSTextAlignmentCenter];
    }
    else
    {
        if(_minute>=0 && _second>=0)
        {
            NSString* text = [NSString stringWithFormat:@"%02d:%02d",_minute,_second];
            [text drawInRect:CGRectMake(0, 0, rect.size.width, rect.size.height) withFont:LSFontBold18 lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
        }
        else
        {
            NSString* text = @"错误";
            [text drawInRect:CGRectMake(0, 0, rect.size.width, rect.size.height) withFont:LSFontBold18 lineBreakMode:NSLineBreakByClipping  alignment:NSTextAlignmentCenter];
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
    if(_timer && _timer.isValid)
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
            if([_delegate respondsToSelector:@selector(LSSimpleCountDownViewDidTimeout)])
            {
                [_delegate LSSimpleCountDownViewDidTimeout];
            }
        }
        else
        {
            _second=59;
        }
    }
    [self setNeedsDisplay];
}

@end
