//
//  LSSwitchSectionHeader.h
//  LaShouMovie
//
//  Created by Li XiangYu on 13-9-15.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSSchedule.h"

@protocol LSSwitchSectionHeaderDelegate;
@interface LSSwitchSectionHeader : UIView
{
    LSSchedule* _schedule;
    BOOL _isSpread;//是否为展开状态
    id<LSSwitchSectionHeaderDelegate> _delegate;
}
@property(nonatomic,retain) LSSchedule* schedule;
@property(nonatomic,assign) BOOL isSpread;;
@property(nonatomic,assign) id<LSSwitchSectionHeaderDelegate> delegate;

@end

@protocol LSSwitchSectionHeaderDelegate <NSObject>

@required
- (void)LSSwitchSectionHeader:(LSSwitchSectionHeader*)switchSectionHeader isSpread:(BOOL)isSpread;

@end
