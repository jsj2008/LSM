//
//  LSSwitchScheduleCell.h
//  LaShouMovie
//
//  Created by Li XiangYu on 13-9-15.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewCell.h"
#import "LSSchedule.h"

@interface LSSwitchScheduleCell : LSTableViewCell
{
    LSSchedule* _schedule;
    BOOL _isInitial;//是否高亮
}
@property(nonatomic,retain) LSSchedule* schedule;
@property(nonatomic,assign) BOOL isInitial;

@end
