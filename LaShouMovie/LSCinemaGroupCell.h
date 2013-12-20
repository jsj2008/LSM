//
//  LSCinemaGroupCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-13.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSGroup.h"

@interface LSCinemaGroupCell : LSTableViewCell
{
    LSGroup* _group;
}
@property(nonatomic,retain) LSGroup* group;

@end
