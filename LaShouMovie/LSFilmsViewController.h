//
//  LSFilmsViewController.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-8-29.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewController.h"
#import "LSSegmentedControl.h"
#import "LSCitiesViewController.h"
#import "LSAdView.h"
#import "LSAdvertisment.h"

typedef enum
{
    LSDisplayTypeList = 0,//海报样式
    LSDisplayTypePoster = 1//列表样式
    
} LSDisplayType;

@interface LSFilmsViewController : LSTableViewController<LSCitiesViewControllerDelegate,LSSegmentedControlDelegate,LSAdViewDelegate>
{
    NSMutableArray* _showingFilmMArray;//正在上映的影片数组
    NSMutableArray* _willShowFilmMArray;//将要上映的影片数组
    LSAdvertisment* _advertisment;//广告
    
    NSMutableArray* _showingFilmListCellMArray;
    NSMutableArray* _willFilmListCellMArray;
    NSMutableArray* _showingFilmPosterCellMArray;
    NSMutableArray* _willFilmPosterCellMArray;
    
    NSMutableArray* _filmArray;//通用
    NSMutableArray* _filmCellArray;//通用
    
    LSSegmentedControl* _segmentedControl;
    LSAdView* _adView;
    
    LSDisplayType _displayType;//展示显示
    LSFilmShowStatus _filmShowStatus;//上映状态
}
@end
