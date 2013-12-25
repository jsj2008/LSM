//
//  LSCreateOrderFooterView.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-25.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSCreateOrderFooterViewDelegate;
@interface LSCreateOrderFooterView : UIView
{
    UITextField* _phoneTextField;
    UIButton* _submitButton;
    id<LSCreateOrderFooterViewDelegate> _delegate;
}
@property(nonatomic,assign) id<LSCreateOrderFooterViewDelegate> delegate;

@end

@protocol LSCreateOrderFooterViewDelegate <NSObject>

@required
- (void)LSCreateOrderFooterView:(LSCreateOrderFooterView*)createOrderFooterView didClickSubmitButton:(UIButton*)submitButton;

@end
