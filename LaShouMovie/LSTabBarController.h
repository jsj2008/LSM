//
//  LSTabBarController.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-8-29.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSTabBar.h"
#import "LSLoginViewController.h"
#import "LSCitiesViewController.h"

@interface LSTabBarController : UITabBarController<LSTabBarDelegate,LSLoginViewControllerDelegate,LSCitiesViewControllerDelegate,UIAlertViewDelegate>
{
    LSTabBar* _myTabBar;
    LSUser* user;
    LSVersion* version;
    LSMessageCenter* messageCenter;
}
- (void)selectCity;
- (void)LSTabBarControllerSelectedIndex:(NSInteger)index;

@end
