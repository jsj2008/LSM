//
//  LSCinemaInfoScheduleCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-12.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSSchedule.h"

@interface LSCinemaInfoScheduleCell : LSTableViewCell
{
    LSSchedule* _schedule;
}
@property(nonatomic,retain) LSSchedule* schedule;

@end
