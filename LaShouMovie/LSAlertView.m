//
//  LSAlertView.m
//  LaShouMovie
//
//  Created by Li XiangYu on 13-9-24.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSAlertView.h"
#import <UIKit/UIAlertView.h>
#import "MBProgressHUD.h"

@implementation LSAlertView

+ (void)showWithTag:(int)tag title:(NSString *)title message:(NSString *)message delegate:(id <UIAlertViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    UIAlertView* alertView=[[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    alertView.tag = tag;
    [alertView show];
    [alertView release];
}

+ (void)showWithView:(UIView*)view message:(NSString *)message time:(CGFloat)time
{
    MBProgressHUD* hud=[[MBProgressHUD alloc] initWithView:view];
    hud.mode=MBProgressHUDModeText;
    hud.labelText=message;
    [view addSubview:hud];
    [view bringSubviewToFront:hud];
    [hud showAnimated:YES whileExecutingBlock:^{
        sleep(time);
    }];
}

+ (void)showWithView:(UIView*)view message:(NSString *)message time:(CGFloat)time completion:(void (^)())completion
{
    MBProgressHUD* hud=[[MBProgressHUD alloc] initWithView:view];
    hud.mode=MBProgressHUDModeText;
    hud.labelText=message;
    [view addSubview:hud];
    [view bringSubviewToFront:hud];
    [hud showAnimated:YES whileExecutingBlock:^{
        sleep(time);
    } completionBlock:completion];
}

+ (void)showWithView:(UIView*)view from:(LSAlertViewFrom)from message:(NSString *)message time:(CGFloat)time
{
    if(message==nil)
        return;
    
    NSLineBreakMode lineBreakMode=NSLineBreakByCharWrapping;
    CGSize size=[message sizeWithFont:LSFont15 constrainedToSize:CGSizeMake(view.width, INT32_MAX) lineBreakMode:lineBreakMode];
    
    UIView* alertView=[[UIView alloc] init];
    alertView.backgroundColor=[UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.6];
    [view addSubview:alertView];
    [view bringSubviewToFront:alertView];
    [alertView release];
    
    if(view.height<size.height)
    {
        lineBreakMode=NSLineBreakByTruncatingTail;
    }
    
    if(from==LSAlertViewFromTop)
    {
        if(view.height>size.height)
        {
            alertView.frame=CGRectMake(0.f, -size.height, view.width, size.height);
        }
        else
        {
            alertView.frame=CGRectMake(0.f, -view.height, view.width, view.height);
        }
    }
    else if(from==LSAlertViewFromLeft)
    {
        if(view.height>size.height)
        {
            alertView.frame=CGRectMake(-size.width, (view.height-size.height)/2, size.width, size.height);
        }
        else
        {
            alertView.frame=CGRectMake(-size.width, 0.f, size.width, view.height);
        }
    }
    else if(from==LSAlertViewFromBottom)
    {
        if(view.height>size.height)
        {
            alertView.frame=CGRectMake(0.f, view.height, view.width, size.height);
        }
        else
        {
            alertView.frame=CGRectMake(0.f, view.height, view.width, view.height);
        }
    }
    else if(from==LSAlertViewFromRight)
    {
        if(view.height>size.height)
        {
            alertView.frame=CGRectMake(view.width, (view.height-size.height)/2, size.width, size.height);
        }
        else
        {
            alertView.frame=CGRectMake(view.width, 0.f, size.width, view.height);
        }
    }
    
    UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, alertView.width, alertView.height)];
    label.backgroundColor=[UIColor clearColor];
    label.font=LSFont15;
    label.textColor=[UIColor whiteColor];
    label.lineBreakMode=lineBreakMode;
    label.text=message;
    [alertView addSubview:label];
    [label release];
    
    [UIView animateWithDuration:0.7f animations:^{
        
        if(from==LSAlertViewFromTop)
        {
            alertView.frame=CGRectMake(alertView.left, 0.f, alertView.width, alertView.height);
        }
        else if(from==LSAlertViewFromLeft)
        {
            alertView.frame=CGRectMake(0.f, alertView.top, alertView.width, alertView.height);
        }
        else if(from==LSAlertViewFromBottom)
        {
            alertView.frame=CGRectMake(alertView.left, view.height-alertView.height, alertView.width, alertView.height);
        }
        else if(from==LSAlertViewFromRight)
        {
            alertView.frame=CGRectMake(view.width-alertView.width, alertView.top, alertView.width, alertView.height);
        }
    } completion:^(BOOL finished) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
            sleep(time);
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                
                [UIView animateWithDuration:0.7f animations:^{
                    
                    if(from==LSAlertViewFromTop)
                    {
                        alertView.frame=CGRectMake(alertView.left, -alertView.height, alertView.width, alertView.height);
                    }
                    else if(from==LSAlertViewFromLeft)
                    {
                        alertView.frame=CGRectMake(-alertView.width, alertView.top, alertView.width, alertView.height);
                    }
                    else if(from==LSAlertViewFromBottom)
                    {
                        alertView.frame=CGRectMake(alertView.left, view.height, alertView.width, alertView.height);
                    }
                    else if(from==LSAlertViewFromRight)
                    {
                        alertView.frame=CGRectMake(view.width, alertView.top, alertView.width, alertView.height);
                    }
                } completion:^(BOOL finished) {
                    
                    [alertView removeFromSuperview];
                }];
            });
        });
    }];
}

@end
