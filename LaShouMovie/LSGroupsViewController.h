//
//  LSGroupsViewController.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-9.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSViewController.h"
#import "LSGroupStatusView.h"
#import "LSGroupPayViewController.h"

@interface LSGroupsViewController : LSViewController<UITableViewDataSource,UITableViewDelegate,LSGroupStatusViewDelegate,LSGroupPayViewControllerDelegate>
{
    NSMutableArray* _unpayGroupMArray;//未付款的团购数组
    NSMutableArray* _paidGroupMArray;//已付款的团购数组
    
    int _offset;
    int _pageSize;
    BOOL _isRefresh;//刷新标记
    BOOL _isAdd;//添加标记
    
    NSArray* _groupMArray;//通用
    
    LSGroupStatus _groupStatus;//选择团购的状态
    UITableView* _tableView;
    LSGroupStatusView* _groupStatusView;
}
@property(nonatomic,assign) LSGroupStatus groupStatus;

@end
