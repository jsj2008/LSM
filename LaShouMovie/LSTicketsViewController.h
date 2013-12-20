//
//  LSTicketsViewController.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-29.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSViewController.h"
#import "LSTicketStatusView.h"
#import "LSTicketInfoViewController.h"

@interface LSTicketsViewController : LSViewController<UITableViewDataSource,UITableViewDelegate,LSTicketStatusViewDelegate>
{
    NSMutableArray* _unuseTicketMArray;//未使用的拉手券数组
    NSMutableArray* _usedTicketMArray;//已使用的拉手券数组
    NSMutableArray* _timeoutTicketMArray;//已过期的拉手券数组
    
    int _offset;
    int _pageSize;
    BOOL _isRefresh;//刷新标记
    BOOL _isAdd;//添加标记
    
    NSArray* _ticketMArray;//通用
    
    LSTicketStatus _ticketStatus;//选择拉手券的状态
    UITableView* _tableView;
    LSTicketStatusView* _ticketStatusView;
}
@end
