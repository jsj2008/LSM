//
//  LSCinemasByFilmViewController.h
//  LaShouMovie
//
//  Created by Li XiangYu on 13-9-14.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSViewController.h"
#import "LSFilm.h"
#import "LSPositionSectionHeader.h"
#import "LSCinemaStatusView.h"
#import "LSDistrictSelectorView.h"
#import "LSSelectorView.h"

@interface LSCinemasByFilmViewController : LSViewController
<
UITableViewDataSource,
UITableViewDelegate,
LSDistrictSelectorViewDelegate,
LSCinemaStatusViewDelegate,
LSPositionSectionHeaderDelegate
>
{
    LSFilm* _film;
    UITableView* _tableView;
    
    NSMutableArray* _cinemaMArray;//影院数组
    
    NSMutableArray* _districtMArray;
    NSMutableArray* _areaMArray;
    
    //选择出来的影院是不固定的，所以必须动态生成
    NSMutableArray* _selectMArray;//选择出来的影院数组
    NSString* _district;//选择的位置
    
    LSCinemaStatus _cinemaStatus;//选择影院的状态
    LSCinemaStatusView* _cinemaStatusView;
}

@property(nonatomic,retain) LSFilm* film;

@end
