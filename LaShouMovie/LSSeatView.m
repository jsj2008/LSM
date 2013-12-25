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
            imageName = @"";
            break;
            
        case LSSeatStatusLove:
            imageName = @"";
            break;
            
        case LSSeatStatusSelect:
            imageName = @"";
            break;
            
        case LSSeatStatusSold:
            imageName = @"";
            break;
            
        default:
            break;
    }
    
    if (imageName!=nil)
    {
        [[UIImage lsImageNamed:imageName] drawInRect:CGRectMake(0.f, 0.f, rect.size.width, rect.size.height)];
    }
}


- (void)selfTap:(UITapGestureRecognizer*)recognizer
{
    if(_seat.originSeatStatus==LSSeatStatusSold || _seat.originSeatStatus==LSSeatStatusUnable)
    {
        return;
    }
    //如果原始状态是未选择类型，那么说明是本次的操作
    else if(_seat.originSeatStatus==LSSeatStatusNormal || _seat.originSeatStatus==LSSeatStatusLove)
    {
        if(_seat.seatStatus==_seat.originSeatStatus)
        {
            //未选择则选择
            _seat.seatStatus=LSSeatStatusSelect;
        }
        else if(_seat.seatStatus==LSSeatStatusSelect)
        {
            //已选择则取消选择
            _seat.seatStatus=_seat.originSeatStatus;
        }
        
        [_delegate LSSeatView:self didSelectAtSeat:_seat];
    }
}


@end
