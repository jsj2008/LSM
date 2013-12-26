//
//  LSPayShouldPayCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-11-27.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewCell.h"
#import "LSOrder.h"

@interface LSPayShouldPayCell : LSTableViewCell
{
    LSOrder* _order;
}
@property (nonatomic,retain) LSOrder* order;

@end
