//
//  LSSecurityCodeView.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-29.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSSecurityCodeViewDelegate;
@interface LSSecurityCodeView : UIView
{
    UITextField* _codeTextField;
    id<LSSecurityCodeViewDelegate> _delegate;
}
@property(nonatomic,assign) id<LSSecurityCodeViewDelegate> delegate;

@end

@protocol LSSecurityCodeViewDelegate <NSObject>

- (void)LSSecurityCodeView:(LSSecurityCodeView*)securityCodeView didPayWithSecurityCode:(NSString*)securityCode;

@end
