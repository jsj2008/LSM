//
//  LSCinemaInfoGroupCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-12.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSCinemaInfoGroupCellDelegate;
@interface LSCinemaInfoGroupCell : LSTableViewCell<UITableViewDelegate,UITableViewDataSource>
{
    NSArray* _groupArray;
    UITableView* _groupTableView;
    NSTimer* _timer;
    
    id<LSCinemaInfoGroupCellDelegate> _delegate;
}
@property(nonatomic,retain) NSArray* groupArray;
@property(nonatomic,assign) id<LSCinemaInfoGroupCellDelegate> delegate;

@end

@protocol LSCinemaInfoGroupCellDelegate <NSObject>

- (void)LSCinemaInfoGroupCell:(LSCinemaInfoGroupCell*)cinemaInfoGroupCell didSelectRowAtIndexPath:(NSInteger)indexPath;

@end
