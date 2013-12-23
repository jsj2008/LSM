//
//  LSTableViewController.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-9.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface LSTableViewController : UITableViewController<UIGestureRecognizerDelegate>
{
    MBProgressHUD* hud;
    LSUser* user;
    LSMessageCenter* messageCenter;
    LSInternetStatusRemindType _internetStatusRemindType;
    UIBarButtonSystemItem _leftBarButtonSystemItem;
    UIBarButtonSystemItem _rightBarButtonSystemItem;
}
@property(nonatomic,assign) UIBarButtonSystemItem leftBarButtonSystemItem;
@property(nonatomic,assign) UIBarButtonSystemItem rightBarButtonSystemItem;
@property(nonatomic,assign) LSInternetStatusRemindType internetStatusRemindType;

- (void)initRefreshControl;
- (void)setBarButtonItemWithImageName:(NSString *)imageName isRight:(BOOL)isRight;
- (void)setBarButtonItemWithTitle:(NSString *)title isRight:(BOOL)isRight;
- (void)setBarButtonItemWithTitle:(NSString *)title imageName:(NSString *)imageName isRight:(BOOL)isRight;

//可重载方法
- (void)leftBarButtonItemClick:(UIBarButtonItem*)sender;
- (void)rightBarButtonItemClick:(UIBarButtonItem*)sender;
- (void)refreshControlEventValueChanged;
- (void)refreshBecauseInternet;
- (BOOL)checkIsNotEmpty:(id)object;//检查数据是否不为空

@end
