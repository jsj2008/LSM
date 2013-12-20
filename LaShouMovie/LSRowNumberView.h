//
//  LSRowNumberView.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-16.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSRowNumberView : UIView
{
    NSArray* _rowIDArray;
    
    //
    //以下参数为外部传入，用以设定整体的布局
    //
    CGFloat _basicAreaSide;//带边界的基本宽高
    CGFloat _basicContentSide;//不带边界的基本宽高
    CGFloat _basicPadding;//边界的基本值
    CGFloat _paddingY;
}
@property(nonatomic,retain) NSArray* rowIDArray;

@property(nonatomic,assign) CGFloat basicAreaSide;//带边界的基本宽高
@property(nonatomic,assign) CGFloat basicContentSide;//不带边界的基本宽高
@property(nonatomic,assign) CGFloat basicPadding;//边界的基本值
@property(nonatomic,assign) CGFloat paddingY;

@end
