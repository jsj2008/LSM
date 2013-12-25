//
//  LSSeatMapView.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-16.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSSeatView.h"
#import "LSOrder.h"

@protocol LSSeatMapViewDelegate;
@interface LSSeatMapView : UIView<LSSeatViewDelegate>
{
    LSOrder* _order;
    NSMutableArray* _selectSeatMArray;//用于简化一些操作
    NSMutableDictionary* _selectSeatArrayMDic;//真正的对外的数据
    
    //
    //以下参数在计算完成以后将被LSRowNumberView直接使用，所以需要设置为属性变量
    //
    CGFloat _seatHeight;//高
    CGFloat _seatWidth;//宽
    CGFloat _basicPadding;//两列间的间隔
    CGFloat _paddingX;//横向两头的间隔
    CGFloat _paddingY;//纵向两头的间隔
    CGFloat _space;//纵向两头的间隔
    id<LSSeatMapViewDelegate> _delegate;
}

@property(nonatomic,retain) LSOrder* order;
@property(nonatomic,assign) id<LSSeatMapViewDelegate> delegate;

@property(nonatomic,assign) CGFloat seatHeight;
@property(nonatomic,assign) CGFloat seatWidth;
@property(nonatomic,assign) CGFloat basicPadding;
@property(nonatomic,assign) CGFloat paddingX;
@property(nonatomic,assign) CGFloat paddingY;
@property(nonatomic,assign) CGFloat space;

@end

@protocol LSSeatMapViewDelegate <NSObject>

@required
- (void)LSSeatMapView:(LSSeatMapView*)seatMapView didChangeSelectSeatArrayDic:(NSDictionary*)selectSeatArrayDic;

@end
