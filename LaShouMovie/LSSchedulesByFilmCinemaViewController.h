//
//  LSSchedulesByFilmCinemaViewController.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-8-29.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewController.h"
#import "LSCinema.h"
#import "LSFilm.h"
#import "LSDateSectionHeader.h"

#import "LSCinemaInfoInfoCell.h"
#import "LSCinemaInfoGroupCell.h"
#import "LSCinemaInfoScheduleCell.h"

@interface LSSchedulesByFilmCinemaViewController : LSTableViewController <LSCinemaInfoInfoCellDelegate,LSCinemaInfoGroupCellDelegate,LSDateSectionHeaderDelegate,UIActionSheetDelegate>
{
    LSCinema* _cinema;
    LSFilm* _film;
    NSString* _today;//今天的日期字符串 例如 2013-09-12
    
    int _selectScheduleDate;//选择的排期日期
    NSArray* _selectScheduleArray;//选择的排期
}

@property(nonatomic,retain) LSCinema* cinema;
@property(nonatomic,retain) LSFilm* film;

@end
