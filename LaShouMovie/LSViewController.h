//
//  LSViewController.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-8-29.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface LSViewController : UIViewController<UIGestureRecognizerDelegate>
{
    UIImageView* _nonInternetImageView;
    MBProgressHUD* hud;
    LSUser* user;
    LSMessageCenter* messageCenter;
    UIBarButtonSystemItem _leftBarButtonSystemItem;
    UIBarButtonSystemItem _rightBarButtonSystemItem;
}
@property(nonatomic,assign) UIBarButtonSystemItem leftBarButtonSystemItem;
@property(nonatomic,assign) UIBarButtonSystemItem rightBarButtonSystemItem;

- (void)setBarButtonItemWithImageName:(NSString *)imageName isRight:(BOOL)isRight;
- (void)setBarButtonItemWithTitle:(NSString *)title isRight:(BOOL)isRight;
- (void)setBarButtonItemWithTitle:(NSString *)title imageName:(NSString *)imageName isRight:(BOOL)isRight;

//可重载方法
- (void)leftBarButtonItemClick:(UIBarButtonItem*)sender;
- (void)rightBarButtonItemClick:(UIBarButtonItem*)sender;
- (void)refreshBecauseInternet;
- (BOOL)checkIsNotEmpty:(id)object;//检查数据是否不为空

@end
