//
//  LSSeatPlaceView.h
//  LaShouMovie
//
//  Created by Li XiangYu on 13-9-15.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSOrder.h"
#import "LSSection.h"
#import "LSRowNumberView.h"
#import "LSSeatMapView.h"

@protocol LSSeatPlaceViewDelegate;
@interface LSSeatPlaceView : UIView<UIScrollViewDelegate,LSSeatMapViewDelegate>
{
    UIScrollView* _rowNumberScrollView;//显示行数
    UIScrollView* _seatsScrollView;//显示区域
    
    LSRowNumberView* _rowNumberView;
    LSSeatMapView* _seatMapView;
    
    CGFloat _minZoom;//最小缩放比
    CGFloat _maxZoom;//最小缩放比
    
    LSOrder* _order;
    id<LSSeatPlaceViewDelegate> _delegate;
}

@property(nonatomic,retain) LSOrder* order;
@property(nonatomic,assign) id<LSSeatPlaceViewDelegate> delegate;

@end

@protocol LSSeatPlaceViewDelegate <NSObject>

@required
- (void)LSSeatPlaceView:(LSSeatPlaceView*)seatPlaceView didChangeSelectSeatArrayDic:(NSDictionary *)selectSeatArrayDic;

@end
