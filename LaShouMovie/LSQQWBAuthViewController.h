//
//  LSQQWBAuthViewController.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-24.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSViewController.h"

@protocol LSQQWBAuthViewControllerDelegate;
@interface LSQQWBAuthViewController : LSViewController<UIWebViewDelegate>
{
    UIWebView* _webView;
    id<LSQQWBAuthViewControllerDelegate> _delegate;
}
@property(nonatomic,assign) id<LSQQWBAuthViewControllerDelegate> delegate;

@end

@protocol LSQQWBAuthViewControllerDelegate <NSObject>

- (void)LSQQWBAuthViewControllerDidLogin;

@end
