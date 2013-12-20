//
//  LSMyViewController.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-30.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewController.h"
#import "LSMySectionHeader.h"
#import "LSBindViewController.h"
#import "LSMyMobileCell.h"

@interface LSMyViewController : LSTableViewController<LSMySectionHeaderDelegate,LSBindViewControllerDelegate,LSMyMobileCellDelegate,UIAlertViewDelegate>
{
    BOOL _isMovieOpen;
    BOOL _isGroupOpen;
    
    BOOL _isRefresh;
}
@end
