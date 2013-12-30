//
//  LSUnpayOrderCell.h
//  LaShouMovie
//
//  Created by Li XiangYu on 13-10-2.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewCell.h"
#import "LSOrder.h"

@interface LSUnpayOrderCell : LSTableViewCell
{
    LSOrder* _order;
}
@property(nonatomic,retain) LSOrder* order;

@end
