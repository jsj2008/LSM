//
//  LSQQAuthViewController.h
//  LaShouMovie
//
//  Created by Li XiangYu on 13-9-21.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSViewController.h"

@protocol LSQQAuthViewControllerDelegate;
@interface LSQQAuthViewController : LSViewController<UIWebViewDelegate>
{
    UIWebView* _webView;
    id<LSQQAuthViewControllerDelegate> _delegate;
}
@property(nonatomic,assign) id<LSQQAuthViewControllerDelegate> delegate;

@end

@protocol LSQQAuthViewControllerDelegate <NSObject>

- (void)LSQQAuthViewControllerDidLogin;

@end
