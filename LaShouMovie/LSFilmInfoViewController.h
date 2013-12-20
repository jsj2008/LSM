//
//  LSFilmInfoViewController.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-5.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSViewController.h"
#import "LSFilm.h"
#import "LSFilmInfoStillCell.h"
#import "LSSeatSectionFooter.h"
#import "LSSinaWBAuthViewController.h"
#import "LSQQWBAuthViewController.h"

@interface LSFilmInfoViewController : LSViewController<LSFilmInfoStillCellDelegate,LSSeatSectionFooterDelegate,UIActionSheetDelegate,LSSinaWBAuthViewControllerDelegate,LSQQWBAuthViewControllerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    LSFilm* _film;
    UITableView* _tableView;
    
    BOOL _isDescriptionSpread;
    BOOL _isShowFooter;
    BOOL _isHideFooter;
}
@property(nonatomic,retain) LSFilm* film;
@property(nonatomic,assign) BOOL isHideFooter;

@end
