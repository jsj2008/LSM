//
//  LSSeatPlaceView.m
//  LaShouMovie
//
//  Created by Li XiangYu on 13-9-15.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSSeatPlaceView.h"

@implementation LSSeatPlaceView

@synthesize order=_order;
@synthesize delegate=_delegate;

#pragma mark- 生命周期
- (void)dealloc
{
    self.order=nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _seatsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 70, frame.size.width-20, frame.size.height-70)];
        _seatsScrollView.backgroundColor = [UIColor clearColor];
        _seatsScrollView.delegate = self;
        _seatsScrollView.scrollEnabled = NO;
        _seatsScrollView.bouncesZoom = NO;
        _seatsScrollView.showsVerticalScrollIndicator = NO;
        _seatsScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_seatsScrollView];
        [_seatsScrollView release];

        _rowNumberScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 70, 20, frame.size.height-70)];
        _rowNumberScrollView.backgroundColor = [UIColor clearColor];
        _rowNumberScrollView.delegate = self;
        _rowNumberScrollView.userInteractionEnabled = NO;
        _rowNumberScrollView.scrollEnabled = NO;
        _rowNumberScrollView.bouncesZoom = NO;
        _rowNumberScrollView.showsVerticalScrollIndicator = NO;
        _rowNumberScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_rowNumberScrollView];
        [_rowNumberScrollView release];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [[UIImage lsImageNamed:@""] drawInRect:CGRectMake(20.f, 0.f, 290.f, 20.f)];
    [[NSString stringWithFormat:@"%@%@屏幕方向",_order.cinema.cinemaName,_order.schedule.hall.hallName] drawInRect:CGRectMake(40.f, 0.f, 250.f, 20.f) withAttributes:[LSAttribute attributeFont:LSFontSectionHeader color:LSColorWhite textAlignment:NSTextAlignmentCenter]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if(_order.sectionArray)
    {
        [self showSeat];
    }
}

