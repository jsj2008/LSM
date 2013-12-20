//
//  LSGroupStatusView.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-9.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSGroupStatusViewDelegate;
@interface LSGroupStatusView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    LSGroupStatus _groupStatus;//选项
    NSArray* _statusArray;//影院状态数组
    UITableView* _tableView;
    
    id<LSGroupStatusViewDelegate> _delegate;
}
@property(nonatomic,assign) LSGroupStatus groupStatus;
@property(nonatomic,assign) id<LSGroupStatusViewDelegate> delegate;

@end

@protocol LSGroupStatusViewDelegate <NSObject>

- (void)LSGroupStatusView:(LSGroupStatusView*)groupStatusView didSelectRowAtIndexPath:(LSGroupStatus)status;

@end
