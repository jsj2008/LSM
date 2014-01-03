//
//  LSQuickBuyView.h
//  LaShouMovie
//
//  Created by LiXiangYu on 14-1-3.
//  Copyright (c) 2014年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSQuickBuyViewDelegate;
@interface LSQuickBuyView : UIView
{
    id<LSQuickBuyViewDelegate> _delegate;
}
@property(nonatomic,assign) id<LSQuickBuyViewDelegate> delegate;

@end

@protocol LSQuickBuyViewDelegate <NSObject>

@required
- (void)LSQuickBuyViewDidClick:(LSQuickBuyView*)quickBuyView;

@end
