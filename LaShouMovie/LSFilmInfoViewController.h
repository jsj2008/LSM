//
//  LSFilmInfoViewController.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-5.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewController.h"
#import "LSFilm.h"
#import "LSFilmInfoStillCell.h"
#import "LSFilmInfoFooterView.h"
#import "LSSinaWBAuthViewController.h"
#import "LSQQWBAuthViewController.h"

@interface LSFilmInfoViewController : LSTableViewController
<
LSFilmInfoStillCellDelegate,
LSFilmInfoFooterViewDelegate,
UIActionSheetDelegate,
LSSinaWBAuthViewControllerDelegate,
LSQQWBAuthViewControllerDelegate
>
{
    LSFilm* _film;

    BOOL _isDescriptionSpread;
    BOOL _isHideFooter;
}
@property(nonatomic,retain) LSFilm* film;
@property(nonatomic,assign) BOOL isHideFooter;

@end
