//
//  LSTabBarController.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-8-29.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTabBarController.h"

#import "LSFilmsViewController.h"
#import "LSCinemasViewController.h"
#import "LSMyViewController.h"
#import "LSSettingViewController.h"
#import "LSNavigationController.h"

#import "LSTabBarItem.h"

#import "LSAppDelegate.h"

@interface LSTabBarController ()

@end

@implementation LSTabBarController

#pragma mark- 旋转设置
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation NS_DEPRECATED_IOS(2_0, 6_0)
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}
- (BOOL)shouldAutorotate
{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;//只支持这一个方向(正常的方向)
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}


#pragma mark- 生命周期
- (void)dealloc
{
    [messageCenter removeObserver:self];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    user=[LSUser currentUser];
    version=[LSVersion currentVersion];
    messageCenter=[LSMessageCenter defaultCenter];
    
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeUpdateAction object:nil];
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeAPNSByByDeviceToken object:nil];
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeLoginAlipayUserInfoByAppID_AuthCode object:nil];
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:LSNotificationLocationChanged object:nil];
    
    if([LSSave obtainForKey:LSWelcome]!=nil)
    {
        [self makeTabBarViewController];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- 私有方法
- (void)makeTabBarViewController
{
    self.tabBar.barTintColor=LSColorTabBlack;
    self.tabBar.tintColor=LSColorWhite;
    self.tabBar.selectionIndicatorImage=[UIImage scaleToSizeWithImageName:@"tab_sel.png" size:CGSizeMake(80.f, self.tabBar.height)];
    
    NSMutableArray* viewControllers=[NSMutableArray arrayWithCapacity:0];
    
    //
    LSFilmsViewController* filmsViewController = [[LSFilmsViewController alloc] init];
    filmsViewController.leftBarButtonSystemItem=LSNO;
    filmsViewController.tabIndex=0;
    
    LSNavigationController* filmsNavigationController = [[LSNavigationController alloc] initWithRootViewController:filmsViewController];
    
    [viewControllers addObject:filmsNavigationController];
    [filmsNavigationController release];
    [filmsViewController release];
    
    
    //
    LSCinemasViewController* cinemasViewController = [[LSCinemasViewController alloc] init];
    cinemasViewController.leftBarButtonSystemItem=LSNO;
    cinemasViewController.tabIndex=1;
    
    LSNavigationController* cinemasNavigationController = [[LSNavigationController alloc] initWithRootViewController:cinemasViewController];
    cinemasNavigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    [viewControllers addObject:cinemasNavigationController];
    [cinemasNavigationController release];
    [cinemasViewController release];
    
    
    //
    LSMyViewController* myViewController = [[LSMyViewController alloc] init];
    myViewController.leftBarButtonSystemItem=LSNO;
    myViewController.tabIndex=2;
    
    LSNavigationController* myNavigationController = [[LSNavigationController alloc] initWithRootViewController:myViewController];
    
    [viewControllers addObject:myNavigationController];
    [myNavigationController release];
    [myViewController release];
    
    
    //
    LSSettingViewController* settingViewController = [[LSSettingViewController alloc] init];
    settingViewController.leftBarButtonSystemItem=LSNO;
    settingViewController.tabIndex=3;
    
    LSNavigationController* settingNavigationController = [[LSNavigationController alloc] initWithRootViewController:settingViewController];
    
    [viewControllers addObject:settingNavigationController];
    [settingNavigationController release];
    [settingViewController release];
    
    //设置子控制器
    self.viewControllers=viewControllers;
}

- (void)popToMyViewController
{
    LSNavigationController* navigationController=nil;
    LSMyViewController* myViewController=nil;
    if(self.selectedIndex==2)
    {
        navigationController=(LSNavigationController *)(self.selectedViewController);
        if (![navigationController.topViewController isKindOfClass:[LSMyViewController class]])
        {
            LSViewController* viewController=(LSViewController*)(navigationController.topViewController);
            [viewController.navigationController popToRootViewControllerAnimated:NO];
            
            myViewController=(LSMyViewController*)(navigationController.topViewController);
        }
        else
        {
            myViewController=(LSMyViewController*)(navigationController.topViewController);
            [myViewController viewWillAppear:NO];
        }
    }
}

#pragma mark- 通知中心方法
- (void)lsHttpRequestNotification:(NSNotification*)notification
{
    //    if([self checkIsNotEmpty:notification])
    {
        if([notification.object isEqual:lsRequestFailed])
        {
            //超时
            return;
        }
        
        if([notification.object isKindOfClass:[LSStatus class]])
        {
            if([notification.name isEqualToString:lsRequestTypeUpdateAction] && [notification.name isEqualToString:lsRequestTypeAPNSByByDeviceToken] && [notification.name isEqualToString:lsRequestTypeLoginAlipayUserInfoByAppID_AuthCode])
            {
                LSStatus* status=notification.object;
                [LSAlertView showWithTag:-1 title:nil message:status.message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            }
            //状态
            return;
        }
        
        if([notification.object isKindOfClass:[LSError class]])
        {
            //错误
            return;
        }
        
        if([notification.name isEqual:lsRequestTypeUpdateAction])
        {
            [version reset];
            [version completePropertyWithDictionary:notification.object];
            if(![lsSoftwareVersion isEqual:version.version])
            {
                if(version.isPrompt)
                {
                    if(version.isForce)
                    {
                        [LSAlertView showWithTag:1 title:@"升级提醒" message:version.message delegate:self cancelButtonTitle:@"马上升级" otherButtonTitles:nil];
                    }
                    else
                    {
                        [LSAlertView showWithTag:0 title:@"升级提醒" message:version.message delegate:self cancelButtonTitle:@"暂不升级" otherButtonTitles:@"马上升级", nil];
                    }
                }
            }
        }
        else if([notification.name isEqual:lsRequestTypeAPNSByByDeviceToken])
        {
            LSLOG(@"已经提交设备token");
        }
        else if([notification.name isEqual:lsRequestTypeLoginAlipayUserInfoByAppID_AuthCode])
        {
            //{
            //    email = 13161981830;
            //    "extern_token" = appopenB9634f545d8a54a8ab653b1119bd6aeac;
            //    gender = "\U6682\U65e0\U4fe1\U606f";
            //    "is_bank_auth" = F;
            //    "is_certified" = F;
            //    "is_id_auth" = F;
            //    "is_licence_auth" = F;
            //    "is_mobile_auth" = T;
            //    mobile = 13161981830;
            //    password = 96e79218965eb72c92a549dd5a330112;
            //    "real_name" = "\U6682\U65e0\U4fe1\U606f";
            //    uid = 1613133950;
            //    "user_id" = "cali_2088112072281824";
            //    "user_status" = T;
            //    "user_type_value" = 2;
            //}
            LSAlipay* alipay=[LSAlipay currentAlipay];
            alipay.accessToken=[NSString stringWithFormat:@"%@",[notification.object objectForKey:@"extern_token"]];
            
            user.userID=[NSString stringWithFormat:@"%@",[notification.object objectForKey:@"uid"]];
            user.userName=[NSString stringWithFormat:@"%@",[notification.object objectForKey:@"user_id"]];
            user.password=[NSString stringWithFormat:@"%@",[notification.object objectForKey:@"password"]];
            user.mobile=[NSString stringWithFormat:@"%@",[notification.object objectForKey:@"mobile"]];
            user.loginType=LSLoginTypeAlipay;
            if([LSSave saveUser])
            {
                LSLOG(@"已经保存了User信息");
            }
            
            [self popToMyViewController];
            [messageCenter postNotificationName:LSNotificationAlipayUserInfo object:nil];
        }
        else if([notification.name isEqual:LSNotificationLocationChanged])
        {
            if([LSSave obtainForKey:LSWelcome]!=nil)
            {
                [LSAlertView showWithTag:2 title:nil message:[NSString stringWithFormat:@"系统定位到您当前的城市是%@，是否要切换城市？",user.locationCityName] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            }
        }
    }
}


#pragma mark- 公共方法
- (void)selectCity
{
    LSCitiesViewController* citiesViewController=[[LSCitiesViewController alloc] init];
    citiesViewController.delegate=self;
    
    LSNavigationController* navigationController=[[LSNavigationController alloc] initWithRootViewController:citiesViewController];
    [self presentViewController:navigationController animated:YES completion:^{}];
    
    [citiesViewController release];
    [navigationController release];
}


#pragma mark- LSTabBar的委托方法
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if(item.tag!=2)
    {
        self.selectedIndex=item.tag;
    }
    else
    {
        if(user.userID!=nil && user.password!=nil)
        {
            self.selectedIndex=item.tag;
        }
        else
        {
            LSLoginViewController* loginViewController=[[LSLoginViewController alloc] init];
            loginViewController.delegate=self;
            
            LSNavigationController* navigationController=[[LSNavigationController alloc] initWithRootViewController:loginViewController];
            [self presentViewController:navigationController animated:YES completion:^{}];
            
            [loginViewController release];
            [navigationController release];
        }
    }
}

#pragma mark- LSCitiesViewController的委托方法
- (void)LSCitiesViewControllerDidSelect
{
    [self dismissViewControllerAnimated:YES completion:^{}];
    [self makeTabBarViewController];
    if([LSSave obtainForKey:LSWelcome]==nil)
    {
        [LSSave saveObject:LSWelcome forKey:LSWelcome];
    }
}

#pragma mark- LSLoginViewController的委托方法
- (void)LSLoginViewControllerDidLoginByType:(LSLoginType)loginType
{
    [self dismissViewControllerAnimated:YES completion:^{}];
    if(loginType==LSLoginTypeNon)//未成功登陆
    {
        self.selectedIndex=0;
    }
    else
    {
        self.selectedIndex=2;
    }
}

#pragma mark- UIAlertView的委托方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==0)
    {
        if(buttonIndex!=alertView.cancelButtonIndex)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:version.downloadURL]];
        }
    }
    if(alertView.tag==1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:version.downloadURL]];
    }
    else if(alertView.tag==2)
    {
        if(buttonIndex!=alertView.cancelButtonIndex)
        {
            user.cityID=user.locationCityID;
            user.cityName=user.locationCityName;
            
            if([LSSave saveUser])
            {
                LSLOG(@"已经修改用户城市并保存了User信息");
            }
            
            LSViewController* viewController=(LSViewController*)(((UINavigationController*)self.selectedViewController).topViewController);
            if([viewController isKindOfClass:[LSFilmsViewController class]] || [viewController isKindOfClass:[LSCinemasViewController class]])
            {
                [viewController refreshBecauseInternet];
            }
        }
    }
}

@end
