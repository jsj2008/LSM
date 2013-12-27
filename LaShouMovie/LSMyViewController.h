//
//  LSMyViewController.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-30.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewController.h"
#import "LSMyHeaderView.h"
#import "LSBindViewController.h"
#import "LSMyPhoneCell.h"

@interface LSMyViewController : LSTableViewController
<
LSBindViewControllerDelegate,
LSMyPhoneCellDelegate,
UIAlertViewDelegate
>
{
    BOOL _isMovieOpen;
    BOOL _isGroupOpen;
    LSMyHeaderView* _myHeaderView;
}
@end
