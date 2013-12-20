//
//  LSADWebViewController.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-17.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSViewController.h"
#import "LSActivity.h"

@interface LSADWebViewController : LSViewController<UIWebViewDelegate>
{
    UIWebView* _webView;
    LSActivity* _activity;
}
@property(nonatomic,retain) LSActivity* activity;

@end
