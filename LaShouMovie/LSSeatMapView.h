//
//  LSSeatMapView.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-16.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSSeatView.h"
#import "LSSection.h"

@protocol LSSeatMapViewDelegate;
@interface LSSeatMapView : UIView<LSSeatViewDelegate>
{
    LSSection* _section;
    NSMutableArray* _selectSeatArray;
    
    //
    //以下参数在计算完成以后将被LSRowNumberView直接使用，所以需要设置为属性变量
    //
    CGFloat _basicAreaSide;//带边界的基本宽高
    CGFloat _basicContentSide;//不带边界的基本宽高
    CGFloat _basicPadding;//边界的基本值
    CGFloat _paddingX;
    CGFloat _paddingY;
    
    id<LSSeatMapViewDelegate> _delegate;
}

@property(nonatomic,retain) LSSection* section;
@property(nonatomic,assign) id<LSSeatMapViewDelegate> delegate;

@property(nonatomic,assign) CGFloat basicAreaSide;//带边界的基本宽高
@property(nonatomic,assign) CGFloat basicContentSide;//不带边界的基本宽高
@property(nonatomic,assign) CGFloat basicPadding;//边界的基本值
@property(nonatomic,assign) CGFloat paddingX;
@property(nonatomic,assign) CGFloat paddingY;

@end

@protocol LSSeatMapViewDelegate <NSObject>

@required
- (void)LSSeatMapView:(LSSeatMapView*)seatMapView didChangeSelectSeatArray:(NSArray*)selectSeatArray;

@end
