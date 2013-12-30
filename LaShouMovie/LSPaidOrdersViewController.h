//
//  LSPaidOrdersViewController.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-29.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewController.h"

@protocol LSPaidOrdersViewControllerDelegate;
@interface LSPaidOrdersViewController : LSTableViewController
{
    NSMutableArray* _orderMArray;//已付款订单列表
    int _offset;
    int _pageSize;
    BOOL _isRefresh;//刷新标记
    BOOL _isAdd;//添加标记
    
    BOOL _isCardRemind;//是否提示生成卡券
    id<LSPaidOrdersViewControllerDelegate> _delegate;
}

@property(nonatomic,assign) BOOL isCardRemind;
@property(nonatomic,assign) id<LSPaidOrdersViewControllerDelegate> delegate;

@end

@protocol LSPaidOrdersViewControllerDelegate <NSObject>

@required
- (void)LSPaidOrdersViewControllerDidBack;

@end
