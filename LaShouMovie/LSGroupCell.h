//
//  LSGroupCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-9.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSGroupOrder.h"

@interface LSGroupCell : LSTableViewCell
{
    LSGroupOrder* _groupOrder;
}
@property(nonatomic,retain) LSGroupOrder* groupOrder;

+ (CGFloat)heightForGroupOrder:(LSGroupOrder*)groupOrder;

@end
