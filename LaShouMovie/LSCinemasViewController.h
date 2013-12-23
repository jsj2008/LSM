//
//  LSCinemasViewController.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-10.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSViewController.h"
#import "LSCinemaStatusView.h"
#import "LSCitiesViewController.h"
#import "LSPositionSectionHeader.h"
#import "LSDistrictSelectorView.h"
#import "LSAdView.h"
#import "LSAdvertisment.h"

@interface LSCinemasViewController : LSViewController
<
UITableViewDataSource,
UITableViewDelegate,
LSDistrictSelectorViewDelegate,
LSCinemaStatusViewDelegate,
LSPositionSectionHeaderDelegate,
LSCitiesViewControllerDelegate,
LSAdViewDelegate
>
{
    UITableView* _tableView;
    NSMutableArray* _cinemaMArray;//影院数组
    
    LSAdvertisment* _advertisment;//广告
    LSAdView* _adView;
    
    LSCinemaStatus _cinemaStatus;//选择影院的状态
    LSCinemaStatusView* _cinemaStatusView;
    
    NSMutableArray* _districtMArray;
    NSMutableArray* _areaMArray;
    
    //选择出来的影院是不固定的，所以必须动态生成
    NSMutableArray* _selectMArray;//选择出来的影院数组
    NSString* _district;//选择的位置
}

@end
