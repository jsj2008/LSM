//
//  LSCinemasViewController.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-10.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewController.h"
#import "LSCinemaStatusView.h"
#import "LSCitiesViewController.h"
#import "LSPositionSectionHeader.h"
#import "LSSelectorView.h"
#import "LSAdView.h"
#import "LSAdvertisment.h"

@interface LSCinemasViewController : LSTableViewController<LSCinemaStatusViewDelegate,LSCitiesViewControllerDelegate,LSPositionSectionHeaderDelegate,LSSelectorViewDelegate,LSAdViewDelegate>
{
    //因为这些数据不能够使用缓存，所以在保证不会内存溢出的情况下应该尽量将数据存于内存中
    //因为数组的个数是有限的，因此可以使用多个数组来存储
    
    //影院数组的结构分为两个部分，myCinemas、cinemas、otherCinemas
    NSMutableArray* _cinemaMArray;//影院数组
    
    NSMutableArray* _seatPositionMArray;//可订座影院位置数组
    NSMutableArray* _groupPositionMArray;//可团购影院位置数组
    NSMutableArray* _allPositionMArray;//全部影院位置数组
    
    //选择出来的影院是不固定的，所以必须动态生成
    NSMutableArray* _selectMArray;//选择出来的影院数组
    NSInteger _selectPositionIndex;//选择的位置
    
    LSAdvertisment* _advertisment;//广告
    
    LSCinemaStatus _cinemaStatus;//选择影院的状态

    LSCinemaStatusView* _cinemaStatusView;
    LSAdView* _adView;
}

@end
