//
//  LSCreateOrderViewController.h
//  LaShouMovie
//
//  Created by Li XiangYu on 13-9-23.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSViewController.h"
#import "LSOrder.h"
#import "LSCreateOrderFooterView.h"
#import "LSCreateOrderView.h"
#import "LSPayViewController.h"

@protocol LSCreateOrderViewControllerDelegate;
@interface LSCreateOrderViewController : LSViewController<LSPayViewControllerDelegate,LSCreateOrderFooterViewDelegate>
{
    LSCreateOrderView* _createOrderView;
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
