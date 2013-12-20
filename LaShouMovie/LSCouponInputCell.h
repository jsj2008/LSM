//
//  LSCouponInputCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-11-28.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSCouponInputCellDelegate;
@interface LSCouponInputCell : LSTableViewCell<UITextFieldDelegate>
{
    UITextField* _couponTextField;
    UIButton* _useButton;
    id<LSCouponInputCellDelegate> _delegate;
}
@property(nonatomic,assign) id<LSCouponInputCellDelegate> delegate;

@end

@protocol LSCouponInputCellDelegate <NSObject>

- (void)LSCouponInputCellDidUseCoupon:(NSString*)couponID;

@end
