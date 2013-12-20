//
//  LSUnionLoginView.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-18.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSUnionLoginViewDelegate;
@interface LSUnionLoginView : UIView
{
    id<LSUnionLoginViewDelegate> _delegate;
}
@property(nonatomic,assign) id<LSUnionLoginViewDelegate> delegate;

@end

@protocol LSUnionLoginViewDelegate <NSObject>

@required
- (void)LSUnionLoginView:(LSUnionLoginView*)unionLoginView didClickUnionLoginButton:(UIButton*)unionLoginButton;

@end
