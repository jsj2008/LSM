//
//  LSGroupInfoViewController.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-10.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewController.h"
#import "LSGroup.h"
#import "LSCinema.h"
#import "LSGroupInfoSectionFooter.h"
#import "LSGroupCreateOrderViewController.h"
#import "LSGroupInfoPositionCell.h"
#import "LSGroupInfoGroupCell.h"
#import "LSGroupInfoPhoneCell.h"
#import "LSSinaWBAuthViewController.h"
#import "LSQQWBAuthViewController.h"
#import "LSLoginViewController.h"

@interface LSGroupInfoViewController : LSTableViewController<LSGroupInfoSectionFooterDelegate,LSGroupCreateOrderViewControllerDelegate,LSGroupInfoPositionCellDelegate,LSGroupInfoGroupCellDelegate,LSGroupInfoPhoneCellDelegate,UIActionSheetDelegate,LSSinaWBAuthViewControllerDelegate,LSQQWBAuthViewControllerDelegate,LSLoginViewControllerDelegate>
{
    LSGroup* _group;
    LSCinema* _cinema;
    
    NSMutableArray* _otherGroupMArray;
    BOOL _isOpen;
}
@property(nonatomic,retain) LSGroup* group;
@property(nonatomic,retain) LSCinema* cinema;

@end
