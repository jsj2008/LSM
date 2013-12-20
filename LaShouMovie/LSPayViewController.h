//
//  LSPayViewController.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-26.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewController.h"
#import "LSOrder.h"
#import "LSPayFooterView.h"
#import "LSSecurityCodeView.h"
#import "LSPayFilmCell.h"
#import "LSPaySeatCell.h"
#import "LSPayCouponCell.h"
#import "LSPaidOrdersViewController.h"
#import "LSCouponViewController.h"
#import "UPOMP.h"

@protocol LSPayViewControllerDelegate;
@interface LSPayViewController : LSTableViewController<UPOMPDelegate,LSPaidOrdersViewControllerDelegate,LSCouponViewControllerDelegate,UIAlertViewDelegate,LSSecurityCodeViewDelegate,LSPayFooterViewDelegate,LSPayFilmCellDelegate,LSPaySeatCellDelegate,LSPayCouponCellDelegate>
{
    LSPayFooterView* _payFooterView;
    BOOL _isSpread;
    
    LSOrder* _order;
    id<LSPayViewControllerDelegate> _delegate;
}
@property(nonatomic,retain) LSOrder* order;
@property(nonatomic,assign) id<LSPayViewControllerDelegate> delegate;

@end

@protocol LSPayViewControllerDelegate <NSObject>

- (void)LSPayViewControllerDidPay;

@end
