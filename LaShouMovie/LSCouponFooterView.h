//
//  LSCouponFooterView.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-11-28.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSCouponFooterViewDelegate;
@interface LSCouponFooterView : UIView
{
    UIButton* _useButton;
    id<LSCouponFooterViewDelegate> _delegate;
}
@property(nonatomic,assign)id<LSCouponFooterViewDelegate> delegate;

@end

@protocol LSCouponFooterViewDelegate <NSObject>

@required
- (void)LSCouponFooterView:(LSCouponFooterView*)couponFooterView didClickUseButton:(UIButton*)useButton;

@end
