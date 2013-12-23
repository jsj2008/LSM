//
//  LSFilmsSchedulesByCinemaViewController.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-12.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewController.h"
#import "LSCinema.h"
#import "LSFilm.h"
#import "LSDateSectionHeader.h"

#import "LSCinemaInfoInfoCell.h"
#import "LSCinemaInfoGroupCell.h"
#import "LSCinemaInfoFilmCell.h"
#import "LSCinemaInfoScheduleCell.h"

@interface LSFilmsSchedulesByCinemaViewController : LSTableViewController
<
LSCinemaInfoInfoCellDelegate,
LSCinemaInfoFilmCellDelegate,
LSDateSectionHeaderDelegate,
UIActionSheetDelegate
>
{
    LSCinema* _cinema;
    LSFilm* _film;
    NSMutableArray* _filmMArray;//影片数组
    NSString* _today;//今天的日期字符串 例如 2013-09-12
    
    LSDateSectionHeader* _dateSectionHeader;
    LSScheduleDate _selectScheduleDate;//选择的排期日期
    
    int _selectFilmIndex;//当前选择影片的位置
    LSFilm* _selectFilm;
    
    NSArray* _selectScheduleArray;//选择的排期
}
@property(nonatomic,retain) LSCinema* cinema;
@property(nonatomic,retain) LSFilm* film;

@end
