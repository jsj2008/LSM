//
//  LSCreateOrderViewController.h
//  LaShouMovie
//
//  Created by Li XiangYu on 13-9-23.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewController.h"
#import "LSOrder.h"
#import "LSCreateOrderFooterView.h"
#import "LSPayViewController.h"

@protocol LSCreateOrderViewControllerDelegate;
@interface LSCreateOrderViewController : LSTableViewController<LSPayViewControllerDelegate,LSCreateOrderFooterViewDelegate>
{
    LSCreateOrderFooterView* _createOrderFooterView;
    LSOrder* _order;
    id<LSCreateOrderViewControllerDelegate> _delegate;
}
@property(nonatomic,retain) LSOrder* order;
@property(nonatomic,assign) id<LSCreateOrderViewControllerDelegate> delegate;

@end

@protocol LSCreateOrderViewControllerDelegate <NSObject>

@required
- (void)LSCreateOrderViewControllerDidCreateOrder;

@end
