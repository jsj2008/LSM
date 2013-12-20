//
//  LSSettingViewController.h
//  LaShouMovie
//
//  Created by Li XiangYu on 13-10-4.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewController.h"
#import "LSSettingSwitchCell.h"

@interface LSSettingViewController : LSTableViewController<LSSettingSwitchCellDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
    LSVersion* version;
}
@end
