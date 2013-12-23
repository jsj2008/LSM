//
//  LSCinemaInfoGroupCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-12.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewCell.h"
#import "LSGroup.h"

@interface LSCinemaInfoGroupCell : LSTableViewCell
{
    UIImageView* _iconImageView;
    NSString* _title;
    CGFloat _topRadius;
    CGFloat _bottomRadius;
    BOOL _isBottomLine;
}
@property(nonatomic,retain) UIImageView* iconImageView;
@property(nonatomic,retain) NSString* title;
@property(nonatomic,assign) CGFloat topRadius;
@property(nonatomic,assign) CGFloat bottomRadius;
@property(nonatomic,assign) BOOL isBottomLine;//是否显示下方的线条

@end
