//
//  LSCinemaInfoFilmCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-12.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSFilmInfoView.h"

@protocol LSCinemaInfoFilmCellDelegate;
@interface LSCinemaInfoFilmCell : LSTableViewCell<UITableViewDelegate,UITableViewDataSource,LSFilmInfoViewDelegate>
{
    NSArray* _filmArray;
    UITableView* _filmTableView;
    LSFilmInfoView* _filmInfoView;
    
    NSInteger _lastIndex;//上一次选择的位置
    CGFloat _lastContentoffsetY;//上一次的偏移量
    
    id<LSCinemaInfoFilmCellDelegate> _delegate;
    BOOL _animated;
}
@property(nonatomic,retain) NSArray* filmArray;
@property(nonatomic,assign) BOOL animated;
@property(nonatomic,assign) id<LSCinemaInfoFilmCellDelegate> delegate;

@end

@protocol LSCinemaInfoFilmCellDelegate <NSObject>

- (void)LSCinemaInfoFilmCell:(LSCinemaInfoFilmCell*)cinemaInfoFilmCell didChangeRowToIndexPath:(NSInteger)indexPath;
- (void)LSCinemaInfoFilmCell:(LSCinemaInfoFilmCell*)cinemaInfoFilmCell didSelectRowAtIndexPath:(NSInteger)indexPath;

@end