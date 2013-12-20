//
//  LSLoginFooterView.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-18.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSLoginFooterViewDelegate;
@interface LSLoginFooterView : UIView
{
    UIButton* _loginButton;
    id<LSLoginFooterViewDelegate> _delegate;
}
@property(nonatomic,assign) id<LSLoginFooterViewDelegate> delegate;

@end

@protocol LSLoginFooterViewDelegate <NSObject>

@required
- (void)LSLoginFooterView:(LSLoginFooterView*)loginFooterView didClickLoginButton:(UIButton*)loginButton;

@end
