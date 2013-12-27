//
//  LSCouponMoneyCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-11-28.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewCell.h"
#import "LSCoupon.h"

@protocol LSUseCouponMoneyCellDelegate;
@interface LSUseCouponMoneyCell : LSTableViewCell
{
    LSCoupon* _coupon;
    UIButton* _deleteButton;
    
    CGFloat _topMargin;

    id<LSUseCouponMoneyCellDelegate> _delegate;
}
@property(nonatomic,retain) LSCoupon* coupon;
@property(nonatomic,assign) CGFloat topMargin;
@property(nonatomic,assign) id<LSUseCouponMoneyCellDelegate> delegate;

@end

@protocol LSUseCouponMoneyCellDelegate <NSObject>

@required
- (void)LSUseCouponMoneyCell:(LSUseCouponMoneyCell*)useCouponMoneyCell didClickDeleteButton:(UIButton*)deleteButton;

@end
