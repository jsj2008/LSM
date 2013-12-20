//
//  LSViewController.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-8-29.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSViewController.h"
#import "LSAlertView.h"

#import "MobClick.h"
#import "LSAppDelegate.h"

@interface LSViewController ()

@end

@implementation LSViewController

@synthesize isShowBackBarButton=_isShowBackBarButton;
@synthesize internetStatusRemindType=_internetStatusRemindType;

#pragma mark- 属性方法
- (void)setIsShowBackBarButton:(BOOL)isShowBackBarButton
{
    _isShowBackBarButton=isShowBackBarButton;
    if(!_isShowBackBarButton)
    {
        self.navigationItem.leftBarButtonItem=nil;
    }
}

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
    LSLOG(@"控制器销毁%@",[self class]);
    [super dealloc];
}

- (id)init
{
    self=[super init];
    if(self!=nil)
    {
        _isShowBackBarButton=YES;
    }
    return self;
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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
    //实例化用户
    user=[LSUser currentUser];
    
    //实例化消息中心
    messageCenter=[LSMessageCenter defaultCenter];
    [messageCenter addObserver:self selector:@selector(networkStatusChanged:) name:LSNotificationNetworkStatusChanged object:nil];
    
#if TARGET_IPHONE_SIMULATOR
    
#elif TARGET_OS_IPHONE
    UIWindow* window=((LSAppDelegate*)([UIApplication sharedApplication].delegate)).window;
    hud=[[MBProgressHUD alloc] initWithWindow:window];
    hud.dimBackground=YES;
    [window addSubview:hud];
    [window bringSubviewToFront:hud];
    [hud release];
#endif
    
    if(_isShowBackBarButton)
    {
        //返回按钮
        UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0, 0, 51, 31);
        backButton.backgroundColor = [UIColor clearColor];
        [backButton setBackgroundImage:[UIImage lsImageNamed:@"nav_item_back.png"] forState:UIControlStateNormal];
        [backButton setBackgroundImage:[UIImage lsImageNamed:@"nav_item_back_d.png"] forState:UIControlStateHighlighted];
        [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        backButton.titleLabel.font = LSFont15;
        [backButton setTitleEdgeInsets:UIEdgeInsetsMake(-1, 8, 0, 0)];
        [backButton setTitle:@"返回" forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem* backBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItem=backBarButtonItem;
        [backBarButtonItem release];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(_internetStatusRemindType==LSInternetStatusRemindTypeImage)
    {
        if(_nonInternetImageView==nil)
        {
            //断网提示
            _nonInternetImageView=[[UIImageView alloc] init];
            _nonInternetImageView.frame=CGRectMake(0.f, 0.f, self.view.width, self.view.height);
            _nonInternetImageView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
            _nonInternetImageView.backgroundColor=[UIColor whiteColor];
            _nonInternetImageView.contentMode=UIViewContentModeCenter;
            _nonInternetImageView.image=[UIImage lsImageNamed:@"no_wifi.png"];
            _nonInternetImageView.userInteractionEnabled=YES;
            [self.view addSubview:_nonInternetImageView];
            [_nonInternetImageView release];
            _nonInternetImageView.hidden=YES;
            
            //断网提示手势
            UITapGestureRecognizer* tapGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nonInternetImageViewTap:)];
            [_nonInternetImageView addGestureRecognizer:tapGestureRecognizer];
            [tapGestureRecognizer release];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if(user.networkStatus==NotReachable)
    {
        [self networkStatusChanged:nil];
    }
    [MobClick beginLogPageView:[NSString stringWithFormat:@"%s", __FILE__]];
}

- (void)viewDidDisAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MobClick endLogPageView:[NSString stringWithFormat:@"%s", __FILE__]];
}


