//
//  LSSettingWifiCell.h
//  LaShouMovie
//
//  Created by Li XiangYu on 13-10-4.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewCell.h"

@protocol LSSettingSwitchCellDelegate;
@interface LSSettingSwitchCell : LSTableViewCell
{
    UISwitch* _switch;
    BOOL _isTurnOn;
    id<LSSettingSwitchCellDelegate> _delegate;
}
@property(nonatomic,assign) BOOL isTurnOn;
@property(nonatomic,assign) id<LSSettingSwitchCellDelegate> delegate;


@end

@protocol LSSettingSwitchCellDelegate <NSObject>

@required
- (void)LSSettingSwitchCell:(LSSettingSwitchCell*)settingSwitchCell didChangeValue:(BOOL)isTurnOn;

@end
