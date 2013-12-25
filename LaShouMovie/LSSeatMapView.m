//
//  LSSeatMapView.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-16.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSSeatMapView.h"
#import "LSSection.h"

@implementation LSSeatMapView

@synthesize order=_order;
@synthesize delegate=_delegate;

@synthesize seatHeight=_seatHeight;
@synthesize seatWidth=_seatWidth;
@synthesize basicPadding=_basicPadding;
@synthesize paddingX=_paddingX;
@synthesize paddingY=_paddingY;
@synthesize space=_space;

#pragma mark- 生命周期
- (void)dealloc
{
    self.order=nil;
    LSRELEASE(_selectSeatMArray)
    LSRELEASE(_selectSeatArrayMDic)
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _selectSeatMArray=[[NSMutableArray alloc] initWithCapacity:0];
        _selectSeatArrayMDic=[[NSMutableDictionary alloc] initWithCapacity:0];
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
    
    for(LSSection* section in _order.sectionArray)
    {
        for (LSSeat* seat in section.seatArray)
        {
            //座位的视图坐标是从1开始的
            positionX=_paddingX+(_seatWidth+_basicPadding)*(seat.columnID-1);
            positionY=_paddingY+(_seatHeight+_basicPadding)*(seat.rowID-1);
            
            LSSeatView* seatView=[[LSSeatView alloc] initWithFrame:CGRectMake(positionX, positionY, _seatWidth, _seatHeight)];
            seatView.seat=seat;
            seatView.delegate=self;
            [self addSubview:seatView];
            [seatView release];
        }
        
        //最后一行是不加行间距的
        _paddingY+=(_seatWidth+_basicPadding)*section.rowNumber-_basicPadding;
        //强制增加纵向高度
        _paddingY+=_space;
    }
}


#pragma mark- LSSeatView的委托方法
- (void)LSSeatView:(LSSeatView *)seatView didSelectAtSeat:(LSSeat *)seat
{
    if(seat.type==LSSeatTypeNormal)
    {
        if([_selectSeatMArray containsObject:seat])
        {
            [[_selectSeatArrayMDic objectForKey:seat.sectionID] removeObject:seat];
            [_selectSeatMArray removeObject:seat];
        }
        else
        {
            if(_selectSeatMArray.count==_order.maxTicketNumber)
            {
                seat.seatStatus=seat.originSeatStatus;
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [seatView setNeedsDisplay];
                });
                [_delegate LSSeatMapView:self didChangeSelectSeatArrayDic:nil];
            }
            else
            {
                if([_selectSeatArrayMDic objectForKey:seat.sectionID]==NULL)
                {
                    [_selectSeatArrayMDic setObject:[NSMutableArray arrayWithCapacity:0] forKey:seat.sectionID];
                }
                
                NSMutableArray* selectSeatMArray=[_selectSeatArrayMDic objectForKey:seat.sectionID];
                [selectSeatMArray addObject:seat];
                [selectSeatMArray sortUsingSelector:@selector(sortByColumnID:)];
                
                [_selectSeatMArray addObject:seat];
            }
        }
    }
    else//选择的情侣座
    {
        //查找当前的座位到底属于哪个区域
        LSSection* _section=nil;
        for(LSSection* seaction in _order.sectionArray)
        {
            if([seaction.sectionID isEqualToString:seat.sectionID])
            {
                _section=seaction;
                break;
            }
        }
        
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
    
    [_delegate LSSeatMapView:self didChangeSelectSeatArrayDic:_selectSeatArrayMDic];
}

- (void)changeAnotherSeatView:(LSSeatView *)seatView seat:(LSSeat *)seat anotherSeat:(LSSeat *)anotherSeat
{
    if([_selectSeatMArray containsObject:seat])
    {
        anotherSeat.seatStatus=anotherSeat.originSeatStatus;
        [self tapAnotherSeatView:anotherSeat];
        
        [[_selectSeatArrayMDic objectForKey:seat.sectionID] removeObject:seat];
        [[_selectSeatArrayMDic objectForKey:seat.sectionID] removeObject:anotherSeat];
        
        [_selectSeatMArray removeObject:seat];
        [_selectSeatMArray removeObject:anotherSeat];
    }
    else
    {
        if(_selectSeatMArray.count==_order.maxTicketNumber || _selectSeatMArray.count==_order.maxTicketNumber-1)
        {
            seat.seatStatus=seat.originSeatStatus;
            dispatch_async(dispatch_get_main_queue(), ^{

                [seatView setNeedsDisplay];
            });
            [_delegate LSSeatMapView:self didChangeSelectSeatArrayDic:nil];
        }
        else
        {
            anotherSeat.seatStatus=LSSeatStatusSelect;
            [self tapAnotherSeatView:anotherSeat];
            
            if([_selectSeatArrayMDic objectForKey:seat.sectionID]==NULL)
            {
                [_selectSeatArrayMDic setObject:[NSMutableArray arrayWithCapacity:0] forKey:seat.sectionID];
            }
            
            NSMutableArray* selectSeatMArray=[_selectSeatArrayMDic objectForKey:seat.sectionID];
            [selectSeatMArray addObject:seat];
            [selectSeatMArray addObject:anotherSeat];
            [selectSeatMArray sortUsingSelector:@selector(sortByColumnID:)];
            
            [_selectSeatMArray addObject:seat];
            [_selectSeatMArray addObject:anotherSeat];
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
                break;
            }
        }
    });
    dispatch_release(queue_0);
}

@end
