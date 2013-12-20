//
//  LSGroupInfoPhoneCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-11.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSGroupInfoPhoneCellDelegate;
@interface LSGroupInfoPhoneCell : LSTableViewCell
{
    UIButton* _phoneButton;
    id<LSGroupInfoPhoneCellDelegate> _delegate;
}
@property(nonatomic,assign) id<LSGroupInfoPhoneCellDelegate> delegate;

@end

@protocol LSGroupInfoPhoneCellDelegate <NSObject>

- (void)LSGroupInfoPhoneCell:(LSGroupInfoPhoneCell*)groupInfoPhoneCell didClickPhoneButton:(UIButton*)phoneButton;

@end
