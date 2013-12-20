//
//  LSSeatMapView.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-16.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSSeatMapView.h"

@implementation LSSeatMapView

@synthesize section=_section;
@synthesize delegate=_delegate;

@synthesize basicAreaSide=_basicAreaSide;//带边界的基本宽高
@synthesize basicContentSide=_basicContentSide;//不带边界的基本宽高
@synthesize basicPadding=_basicPadding;//边界的基本值
@synthesize paddingX=_paddingX;
@synthesize paddingY=_paddingY;

#pragma mark- 生命周期
- (void)dealloc
{
    self.section=nil;
    LSRELEASE(_selectSeatArray)
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _selectSeatArray=[[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat positionX=0.f;
    CGFloat positionY=0.f;
    for (LSSeat* seat in _section.seatArray)
    {
//        positionX=_paddingX+_basicAreaSide*(seat.columnID-1)+_basicPadding;
//        positionY=_paddingY+_basicAreaSide*(seat.rowID-1)+_basicPadding;
//        
//        LSSeatView* seatView=[[LSSeatView alloc] initWithFrame:CGRectMake(positionX, positionY, _basicContentSide, _basicContentSide)];
//        seatView.seat=seat;
//        seatView.delegate=self;
//        [self addSubview:seatView];
//        [seatView release];
        
        positionX=_paddingX+_basicAreaSide*(seat.columnID-1);
        positionY=_paddingY+_basicAreaSide*(seat.rowID-1);
        
        LSSeatView* seatView=[[LSSeatView alloc] initWithFrame:CGRectMake(positionX, positionY, _basicAreaSide, _basicAreaSide)];
        seatView.seat=seat;
        seatView.delegate=self;
        [self addSubview:seatView];
        [seatView release];
    }
}


#pragma mark- LSSeatView的委托方法
- (void)LSSeatView:(LSSeatView *)seatView didSelectAtSeat:(LSSeat *)seat
{
    if(seat.type==LSSeatTypeNormal)
    {
        if([_selectSeatArray containsObject:seat])
        {
            [_selectSeatArray removeObject:seat];
        }
        else
        {
            if(_selectSeatArray.count==_section.maxTicketNumber)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    seat.seatStatus=seat.originSeatStatus;
                    [seatView setNeedsDisplay];
                });
                
                [_delegate LSSeatMapView:self didChangeSelectSeatArray:nil];
            }
            else
            {
                [_selectSeatArray addObject:seat];
                [_selectSeatArray sortUsingSelector:@selector(sortByColumnID:)];
            }
        }
    }
    else
    {
        LSSeat* leftSeat=[[_section.seatDictionary objectForKey:[NSNumber numberWithInt:seat.rowID]] objectForKey:[NSNumber numberWithFloat:seat.columnID-1]];
        LSSeat* rightSeat=[[_section.seatDictionary objectForKey:[NSNumber numberWithInt:seat.rowID]] objectForKey:[NSNumber numberWithFloat:seat.columnID+1]];
        
        if(seat.type==LSSeatTypeLoveFirst)
        {
            if(rightSeat.type==LSSeatTypeLoveSecond)
            {
                [self changeAnotherSeatView:seatView seat:seat anotherSeat:rightSeat];
            }
            else if(leftSeat.type==LSSeatTypeLoveSecond)
            {
                [self changeAnotherSeatView:seatView seat:seat anotherSeat:leftSeat];
            }
        }
        else
        {
            if(rightSeat.type==LSSeatTypeLoveFirst)
            {
                [self changeAnotherSeatView:seatView seat:seat anotherSeat:rightSeat];
            }
            else if(leftSeat.type==LSSeatTypeLoveFirst)
            {
                [self changeAnotherSeatView:seatView seat:seat anotherSeat:leftSeat];
            }
        }
    }
    
    [_delegate LSSeatMapView:self didChangeSelectSeatArray:_selectSeatArray];
}

- (void)changeAnotherSeatView:(LSSeatView *)seatView seat:(LSSeat *)seat anotherSeat:(LSSeat *)anotherSeat
{
    if([_selectSeatArray containsObject:seat])
    {
        [_selectSeatArray removeObject:seat];
        anotherSeat.seatStatus=anotherSeat.originSeatStatus;
        [self tapAnotherSeatView:anotherSeat];
        [_selectSeatArray removeObject:anotherSeat];
    }
    else
    {
        if(_selectSeatArray.count==_section.maxTicketNumber || _selectSeatArray.count==_section.maxTicketNumber-1)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                seat.seatStatus=seat.originSeatStatus;
                [seatView setNeedsDisplay];
            });
            
            [_delegate LSSeatMapView:self didChangeSelectSeatArray:nil];
        }
        else
        {
            [_selectSeatArray addObject:seat];
            anotherSeat.seatStatus=LSSeatStatusSelect;
            [self tapAnotherSeatView:anotherSeat];
            [_selectSeatArray addObject:anotherSeat];
            [_selectSeatArray sortUsingSelector:@selector(sortByColumnID:)];
        }
    }
}

- (void)tapAnotherSeatView:(LSSeat *)seat
{
    dispatch_queue_t queue_0=dispatch_queue_create("queue_0", NULL);
    dispatch_async(queue_0, ^{
        
        for(LSSeatView* seatView in self.subviews)
        {
            if([seatView.seat isEqual:seat])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [seatView setNeedsDisplay];
                });
            }
        }
    });
    dispatch_release(queue_0);
}

@end
