//
//  LSSinaWBAuthViewController.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-24.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSViewController.h"

@protocol LSSinaWBAuthViewControllerDelegate;
@interface LSSinaWBAuthViewController : LSViewController<UIWebViewDelegate>
{
    UIWebView* _webView;
    id<LSSinaWBAuthViewControllerDelegate> _delegate;
    
    NSMutableData* _responsMData;
}
@property(nonatomic,assign) id<LSSinaWBAuthViewControllerDelegate> delegate;

@end

@protocol LSSinaWBAuthViewControllerDelegate <NSObject>

- (void)LSSinaWBAuthViewControllerDidLogin;

@end
