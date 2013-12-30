//
//  LSPaidWrongView.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-30.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSPaidWrongViewDelegate;
@interface LSPaidWrongView : UIView
{
    //200.f
    UIButton* _rebuyButton;
    id<LSPaidWrongViewDelegate> _delegate;
}
@property(nonatomic,assign)id<LSPaidWrongViewDelegate> delegate;

@end

@protocol LSPaidWrongViewDelegate <NSObject>

@required
- (void)LSPaidWrongView:(LSPaidWrongView*)paidWrongView didClickRebuyButton:(UIButton*)rebuyButton;

@end
