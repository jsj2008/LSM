//
//  LSPayWayCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-26.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewCell.h"
#import "LSPayWay.h"

@interface LSPayWayCell : LSTableViewCell
{
    UIImageView* _selectImageView;
    LSPayWay* _payWay;
    BOOL _isInitial;
}
@property(nonatomic,retain) LSPayWay* payWay;
@property(nonatomic,assign) BOOL isInitial;

@end
