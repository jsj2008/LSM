//
//  LSCouponCommonCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-11-28.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewCell.h"
#import "LSCoupon.h"

@protocol LSUseCouponCommonCellDelegate;
@interface LSUseCouponCommonCell : LSTableViewCell
{
    LSCoupon* _coupon;
    UIButton* _deleteButton;
    CGFloat _topMargin;
    
    id<LSUseCouponCommonCellDelegate> _delegate;
}
@property(nonatomic,retain) LSCoupon* coupon;
@property(nonatomic,assign) CGFloat topMargin;
@property(nonatomic,assign) id<LSUseCouponCommonCellDelegate> delegate;

@end

@protocol LSUseCouponCommonCellDelegate <NSObject>

@required
- (void)LSUseCouponCommonCell:(LSUseCouponCommonCell*)useCouponCommonCell didClickDeleteButton:(UIButton*)deleteButton;

@end
