//
//  LSGroupInfoCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-9.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSGroupPayCell : LSTableViewCell
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
