//
//  LSCouponCommonCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-11-28.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewCell.h"
#import "LSCoupon.h"

@protocol LSCouponCommonCellDelegate;
@interface LSCouponCommonCell : LSTableViewCell
{
    LSCoupon* _coupon;
    UIButton* _deleteButton;
    
    CGFloat _topRadius;
    CGFloat _bottomRadius;
    CGFloat _topMargin;
    BOOL _isBottomLine;
    
    id<LSCouponCommonCellDelegate> _delegate;
}
@property(nonatomic,retain) LSCoupon* coupon;
@property(nonatomic,assign) CGFloat topRadius;
@property(nonatomic,assign) CGFloat bottomRadius;
@property(nonatomic,assign) CGFloat topMargin;
@property(nonatomic,assign) BOOL isBottomLine;//是否显示下方的线条
@property(nonatomic,assign) id<LSCouponCommonCellDelegate> delegate;

+ (CGFloat)heightForCoupon:(LSCoupon*)coupon;

@end

@protocol LSCouponCommonCellDelegate <NSObject>

- (void)LSCouponCommonCellDidDeleteWithCoupon:(LSCoupon*)coupon;

@end
