//
//  LSAppDelegate.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-8-22.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSTabBarController.h"
#import "LSWelcomeView.h"
#import "MBProgressHUD.h"

@interface LSAppDelegate : UIResponder <UIApplicationDelegate,LSWelcomeViewDelegate>
{
    LSTabBarController* tabBarController;
    LSMessageCenter* messageCenter;
    LSUser* user;
    BOOL _loadUserInfo;
    MBProgressHUD* hud;
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) BOOL loadUserInfo;

@end
