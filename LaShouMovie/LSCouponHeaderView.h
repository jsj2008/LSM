//
//  LSCouponHeaderView.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-27.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSCouponHeaderViewDelegate;
@interface LSCouponHeaderView : UIView<UITextFieldDelegate>
{
    UITextField* _couponTextField;
    UIButton* _addButton;
    
    id<LSCouponHeaderViewDelegate> _delegate;
}
@property(nonatomic,assign) id<LSCouponHeaderViewDelegate> delegate;

@end

@protocol LSCouponHeaderViewDelegate <NSObject>

@required
- (void)LSCouponHeaderView:(LSCouponHeaderView*)couponHeaderView didClickAddButton:(UIButton*)addButton withCouponTextField:(UITextField*)couponTextField;

@end
