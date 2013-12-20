//
//  LSFilmInfoStillCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-5.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSFilmInfoStillCellDelegate;
@interface LSFilmInfoStillCell : LSTableViewCell<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* _stillTableView;
    NSArray* _stillArray;
    
    id<LSFilmInfoStillCellDelegate> _delegate;
}
@property(nonatomic,retain) NSArray* stillArray;
@property(nonatomic,assign) id<LSFilmInfoStillCellDelegate> delegate;

@end

@protocol LSFilmInfoStillCellDelegate <NSObject>

- (void)LSFilmInfoStillCell:(LSFilmInfoStillCell*)filmInfoStillCell didSelectRowAtIndexPath:(NSInteger)indexPath;

@end
