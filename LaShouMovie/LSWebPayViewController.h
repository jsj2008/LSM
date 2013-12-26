//
//  LSWebPayViewController.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-26.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSViewController.h"

@protocol LSWebPayViewControllerDelegate;
@interface LSWebPayViewController : LSViewController<UIWebViewDelegate>
{
    NSURLRequest* _request;
    id<LSWebPayViewControllerDelegate> _delegate;
}
@property(nonatomic,retain) NSURLRequest* request;
@property(nonatomic,assign) id<LSWebPayViewControllerDelegate> delegate;

@end

@protocol LSWebPayViewControllerDelegate <NSObject>

@required
- (void)LSWebPayViewControllerDidPay;

@end
