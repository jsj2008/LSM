//
//  LSGroupInfoPositionCell.h
//  LaShouMovie
//
//  Created by Li XiangYu on 13-10-10.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewCell.h"
#import "LSCinema.h"

@protocol LSGroupInfoPositionCellDelegate;
@interface LSGroupInfoPositionCell : LSTableViewCell
{
    LSCinema* _cinema;
    UIButton* _mapButton;
    UIButton* _phoneButton;
    id<LSGroupInfoPositionCellDelegate> _delegate;
}
@property(nonatomic,retain) LSCinema* cinema;
@property(nonatomic,assign) id<LSGroupInfoPositionCellDelegate> delegate;

+ (CGFloat)heightOfCinema:(LSCinema*)cinema;

@end

@protocol LSGroupInfoPositionCellDelegate <NSObject>

- (void)LSGroupInfoPositionCell:(LSGroupInfoPositionCell*)groupInfoPositionCell didClickMapButton:(UIButton*)mapButton;
- (void)LSGroupInfoPositionCell:(LSGroupInfoPositionCell*)groupInfoPositionCell didClickPhoneButton:(UIButton*)phoneButton;

@end
