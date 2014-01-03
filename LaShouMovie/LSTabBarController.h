//
//  LSTabBarController.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-8-29.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSLoginViewController.h"
#import "LSCitiesViewController.h"

@interface LSTabBarController : UITabBarController<LSLoginViewControllerDelegate,LSCitiesViewControllerDelegate,UIAlertViewDelegate>
{
    LSUser* user;
    LSVersion* version;
    LSMessageCenter* messageCenter;
}
- (void)selectCity;

@end
