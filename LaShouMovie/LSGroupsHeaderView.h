//
//  LSGroupsHeaderView.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-30.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSSegmentedControl.h"

@protocol LSGroupsHeaderViewDelegate;
@interface LSGroupsHeaderView : UIView<LSSegmentedControlDelegate>
{
    LSSegmentedControl* _segmentedControl;
    id<LSGroupsHeaderViewDelegate> _delegate;
    LSGroupStatus _groupStatus;
}
@property(nonatomic,assign) id<LSGroupsHeaderViewDelegate> delegate;
@property(nonatomic,assign) LSGroupStatus groupStatus;

@end

@protocol LSGroupsHeaderViewDelegate <NSObject>

@required
- (void)LSGroupsHeaderView:(LSGroupsHeaderView*)groupsHeaderView didSelectGroupStatus:(LSGroupStatus)groupStatus;

@end
