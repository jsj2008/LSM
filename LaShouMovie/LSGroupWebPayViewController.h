//
//  LSGroupPayViewController.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-10.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSViewController.h"
#import "LSGroupOrder.h"

@protocol LSGroupWebPayViewControllerDelegate;
@interface LSGroupWebPayViewController : LSViewController<UIWebViewDelegate>
{
    LSGroupOrder* _groupOrder;
    id<LSGroupWebPayViewControllerDelegate> _delegate;
    BOOL _isAliWap;
    BOOL _isBalanceWap;
}
@property(nonatomic,retain) LSGroupOrder* groupOrder;
@property(nonatomic,assign) id<LSGroupWebPayViewControllerDelegate> delegate;

@end

@protocol LSGroupWebPayViewControllerDelegate <NSObject>

@required
- (void)LSGroupWebPayViewControllerDidPay;

@end
