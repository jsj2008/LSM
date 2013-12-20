//
//  LSBindViewController.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-8-30.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewController.h"
#import "LSBindPhoneCell.h"
#import "LSBindCell.h"
#import "LSBindFooterView.h"

@protocol LSBindViewControllerDelegate;
@interface LSBindViewController : LSTableViewController<LSBindPhoneCellDelegate,LSBindFooterViewDelegate>
{
    LSBindCell* _bindOriginPhoneCell;
    LSBindPhoneCell* _bindPhoneCell;
    LSBindCell* _bindVerifyCell;
    BOOL _isHasBind;
    id<LSBindViewControllerDelegate> _delegate;
}
@property(nonatomic,assign) id<LSBindViewControllerDelegate> delegate;

@end

@protocol LSBindViewControllerDelegate <NSObject>

@required
- (void)LSBindViewControllerDidBindOrNot;

@end
