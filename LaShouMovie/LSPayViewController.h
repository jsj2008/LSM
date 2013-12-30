//
//  LSPayViewController.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-26.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewController.h"
#import "LSOrder.h"
#import "LSCountDownView.h"
#import "LSSecurityCodeView.h"
#import "LSPayCouponCell.h"
#import "LSPaidOrdersViewController.h"
#import "LSUseCouponViewController.h"
#import "UPOMP.h"
#import "LSPayFooterView.h"

@protocol LSPayViewControllerDelegate;
@interface LSPayViewController : LSTableViewController
<
UPOMPDelegate,
LSPaidOrdersViewControllerDelegate,
LSUseCouponViewControllerDelegate,
LSSecurityCodeViewDelegate,
LSCountDownViewDelegate,
LSPayFooterViewDelegate,
LSPayCouponCellDelegate,
UIAlertViewDelegate
>
{
    LSCountDownView* _countDownView;
    LSPayFooterView* _payFooterView;
    BOOL _isSpread;
    
    LSOrder* _order;
    id<LSPayViewControllerDelegate> _delegate;
}
@property(nonatomic,retain) LSOrder* order;
@property(nonatomic,assign) id<LSPayViewControllerDelegate> delegate;

@end

@protocol LSPayViewControllerDelegate <NSObject>

@required
- (void)LSPayViewControllerDidPay;

@end
