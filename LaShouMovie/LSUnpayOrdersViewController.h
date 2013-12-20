//
//  LSUnpayOrdersViewController.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-29.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewController.h"
#import "LSUnpayOrderCell.h"
#import "LSPayViewController.h"

@interface LSUnpayOrdersViewController : LSTableViewController<LSUnpayOrderCellDelegate,LSPayViewControllerDelegate,UIActionSheetDelegate>
{
    NSMutableArray* _orderMArray;//已付款订单列表
    int _offset;
    int _pageSize;
    BOOL _isRefresh;//刷新标记
    BOOL _isAdd;//添加标记
}

@end
