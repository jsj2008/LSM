//
//  LSCinemaInfoInfoCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-12.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewCell.h"
#import "LSCinema.h"

@protocol LSCinemaInfoInfoCellDelegate;
@interface LSCinemaInfoInfoCell : LSTableViewCell
{
    UIButton* _mapButton;
    UIButton* _phoneButton;
    
    LSCinema* _cinema;
    id<LSCinemaInfoInfoCellDelegate> _delegate;
}
@property(nonatomic,retain) LSCinema* cinema;
@property(nonatomic,assign) id<LSCinemaInfoInfoCellDelegate> delegate;

+ (CGFloat)heightForCinema:(LSCinema*)cinema;

@end

@protocol LSCinemaInfoInfoCellDelegate <NSObject>

@required
- (void)LSCinemaInfoInfoCell:(LSCinemaInfoInfoCell*)cinemaInfoInfoCell didClickMapButton:(UIButton*)mapButton;
- (void)LSCinemaInfoInfoCell:(LSCinemaInfoInfoCell*)cinemaInfoInfoCell didClickPhoneButton:(UIButton*)phoneButton;

@end
