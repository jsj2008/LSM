//
//  LSSeatsViewController.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-8-29.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSViewController.h"

#import "LSLoginViewController.h"
#import "LSCreateOrderViewController.h"
#import "LSCinema.h"
#import "LSFilm.h"
#import "LSSchedule.h"
#import "LSOrder.h"
#import "LSSection.h"
#import "LSSwitchScheduleView.h"
#import "LSSeatCategoryView.h"
#import "LSSeatPlaceView.h"
#import "LSSeatsInfoView.h"

@interface LSSeatsViewController : LSViewController<LSSwitchScheduleViewDelegate,LSSeatPlaceViewDelegate,LSSeatsInfoViewDelegate,LSLoginViewControllerDelegate,LSCreateOrderViewControllerDelegate>
{
    LSSeatPlaceView* _seatPlaceView;
    LSSeatsInfoView* _seatsInfoView;
    LSOrder* _order;
    
    LSCinema* _cinema;
    LSFilm* _film;
    LSSchedule* _schedule;//选择的排期
    NSArray* _scheduleArray;//全部的排期
}

@property(nonatomic,retain) LSCinema* cinema;
@property(nonatomic,retain) LSFilm* film;
@property(nonatomic,retain) LSSchedule* schedule;
@property(nonatomic,retain) NSArray* scheduleArray;

@end
