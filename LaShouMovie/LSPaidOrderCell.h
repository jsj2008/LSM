//
//  LSPaidOrderCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-29.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewCell.h"
#import "LSOrder.h"

@interface LSPaidOrderCell : LSTableViewCell
{
    LSOrder* _order;
}
@property(nonatomic,retain) LSOrder* order;

@end
