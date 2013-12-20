//
//  LSSegmentedControl.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-19.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSSegmentedControlDelegate;
@interface LSSegmentedControl : UISegmentedControl
{
    id<LSSegmentedControlDelegate> _delegate;
}
@property(nonatomic,assign) id<LSSegmentedControlDelegate> delegate;

@end

@protocol LSSegmentedControlDelegate <NSObject>

@required
- (void)LSSegmentedControl:(LSSegmentedControl*)control didSelectSegmentIndex:(NSInteger)index;

@end
