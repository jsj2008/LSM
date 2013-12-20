//
//  LSPayNeedPayCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-11-27.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSOrder.h"

@interface LSPayNeedPayCell : LSTableViewCell
{
    LSOrder* _order;
}
@property (nonatomic,retain) LSOrder* order;

@end
