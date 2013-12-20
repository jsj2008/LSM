//
//  LSSwitchScheduleView.h
//  LaShouMovie
//
//  Created by Li XiangYu on 13-9-15.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSSwitchSectionHeader.h"

@protocol LSSwitchScheduleViewDelegate;
@interface LSSwitchScheduleView : UIView<UITableViewDelegate,UITableViewDataSource,LSSwitchSectionHeaderDelegate>
{
    UITableView* _tableView;
    LSSwitchSectionHeader* _switchSectionHeader;
    NSArray* _scheduleArray;
    NSInteger _selectIndex;
    
    id<LSSwitchScheduleViewDelegate> _delegate;
}

@property(nonatomic,retain) UITableView* tableView;
@property(nonatomic,retain) NSArray* scheduleArray;
@property(nonatomic,assign) NSInteger selectIndex;
@property(nonatomic,assign) id<LSSwitchScheduleViewDelegate> delegate;

@end

@protocol LSSwitchScheduleViewDelegate <NSObject>

- (void)LSSwitchScheduleView:(LSSwitchScheduleView*)switchScheduleView didSelectRowAtIndexPath:(NSInteger)indexPath;
- (void)LSSwitchScheduleView:(LSSwitchScheduleView*)switchScheduleView isSpread:(BOOL)isSpread;

@end
