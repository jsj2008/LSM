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
    CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);
    
    if (_timeout)
    {
        NSString* text = @"已超时";
        [text drawInRect:CGRectMake(0.f, 2.f, rect.size.width, rect.size.height-2*2) withFont:LSFontBold20 lineBreakMode:NSLineBreakByClipping  alignment:NSTextAlignmentCenter];
    }
    else
    {
        if(_minute>=0 && _second>=0)
        {
//            [[UIImage lsImageNamed:@"seat_line.png"] drawAtPoint:CGPointMake(0, rect.size.height/2)];
//            [[UIImage lsImageNamed:@"time_bg.png"] drawAtPoint:CGPointMake(rect.size.width/2-34, 2)];
//            [[UIImage lsImageNamed:@"time_bg.png"] drawAtPoint:CGPointMake(rect.size.width/2+4, 2)];
            CGContextDrawImage(contextRef, CGRectMake(0, rect.size.height/2, rect.size.width, 1), [UIImage lsImageNamed:@"seat_line.png"].CGImage);
            CGContextDrawImage(contextRef, CGRectMake(rect.size.width/2-34, 2, 30, 25), [UIImage lsImageNamed:@"time_bg.png"].CGImage);
            CGContextDrawImage(contextRef, CGRectMake(rect.size.width/2+4, 2, 30, 25), [UIImage lsImageNamed:@"time_bg.png"].CGImage);
//            [[UIImage lsImageNamed:@"seat_line.png"] drawInRect:CGRectMake(0, rect.size.height/2, rect.size.width, 1)];
//            [[UIImage lsImageNamed:@"time_bg.png"] drawInRect:CGRectMake(rect.size.width/2-34, 2, 30, 25)];
//            [[UIImage lsImageNamed:@"time_bg.png"] drawInRect:CGRectMake(rect.size.width/2+4, 2, 30, 25)];
            NSString* text = [NSString stringWithFormat:@"%02d : %02d",_minute,_second];
            [text drawInRect:CGRectMake(0, 2, rect.size.width, 25) withFont:LSFontBold20 lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
        }
        else
        {
            NSString* text = @"计时器错误";
            [text drawInRect:CGRectMake(0, 2, rect.size.width, rect.size.height-2*2) withFont:LSFontBold20 lineBreakMode:NSLineBreakByClipping  alignment:NSTextAlignmentCenter];
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
            if([_delegate respondsToSelector:@selector(LSCountDownViewDidTimeout)])
            {
                [_delegate LSCountDownViewDidTimeout];
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
