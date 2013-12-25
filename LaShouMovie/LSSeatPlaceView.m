//
//  LSSeatPlaceView.m
//  LaShouMovie
//
//  Created by Li XiangYu on 13-9-15.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSSeatPlaceView.h"
#define LSSeatHeightMin    15.f
#define LSSeatWidthMin     17.f
#define LSSeatHeightMax    38.f
#define LSSeatWidthMax     43.f
#define LSSeatBasicPadding 8.f
#define LSSeatSectionSpace 45.f
#define LSSeatBa 45.f
#define LSSeatSectionSpace 45.f

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
        _seatsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10.f, 20.f, frame.size.width-10.f, frame.size.height-20.f)];
        _seatsScrollView.delegate = self;
        _seatsScrollView.scrollEnabled = NO;
        _seatsScrollView.bouncesZoom = YES;
        _seatsScrollView.showsVerticalScrollIndicator = NO;
        _seatsScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_seatsScrollView];
        [_seatsScrollView release];

        _rowNumberScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.f, 20.f, 10.f, frame.size.height-30.f)];
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
    
    //计算最大和最小缩放比
    _maxZoom=(LSSeatWidthMax/LSSeatWidthMin+LSSeatHeightMax/LSSeatHeightMin)/2;
    _minZoom=(LSSeatWidthMin/LSSeatWidthMax+LSSeatHeightMin/LSSeatHeightMax)/2;
    
    //最终进行传递的作为宽和高
    CGFloat seatWidth=LSSeatWidthMin;
    CGFloat seatHeight=LSSeatHeightMin;
    CGFloat paddingX=0.f;
    CGFloat paddingY=0.f;

    //获取所有区域的最大行数和最大列数
    float maxColumn=0;
    int maxRow=0;
    for(LSSection* section in _order.sectionArray)
    {
        if(maxColumn<section.columnNumber)
        {
            maxColumn=section.columnNumber;
        }
        if(maxRow<section.rowNumber)
        {
            maxRow+=section.rowNumber;
        }
    }
    //计算最大行数对应的最小行高和最大列数对应的最小列宽
    //如果有一个最小值比预设的最大值还要大，这时候就按照预设最大值来布局座位
    float minWidth=(_seatsScrollView.width+LSSeatBasicPadding)/maxColumn-LSSeatBasicPadding;
    float minHeight=(_seatsScrollView.height-(_order.sectionArray.count-1)*LSSeatSectionSpace+LSSeatBasicPadding)/maxRow-LSSeatBasicPadding;
    if(minHeight>=LSSeatHeightMax || minWidth>=LSSeatWidthMax)
    {
        seatWidth=LSSeatWidthMax;
        seatWidth=LSSeatHeightMax;
        _maxZoom=1.f;
        _minZoom=1.f;
    }
    
    //计算动态的横向与纵向边界
    paddingX=(_seatsScrollView.width*_maxZoom-(seatWidth+LSSeatBasicPadding)*maxColumn+LSSeatBasicPadding)/2;
    paddingX=paddingX>0?paddingX:0.f;
    paddingY=(_seatsScrollView.height*_maxZoom-(_order.sectionArray.count-1)*LSSeatSectionSpace-(seatHeight+LSSeatBasicPadding)*maxRow+LSSeatBasicPadding)/2;
    paddingY=paddingY>0?paddingY:0.f;
    
    //生成视图
    _seatMapView=[[LSSeatMapView alloc] initWithFrame:CGRectMake(0.f, 0.f, (seatWidth+LSSeatBasicPadding)*maxColumn-LSSeatBasicPadding+2*paddingX, (_order.sectionArray.count-1)*LSSeatSectionSpace+(seatHeight+LSSeatBasicPadding)*maxRow-LSSeatBasicPadding+2*paddingY)];
    _seatMapView.order=_order;
    _seatMapView.delegate=self;
    _seatMapView.seatWidth=seatWidth;
    _seatMapView.seatHeight=seatHeight;
    _seatMapView.basicPadding=LSSeatBasicPadding;
    _seatMapView.paddingX=paddingX;
    _seatMapView.paddingY=paddingY;
    _seatMapView.space=LSSeatSectionSpace;
    [_seatsScrollView addSubview:_seatMapView];
    [_seatMapView release];
    
    
    _rowNumberView=[[LSRowNumberView alloc] initWithFrame:CGRectMake(0.f, 0.f, _rowNumberScrollView.width, (_order.sectionArray.count-1)*LSSeatSectionSpace+(seatHeight+LSSeatBasicPadding)*maxRow-LSSeatBasicPadding+2*paddingY)];
    _rowNumberView.rowIDArray=_order.rowIDArray;
    _rowNumberView.seatHeight=seatHeight*_minZoom;
    _rowNumberView.basicPaddingY=LSSeatBasicPadding*_minZoom;
    _rowNumberView.paddingY=paddingY*_minZoom;
    _rowNumberView.space=LSSeatSectionSpace*_minZoom;
    [_rowNumberScrollView addSubview:_rowNumberView];
    [_rowNumberView release];
    
    //因为需要保证_rowNumberView中的字体不会变化，因此_rowNumberView并不参与缩放
    [_seatsScrollView setZoomScale:_minZoom animated:YES];
}

#pragma mark- LSSeatMapView的委托方法
- (void)LSSeatMapView:(LSSeatMapView *)seatMapView didChangeSelectSeatArrayDic:(NSDictionary *)selectSeatArrayDic
{
    [_delegate LSSeatPlaceView:self didChangeSelectSeatArrayDic:selectSeatArrayDic];
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
        _rowNumberScrollView.contentOffset = CGPointMake(0.f, _seatsScrollView.contentOffset.y);
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if (scrollView == _seatsScrollView)
    {
        _rowNumberView.height=_rowNumberView.height*_seatsScrollView.zoomScale;
        _rowNumberView.seatHeight=_rowNumberView.seatHeight*_seatsScrollView.zoomScale;
        _rowNumberView.basicPaddingY=_rowNumberView.basicPaddingY*_seatsScrollView.zoomScale;
        _rowNumberView.paddingY=_rowNumberView.paddingY*_seatsScrollView.zoomScale;
        _rowNumberView.space=_rowNumberView.space*_seatsScrollView.zoomScale;
        [_rowNumberView setNeedsDisplay];
        _rowNumberScrollView.contentOffset = CGPointMake(0.f, _seatsScrollView.contentOffset.y);
    }
}

@end