#pragma mark- 私有方法
- (void)showSeat
{
    [_seatMapView removeFromSuperview];
    [_rowNumberView removeFromSuperview];
    
    
    
    //此宽高为具有边界的宽高
    CGFloat seatAreaWidth=_seatsScrollView.width/(_order.section.columnNumber);
    CGFloat seatAreaHeight=_seatsScrollView.height/(_order.section.rowNumber);
    //取宽高中较小的值
    CGFloat basicAreaSide=0.f;//带边界的基本宽高
    CGFloat basicContentSide=0.f;//不带边界的基本宽高
    CGFloat basicPadding=0.f;//边界的基本值
    CGFloat paddingX=0.f;
    CGFloat paddingY=0.f;
    if(seatAreaWidth<seatAreaHeight)//以宽作为基础值
    {
        basicAreaSide=seatAreaWidth;
        basicPadding=basicAreaSide/(5*2);//两个边，一个边宽度为5
        basicContentSide=basicAreaSide-basicPadding*2;//去掉两个边就是图像显示的大小
        
        paddingY=(_seatsScrollView.height-_order.section.rowNumber*basicAreaSide)/2;
    }
    else//以高作为基础值
    {
        basicAreaSide=seatAreaHeight;
        basicPadding=basicAreaSide/(5*2);
        basicContentSide=basicAreaSide-basicPadding*2;
        
        paddingX=(_seatsScrollView.width-_order.section.columnNumber*basicAreaSide)/2;
    }
    
    //设置_seatsScrollView和_rowNumberScrollView
    CGFloat maximumZoomScale=0.f;
    _minimumZoomScale=0.f;
    if(basicAreaSide<40.f)
    {
        _minimumZoomScale = basicAreaSide/40.f;
        maximumZoomScale = 40.f/basicAreaSide;
    }
    else
    {
        _minimumZoomScale = 1.f;
        maximumZoomScale = 1.f;
    }
    _seatsScrollView.minimumZoomScale = _minimumZoomScale;
    _seatsScrollView.maximumZoomScale = 1.f;
    
    _rowNumberScrollView.minimumZoomScale = _minimumZoomScale;
    _rowNumberScrollView.maximumZoomScale = 1.f;
    
    
    //重置显示系数
    basicAreaSide=basicAreaSide*maximumZoomScale;
    basicPadding=basicPadding*maximumZoomScale;
    basicContentSide=basicContentSide*maximumZoomScale;
    paddingY=paddingY*maximumZoomScale;
    paddingX=paddingX*maximumZoomScale;
    
    
    _seatMapView=[[LSSeatMapView alloc] initWithFrame:CGRectMake(0, 0, _seatsScrollView.width*maximumZoomScale, _seatsScrollView.height*maximumZoomScale)];
    _seatMapView.backgroundColor=[UIColor clearColor];
    _seatMapView.section=_order.section;
    _seatMapView.delegate=self;
    _seatMapView.basicAreaSide=basicAreaSide;//带边界的基本宽高
    _seatMapView.basicContentSide=basicContentSide;//不带边界的基本宽高
    _seatMapView.basicPadding=basicPadding;//边界的基本值
    _seatMapView.paddingX=paddingX;
    _seatMapView.paddingY=paddingY;
    [_seatsScrollView addSubview:_seatMapView];
    [_seatMapView release];
    
    
    _rowNumberView=[[LSRowNumberView alloc] initWithFrame:CGRectMake(0, 0, _rowNumberScrollView.width*maximumZoomScale, _rowNumberScrollView.height*maximumZoomScale)];
    _rowNumberView.clipsToBounds=YES;
    _rowNumberView.rowIDArray=_order.section.rowIDArray;
    _rowNumberView.basicAreaSide=basicAreaSide;//带边界的基本宽高
    _rowNumberView.basicContentSide=basicContentSide;//不带边界的基本宽高
    _rowNumberView.basicPadding=basicPadding;//边界的基本值
    _rowNumberView.paddingY=paddingY;
    [_rowNumberScrollView addSubview:_rowNumberView];
    [_rowNumberView release];
    
    
    [_seatsScrollView setZoomScale:_minimumZoomScale animated:YES];
    [_rowNumberScrollView setZoomScale:_minimumZoomScale animated:YES];
}

#pragma mark- LSSeatMapView的委托方法
- (void)LSSeatMapView:(LSSeatMapView *)seatMapView didChangeSelectSeatArray:(NSArray *)selectSeatArray
{
    [_delegate LSSeatPlaceView:self didChangeSelectSeatArray:selectSeatArray];
}


#pragma mark- UIScrollView的委托方法
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (scrollView == _seatsScrollView)
    {
        return _seatMapView;
    }
    else if (scrollView == _rowNumberScrollView)
    {
        return _rowNumberView;
    }
    
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _seatsScrollView)
    {
        CGFloat spaceWidth = (_rowNumberScrollView.contentSize.width - _rowNumberScrollView.frame.size.width);
        CGFloat offsetX = (spaceWidth > 0 ? (spaceWidth / 2) : 0);
        _rowNumberScrollView.contentOffset = CGPointMake(offsetX, _seatsScrollView.contentOffset.y);
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if (scrollView == _seatsScrollView)
    {
        [_rowNumberScrollView setZoomScale:scrollView.zoomScale];
        
        CGFloat spaceWidth = (_rowNumberScrollView.contentSize.width - _rowNumberScrollView.frame.size.width);
        CGFloat offsetX = (spaceWidth > 0 ? (spaceWidth / 2) : 0);
        _rowNumberScrollView.contentOffset = CGPointMake(offsetX, _seatsScrollView.contentOffset.y);
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    if (scrollView == _seatsScrollView)
    {
        if (_seatsScrollView.zoomScale <= _minimumZoomScale)
        {
            _seatsScrollView.scrollEnabled = NO;
        }
        else
        {
            _seatsScrollView.scrollEnabled = YES;
        }
    }
}

@end
