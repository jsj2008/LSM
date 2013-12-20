//
//  LSStatusView.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-23.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSCinemaStatusViewDelegate;
@interface LSCinemaStatusView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    LSCinemaStatus _cinemaStatus;//选项
    NSArray* _statusArray;//影院状态数组
    UITableView* _tableView;
    
    id<LSCinemaStatusViewDelegate> _delegate;
}
@property(nonatomic,assign) LSCinemaStatus cinemaStatus;
@property(nonatomic,assign) id<LSCinemaStatusViewDelegate> delegate;

@end

@protocol LSCinemaStatusViewDelegate <NSObject>

- (void)LSCinemaStatusView:(LSCinemaStatusView*)cinemaStatusView didSelectRowAtIndexPath:(LSCinemaStatus)cinemaStatus;

@end
