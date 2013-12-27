//
//  LSCouponViewController.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-11-28.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewController.h"
#import "LSOrder.h"
#import "LSCouponCommonCell.h"
#import "LSCouponMoneyCell.h"
#import "LSCouponHeaderView.h"
#import "LSCouponFooterView.h"

@protocol LSCouponViewControllerDelegate;
@interface LSCouponViewController : LSTableViewController
<
UIAlertViewDelegate,
LSCouponCommonCellDelegate,
LSCouponMoneyCellDelegate,
LSCouponHeaderViewDelegate,
LSCouponFooterViewDelegate
>
{
    LSOrder* _order;
    id<LSCouponViewControllerDelegate> _delegate;
    NSMutableArray* _couponMArray;
    LSCouponHeaderView* _couponHeaderView;
    LSCouponFooterView* _couponFooterView;
    BOOL _isHideButton;
}
@property(nonatomic,retain) LSOrder* order;
@property(nonatomic,assign) id<LSCouponViewControllerDelegate> delegate;

@end

@protocol LSCouponViewControllerDelegate <NSObject>

@required
- (void)LSCouponViewControllerDidChangeCoupon;

@end
