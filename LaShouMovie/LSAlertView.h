//
//  LSAlertView.h
//  LaShouMovie
//
//  Created by Li XiangYu on 13-9-24.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSAlertView : NSObject

+ (void)showWithTag:(int)tag title:(NSString *)title message:(NSString *)message delegate:(id <UIAlertViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;
+ (void)showWithView:(UIView*)view message:(NSString *)message time:(CGFloat)time;
+ (void)showWithView:(UIView*)view message:(NSString *)message time:(CGFloat)time completion:(void (^)())completion;
+ (void)showWithView:(UIView*)view from:(LSAlertViewFrom)from message:(NSString *)message time:(CGFloat)time;

@end
