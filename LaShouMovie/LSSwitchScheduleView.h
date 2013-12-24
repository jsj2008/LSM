//
//  LSSwitchScheduleView.h
//  LaShouMovie
//
//  Created by Li XiangYu on 13-9-15.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSSwitchSectionHeader.h"
#import "FXBlurView.h"

@protocol LSSwitchScheduleViewDelegate;
@interface LSSwitchScheduleView : UIView<UITableViewDelegate,UITableViewDataSource,LSSwitchSectionHeaderDelegate>
{
    UITableView* _scheduleTableView;
    FXBlurView* _blurView;
    LSSwitchSectionHeader* _switchSectionHeader;
    NSArray* _scheduleArray;
    NSInteger _selectIndex;
    
    id<LSSwitchScheduleViewDelegate> _delegate;
}
@property(nonatomic,retain) NSArray* scheduleArray;
@property(nonatomic,assign) NSInteger selectIndex;
@property(nonatomic,assign) id<LSSwitchScheduleViewDelegate> delegate;

@end

@protocol LSSwitchScheduleViewDelegate <NSObject>

@required
- (void)LSSwitchScheduleView:(LSSwitchScheduleView*)switchScheduleView didSelectRowAtIndexPath:(NSInteger)indexPath;

@end
