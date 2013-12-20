//
//  LSRegisterFooterView.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-18.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSRegisterFooterViewDelegate;
@interface LSRegisterFooterView : UIView
{
    UIButton* _registerButton;
    id<LSRegisterFooterViewDelegate> _delegate;
}
@property(nonatomic,assign) id<LSRegisterFooterViewDelegate> delegate;

@end

@protocol LSRegisterFooterViewDelegate <NSObject>

@required
- (void)LSRegisterFooterView:(LSRegisterFooterView*)registerFooterView didClickRegisterButton:(UIButton*)registerButton;

@end
