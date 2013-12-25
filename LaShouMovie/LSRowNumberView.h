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
    NSArray* _rowIDArray;//内部嵌套的冯区域的行ID数组 ,为了满足多个区域的情况
    
    //
    //以下参数为外部传入，用以设定整体的布局
    //
    CGFloat _paddingY;//纵向两头的间隔
    CGFloat _seatHeight;//高
    CGFloat _basicPaddingY;//两行间的间隔
    CGFloat _space;//两区域间的间隔
}
@property(nonatomic,retain) NSArray* rowIDArray;
@property(nonatomic,assign) CGFloat paddingY;
@property(nonatomic,assign) CGFloat seatHeight;
@property(nonatomic,assign) CGFloat basicPaddingY;
@property(nonatomic,assign) CGFloat space;

@end
