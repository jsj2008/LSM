//
//  LSGroupCreateOrderCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-11.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewCell.h"

@interface LSGroupCreateOrderCell : LSTableViewCell
{
    CGFloat _topRadius;
    CGFloat _bottomRadius;
    BOOL _isBottomLine;
    
    UILabel* _infoLabel;
}
@property(nonatomic,assign) CGFloat topRadius;
@property(nonatomic,assign) CGFloat bottomRadius;
@property(nonatomic,assign) BOOL isBottomLine;
@property(nonatomic,retain) UILabel* infoLabel;

@end
