//
//  LSCouponViewController.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-11-28.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewController.h"
#import "LSOrder.h"
#import "LSUseCouponCommonCell.h"
#import "LSUseCouponMoneyCell.h"
#import "LSUseCouponHeaderView.h"
#import "LSUseCouponFooterView.h"

@protocol LSUseCouponViewControllerDelegate;
@interface LSUseCouponViewController : LSTableViewController
<
UIAlertViewDelegate,
LSUseCouponCommonCellDelegate,
LSUseCouponMoneyCellDelegate,
LSUseCouponHeaderViewDelegate,
LSUseCouponFooterViewDelegate
>
{
    LSOrder* _order;
    id<LSUseCouponViewControllerDelegate> _delegate;
    NSMutableArray* _couponMArray;
    LSUseCouponHeaderView* _useCouponHeaderView;
    LSUseCouponFooterView* _useCouponFooterView;
    BOOL _isHideButton;
}
@property(nonatomic,retain) LSOrder* order;
@property(nonatomic,assign) id<LSUseCouponViewControllerDelegate> delegate;

@end

@protocol LSUseCouponViewControllerDelegate <NSObject>

@required
- (void)LSUseCouponViewControllerDidChangeCoupon;

@end
