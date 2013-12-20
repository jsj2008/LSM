//
//  LSSettingCell.h
//  LaShouMovie
//
//  Created by Li XiangYu on 13-10-4.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSSettingCell : LSTableViewCell
{
    CGFloat _topRadius;
    CGFloat _bottomRadius;
    
    CGFloat _topMargin;
    BOOL _isBottomLine;
}
@property(nonatomic,assign) CGFloat topRadius;
@property(nonatomic,assign) CGFloat bottomRadius;
@property(nonatomic,assign) CGFloat topMargin;
@property(nonatomic,assign) BOOL isBottomLine;//是否显示下方的线条

@end
