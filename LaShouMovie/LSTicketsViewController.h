//
//  LSTicketsViewController.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-29.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewController.h"

@interface LSTicketsViewController : LSTableViewController
{
    NSMutableArray* _ticketMArray;//未使用的拉手券数组
    
    int _offset;
    int _pageSize;
    BOOL _isRefresh;//刷新标记
    BOOL _isAdd;//添加标记
}
@end
