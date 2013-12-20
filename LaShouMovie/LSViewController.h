//
//  LSViewController.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-8-29.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface LSViewController : UIViewController<UIAlertViewDelegate,UIGestureRecognizerDelegate>
{
    UIImageView* _nonInternetImageView;
    MBProgressHUD* hud;
    LSUser* user;
    LSMessageCenter* messageCenter;
    BOOL _isShowBackBarButton;
    LSInternetStatusRemindType _internetStatusRemindType;
    LSOtherButtonType _rightButtonType;
}
@property(nonatomic,assign) BOOL isShowBackBarButton;
@property(nonatomic,assign) LSInternetStatusRemindType internetStatusRemindType;

- (void)setBarButtonItemWithImageName:(NSString *)imageName clickedImageName:(NSString *)clickedImageName isRight:(BOOL)isRight buttonType:(LSOtherButtonType)buttonType;
- (void)setBarButtonItemWithImageName:(NSString *)imageName clickedImageName:(NSString *)clickedImageName title:(NSString*)title isRight:(BOOL)isRight buttonType:(LSOtherButtonType)buttonType;

//此方法可重写
- (void)backButtonClick:(UIButton*)sender;
- (void)refreshBecauseInternet;
- (BOOL)checkIsNotEmpty:(id)object;//检查数据是否不为空
- (void)otherButtonClick:(UIButton*)sender;

@end
