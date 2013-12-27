//
//  LSCouponHeaderView.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-27.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSUseCouponHeaderViewDelegate;
@interface LSUseCouponHeaderView : UIView<UITextFieldDelegate>
{
    UITextField* _couponTextField;
    UIButton* _addButton;
    
    id<LSUseCouponHeaderViewDelegate> _delegate;
}
@property(nonatomic,assign) id<LSUseCouponHeaderViewDelegate> delegate;

@end

@protocol LSUseCouponHeaderViewDelegate <NSObject>

@required
- (void)LSUseCouponHeaderView:(LSUseCouponHeaderView*)useCouponHeaderView didClickAddButton:(UIButton*)addButton withCouponTextField:(UITextField*)couponTextField;

@end
