//
//  LSPayFooterView.h
//  LaShouMovie
//
//  Created by Li XiangYu on 13-11-27.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSCountDownView.h"
#import "LSOrder.h"

@protocol LSPayFooterViewDelegate;
@interface LSPayFooterView : UIView<LSCountDownViewDelegate>
{
    LSCountDownView* _countDownView;
    UIButton* _payButton;
    
    LSOrder* _order;
    id<LSPayFooterViewDelegate> _delegate;
}
@property(nonatomic,retain) LSOrder* order;
@property(nonatomic,assign) id<LSPayFooterViewDelegate> delegate;

- (void)stopCountDown;
- (void)resetCountDown;

@end

@protocol LSPayFooterViewDelegate <NSObject>

- (void)LSPayFooterViewDidTimeOut;
- (void)LSPayFooterViewDidToPayByPayType:(LSPayType)payType;

@end