#pragma mark- 返回按钮的方法
- (void)backButtonClick:(UIButton*)sender
{
    LSLOG(@"执行了父类backButtonClick方法");
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark- 断网提示手势方法
- (void)nonInternetImageViewTap:(UITapGestureRecognizer*)recognizer
{
    if(user.networkStatus!=NotReachable)
    {
        [self networkStatusChanged:nil];
        [self refreshBecauseInternet];
    }
}
- (void)refreshBecauseInternet
{
    LSLOG(@"执行了父类refreshBecauseInternet方法");
}



#pragma mark- 网络状态的监视方法
- (void)showNonInternetImageView
{
    if (_nonInternetImageView)
    {
        //显示提示
        _nonInternetImageView.hidden=NO;
        [self.view bringSubviewToFront:_nonInternetImageView];
    }
}
- (void)networkStatusChanged:(NSNotification*)notification//网络类型变化判断
{
    switch (user.networkStatus)
    {
        case NotReachable:
            LSLOG(@"当前无网络连接");
            
            if(_internetStatusRemindType==LSInternetStatusRemindTypeImage)
            {
                //七秒显示无网络连接
                [self performSelector:@selector(showNonInternetImageView) withObject:nil afterDelay:7.f];
            }
            else if(_internetStatusRemindType==LSInternetStatusRemindTypeAlert)
            {
                [LSAlertView showWithView:self.view message:@"当前网络不可用" time:1.5];
            }
            else
            {
                //if(self==self.navigationController.topViewController && self.navigationController==self.navigationController.tabBarController.selectedViewController)
                if(self.view.window!=nil)
                {
                    [self refreshBecauseInternet];
                }
            }
            
            break;
        case ReachableViaWiFi:
            LSLOG(@"当前连接WIFI");
            
            if(_internetStatusRemindType==LSInternetStatusRemindTypeImage)
            {
                if(_nonInternetImageView.hidden)
                {
                    //取消显示
                    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showNonInternetImageView) object:nil];
                }
                else
                {
                    //隐藏提示
                    _nonInternetImageView.hidden=YES;
                    [self.view sendSubviewToBack:_nonInternetImageView];
                    //if(self==self.navigationController.topViewController && self.navigationController==self.navigationController.tabBarController.selectedViewController)
                    if(self.view.window!=nil)
                    {
                        [self refreshBecauseInternet];
                    }
                }
            }
            else if(_internetStatusRemindType==LSInternetStatusRemindTypeNon)
            {
                //if(self==self.navigationController.topViewController && self.navigationController==self.navigationController.tabBarController.selectedViewController)
                if(self.view.window!=nil)
                {
                    [self refreshBecauseInternet];
                }
            }
            
            break;
        case ReachableViaWWAN:
            LSLOG(@"当前连接3G");
            
            if(_internetStatusRemindType==LSInternetStatusRemindTypeImage)
            {
                if(_nonInternetImageView.hidden)
                {
                    //取消显示
                    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showNonInternetImageView) object:nil];
                }
                else
                {
                    //隐藏提示
                    _nonInternetImageView.hidden=YES;
                    [self.view sendSubviewToBack:_nonInternetImageView];
                    //if(self==self.navigationController.topViewController && self.navigationController==self.navigationController.tabBarController.selectedViewController)
                    if(self.view.window!=nil)
                    {
                        [self refreshBecauseInternet];
                    }
                }
            }
            else if(_internetStatusRemindType==LSInternetStatusRemindTypeNon)
            {
                //if(self==self.navigationController.topViewController && self.navigationController==self.navigationController.tabBarController.selectedViewController)
                if(self.view.window!=nil)
                {
                    [self refreshBecauseInternet];
                }
            }
            
            break;
        default:
            LSLOG(@"当前有网络连接状态未知");
            
            if(_internetStatusRemindType==LSInternetStatusRemindTypeImage)
            {
                //七秒显示无网络连接
                [self performSelector:@selector(showNonInternetImageView) withObject:nil afterDelay:7.f];
            }
            else if(_internetStatusRemindType==LSInternetStatusRemindTypeAlert)
            {
                [LSAlertView showWithView:self.view message:@"当前网络不可用" time:1.5];
            }
            else
            {
                //if(self==self.navigationController.topViewController && self.navigationController==self.navigationController.tabBarController.selectedViewController)
                if(self.view.window!=nil)
                {
                    [self refreshBecauseInternet];
                }
            }
    }
}

#pragma mark- 检查响应数据是否为空的方法
- (BOOL)checkIsNotEmpty:(id)object
{
    if(object==NULL || object==[NSNull null] || object==nil)
    {
        return NO;
    }
    return YES;
}

#pragma mark- 设置右侧按钮
- (void)setBarButtonItemWithImageName:(NSString *)imageName clickedImageName:(NSString *)clickedImageName isRight:(BOOL)isRight buttonType:(LSOtherButtonType)buttonType
{
    if (self.navigationController==nil)
        return;
    else
    {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag=buttonType;
        button.frame = CGRectMake(0, 0, 56, 44);
        button.backgroundColor = [UIColor clearColor];
        [button setBackgroundImage:[UIImage lsImageNamed:imageName] forState:UIControlStateNormal];
        if (clickedImageName)
        {
            [button setBackgroundImage:[UIImage lsImageNamed:clickedImageName] forState:UIControlStateHighlighted];
        }
        [button addTarget:self action:@selector(otherButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem* barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        if (isRight)
        {
            _rightButtonType=buttonType;
            self.navigationItem.rightBarButtonItem = barButtonItem;
        }
        else
        {
            self.navigationItem.leftBarButtonItem = barButtonItem;
        }
        [barButtonItem release];
    }
}
- (void)setBarButtonItemWithImageName:(NSString *)imageName clickedImageName:(NSString *)clickedImageName title:(NSString*)title isRight:(BOOL)isRight buttonType:(LSOtherButtonType)buttonType
{
    if (self.navigationController==nil)
        return;
    else
    {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag=buttonType;
        button.frame = CGRectMake(0, 0, 51, 31);
        button.backgroundColor = [UIColor clearColor];
        [button setBackgroundImage:[UIImage stretchableImageWithImage:[UIImage lsImageNamed:imageName] top:31 left:10 bottom:31 right:10]  forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = LSFont15;
        [button setTitle:title forState:UIControlStateNormal];
        
        if (clickedImageName)
        {
            [button setBackgroundImage:[UIImage stretchableImageWithImage:[UIImage lsImageNamed:clickedImageName] top:31 left:10 bottom:31 right:10] forState:UIControlStateHighlighted];
        }
        [button addTarget:self action:@selector(otherButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem* barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        if (isRight)
        {
            _rightButtonType=buttonType;
            self.navigationItem.rightBarButtonItem = barButtonItem;
        }
        else
        {
            self.navigationItem.leftBarButtonItem = barButtonItem;
        }
        [barButtonItem release];
    }
}
- (void)otherButtonClick:(UIButton*)sender
{
    LSLOG(@"执行了父类otherButtonClick方法");
    if(sender.tag==LSOtherButtonTypeChangeCity)
    {
        return;
    }
    
    if(user.networkStatus==NotReachable)
    {
        if(sender.tag!=LSOtherButtonTypeNon)
        {
            _rightButtonType=sender.tag;
            sender.tag=LSOtherButtonTypeNon;
        }
    }
    else
    {
        sender.tag=_rightButtonType;
    }
}

#pragma mark- UIGestureRecognizer委托方法
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIControl class]])
    {
        return NO;
    }
    return YES;
}

@end
