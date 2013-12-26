//
//  LSPayCouponCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-11-27.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewCell.h"
#import "LSOrder.h"

@protocol LSPayCouponCellDelegate;
@interface LSPayCouponCell : LSTableViewCell
{
    UIButton* _couponButton;
    LSOrder* _order;
    id<LSPayCouponCellDelegate> _delegate;
}
@property (nonatomic,retain) LSOrder* order;
@property (nonatomic,assign) id<LSPayCouponCellDelegate> delegate;

@end

@protocol LSPayCouponCellDelegate <NSObject>

- (void)LSPayCouponCellDidSelect;

@end

