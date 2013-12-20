//
//  LSCreateOrderViewController.h
//  LaShouMovie
//
//  Created by Li XiangYu on 13-9-23.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSViewController.h"
#import "LSOrder.h"
#import "LSPayViewController.h"

@protocol LSCreateOrderViewControllerDelegate;
@interface LSCreateOrderViewController : LSViewController<UITextFieldDelegate,UIAlertViewDelegate,LSPayViewControllerDelegate>
{
    UITextField* _mobileTextField;
    UIButton* _submitButton;
    
    LSOrder* _order;
    id<LSCreateOrderViewControllerDelegate> _delegate;
}
@property(nonatomic,retain) LSOrder* order;
@property(nonatomic,assign) id<LSCreateOrderViewControllerDelegate> delegate;

@end

@protocol LSCreateOrderViewControllerDelegate <NSObject>

- (void)LSCreateOrderViewControllerDidCreateOrder;

@end
