//
//  LSStatusView.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-23.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSSegmentedControl.h"

@protocol LSCinemaStatusViewDelegate;
@interface LSCinemaStatusView : UIView<LSSegmentedControlDelegate>
{
    LSSegmentedControl* _segmentedControl;
    id<LSCinemaStatusViewDelegate> _delegate;
}
@property(nonatomic,assign) id<LSCinemaStatusViewDelegate> delegate;

@end

@protocol LSCinemaStatusViewDelegate <NSObject>

@required
- (void)LSCinemaStatusView:(LSCinemaStatusView*)cinemaStatusView didSelectCinemaStatus:(LSCinemaStatus)cinemaStatus;

@end
