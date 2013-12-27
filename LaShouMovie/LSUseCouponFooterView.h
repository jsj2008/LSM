//
//  LSCouponFooterView.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-11-28.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSUseCouponFooterViewDelegate;
@interface LSUseCouponFooterView : UIView
{
    UIButton* _useButton;
    id<LSUseCouponFooterViewDelegate> _delegate;
}
@property(nonatomic,assign)id<LSUseCouponFooterViewDelegate> delegate;

@end

@protocol LSUseCouponFooterViewDelegate <NSObject>

@required
- (void)LSUseCouponFooterView:(LSUseCouponFooterView*)useCouponFooterView didClickUseButton:(UIButton*)useButton;

@end
