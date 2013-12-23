//
//  LSCinemaInfoFilmCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-12.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewCell.h"

@protocol LSCinemaInfoFilmCellDelegate;
@interface LSCinemaInfoFilmCell : LSTableViewCell
<
UITableViewDelegate,
UITableViewDataSource
>
{
    NSArray* _filmArray;
    UITableView* _filmTableView;
    
    NSInteger _assignIndex;//上一次选择的位置
    
    id<LSCinemaInfoFilmCellDelegate> _delegate;
}
@property(nonatomic,retain) NSArray* filmArray;
@property(nonatomic,assign) NSInteger assignIndex;
@property(nonatomic,assign) id<LSCinemaInfoFilmCellDelegate> delegate;

@end

@protocol LSCinemaInfoFilmCellDelegate <NSObject>

@required
- (void)LSCinemaInfoFilmCell:(LSCinemaInfoFilmCell*)cinemaInfoFilmCell didChangeRowToIndexPath:(NSInteger)indexPath;
- (void)LSCinemaInfoFilmCell:(LSCinemaInfoFilmCell*)cinemaInfoFilmCell didSelectRowAtIndexPath:(NSInteger)indexPath;

@end