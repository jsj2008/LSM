//
//  LSSeatView.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-16.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSSeatView.h"

@implementation LSSeatView

@synthesize seat=_seat;
@synthesize delegate=_delegate;

#pragma mark- 生命周期
- (void)dealloc
{
    self.seat=nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        
        UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfTap:)];
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
    NSString* imageName = nil;
    switch (_seat.seatStatus)
    {
        case LSSeatStatusNormal:
            imageName = @"seat_canbuy.png";
            break;
            
        case LSSeatStatusLove:
            imageName = @"seat_love.png";
            break;
            
        case LSSeatStatusSelect:
            imageName = @"seat_my.png";
            break;
            
        case LSSeatStatusSold:
            imageName = @"seat_sold.png";
            break;
            
        default:
            break;
    }
    
    if (imageName!=nil)
    {
        [[UIImage lsImageNamed:imageName] drawInRect:CGRectMake(5.f, 5.f, rect.size.width-10.f, rect.size.height-10.f)];
    }
}


- (void)selfTap:(UITapGestureRecognizer*)recognizer
{
    [self setNeedsDisplay];
    
    if(_seat.originSeatStatus==LSSeatStatusSold || _seat.originSeatStatus==LSSeatStatusUnable)
    {
        return;
    }
    else if(_seat.originSeatStatus==LSSeatStatusNormal || _seat.originSeatStatus==LSSeatStatusLove)//说明是原本状态
    {
        if(_seat.seatStatus==_seat.originSeatStatus)//说明是原本状态
        {
            _seat.seatStatus=LSSeatStatusSelect;
        }
        else if(_seat.seatStatus==LSSeatStatusSelect)
        {
            _seat.seatStatus=_seat.originSeatStatus;
        }
        
        dispatch_queue_t queue_0=dispatch_queue_create("queue_0", NULL);
        dispatch_async(queue_0, ^{
            
            [_delegate LSSeatView:self didSelectAtSeat:_seat];
        });
        dispatch_release(queue_0);
    }
}


@end
