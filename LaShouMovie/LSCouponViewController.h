//
//  LSCouponViewController.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-11-28.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewController.h"
#import "LSOrder.h"
#import "LSCouponInputCell.h"
#import "LSCouponCommonCell.h"
#import "LSCouponMoneyCell.h"

@protocol LSCouponViewControllerDelegate;
@interface LSCouponViewController : LSTableViewController<UIAlertViewDelegate,LSCouponInputCellDelegate,LSCouponCommonCellDelegate,LSCouponMoneyCellDelegate>
{
    LSOrder* _order;
    id<LSCouponViewControllerDelegate> _delegate;
    NSMutableArray* _couponMArray;
    
    UITapGestureRecognizer* _tapGestureRecognizer;
    
    UIButton* _useButton;
}
@property(nonatomic,retain) LSOrder* order;
@property(nonatomic,assign) id<LSCouponViewControllerDelegate> delegate;

@end

@protocol LSCouponViewControllerDelegate <NSObject>

- (void)LSCouponViewControllerDidChangeCoupon;

@end
