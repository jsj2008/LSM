//
//  LSShareSettingCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-8.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSShareSettingCell : LSTableViewCell
{
    CGFloat _topRadius;
    CGFloat _bottomRadius;
    
    CGFloat _topMargin;
    BOOL _isBottomLine;
    
    UILabel* _statusLabel;
}
@property(nonatomic,assign) CGFloat topRadius;
@property(nonatomic,assign) CGFloat bottomRadius;
@property(nonatomic,assign) CGFloat topMargin;
@property(nonatomic,assign) BOOL isBottomLine;
@property(nonatomic,retain) UILabel* statusLabel;

@end
