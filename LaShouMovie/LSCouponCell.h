//
//  LSCouponCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-27.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSCoupon.h"

@interface LSCouponCell : UITableViewCell
{
    LSCoupon* _coupon;
}
@property(nonatomic,retain) LSCoupon* coupon;

@end
