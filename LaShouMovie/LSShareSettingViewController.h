//
//  LSShareSettingViewController.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-8.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewController.h"
#import "LSQQWBAuthViewController.h"
#import "LSSinaWBAuthViewController.h"

@interface LSShareSettingViewController : LSTableViewController<LSSinaWBAuthViewControllerDelegate,LSQQWBAuthViewControllerDelegate,UIAlertViewDelegate>
{
    BOOL _isSinaWBAuth;
    BOOL _isQQWBAuth;
}
@end
