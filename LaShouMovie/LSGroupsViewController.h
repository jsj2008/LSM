//
//  LSGroupsViewController.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-9.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewController.h"
#import "LSGroupsHeaderView.h"
#import "LSGroupPayViewController.h"

@interface LSGroupsViewController : LSTableViewController
<
LSGroupsHeaderViewDelegate,
LSGroupPayViewControllerDelegate
>
{
    NSMutableArray* _unpayGroupMArray;//未付款的团购数组
    NSMutableArray* _paidGroupMArray;//已付款的团购数组
    
    int _offset;
    int _pageSize;
    BOOL _isRefresh;//刷新标记
    BOOL _isAdd;//添加标记
    
    LSGroupsHeaderView* _groupsHeaderView;
    NSArray* _groupMArray;//通用
    
    LSGroupStatus _groupStatus;//选择团购的状态
}
@property(nonatomic,assign) LSGroupStatus groupStatus;

@end
