//
//  LSTableViewController.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-9.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewController.h"
#import "MobClick.h"
#import "LSAppDelegate.h"
#import "LSTabBarItem.h"

@interface LSTableViewController ()

@end

@implementation LSTableViewController

@synthesize leftBarButtonSystemItem=_leftBarButtonSystemItem;
@synthesize rightBarButtonSystemItem=_rightBarButtonSystemItem;
@synthesize tabIndex=_tabIndex;

#pragma mark- 属性方法
- (void)setLeftBarButtonSystemItem:(UIBarButtonSystemItem)leftBarButtonSystemItem
{
    if(leftBarButtonSystemItem<0)
    {
        self.navigationItem.leftBarButtonItem=nil;
    }
    else
    {
        UIBarButtonItem* leftBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:leftBarButtonSystemItem target:self action:@selector(leftBarButtonItemClick:)];
        self.navigationItem.leftBarButtonItem=leftBarButtonItem;
        [leftBarButtonItem release];
    }
}
- (void)setRightBarButtonSystemItem:(UIBarButtonSystemItem)rightBarButtonSystemItem
{
    if(rightBarButtonSystemItem<0)
    {
        self.navigationItem.rightBarButtonItem=nil;
    }
    else
    {
        UIBarButtonItem* rightBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:rightBarButtonSystemItem target:self action:@selector(rightBarButtonItemClick:)];
        self.navigationItem.rightBarButtonItem=rightBarButtonItem;
        [rightBarButtonItem release];
    }
}
- (void)setTabIndex:(NSInteger)tabIndex
{
    _tabIndex=tabIndex;
    
    NSArray* titleArray=[NSArray arrayWithObjects:@"电影", @"影院", @"我的", @"设置", nil];
    LSTabBarItem* tabBarItem=[[LSTabBarItem alloc] initWithTitle:[titleArray objectAtIndex:_tabIndex] image:[UIImage lsImageNamed:[NSString stringWithFormat:@"tab_%d_nor.png",_tabIndex]] selectedImage:[UIImage lsImageNamed:[NSString stringWithFormat:@"tab_%d_sel.png",_tabIndex]]];
    tabBarItem.tag=_tabIndex;
    self.tabBarItem=tabBarItem;
    [tabBarItem release];
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

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem* backBarButtonItem = [[[UIBarButtonItem alloc] init] autorelease];
    backBarButtonItem.title = @"";
    self.navigationItem.backBarButtonItem=backBarButtonItem;
    
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.showsHorizontalScrollIndicator=NO;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundView=nil;
    self.view.backgroundColor=LSColorBackgroundGray;
    
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark- 激活下拉刷新
- (void)initRefreshControl
{
    if(LSiOS6)
    {
        self.refreshControl = [[[UIRefreshControl alloc] init] autorelease];
        //self.refreshControl.tintColor = [UIColor blueColor];
        self.refreshControl.attributedTitle = [[[NSAttributedString alloc] initWithString:@"刷新"] autorelease];
        [self.refreshControl addTarget:self action:@selector(refreshControlEventValueChanged) forControlEvents:UIControlEventValueChanged];
    }
}
- (void)refreshControlEventValueChanged
{
    LSLOG(@"执行了父类RefreshControlEventValueChanged方法");
}

#pragma mark- 导航按钮的单击方法
- (void)leftBarButtonItemClick:(UIBarButtonItem*)sender
{
    LSLOG(@"执行了父类leftBarButtonItemClick方法");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonItemClick:(UIBarButtonItem*)sender
{
    LSLOG(@"执行了父类rightBarButtonItemClick方法");
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
- (void)alertNonInternet
{
    //提示当前无网络连接
}
- (void)networkStatusChanged:(NSNotification*)notification//网络类型变化判断
{
    switch (user.networkStatus)
    {
        case NotReachable:
            LSLOG(@"当前无网络连接");
            
            if(self.view.window!=nil)
            {
                //七秒显示无网络连接
                [self performSelector:@selector(alertNonInternet) withObject:nil afterDelay:7.f];
            }
            break;
        case ReachableViaWiFi:
            LSLOG(@"当前连接WIFI");
            
            //取消显示
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(alertNonInternet) object:nil];
            break;
        case ReachableViaWWAN:
            LSLOG(@"当前连接3G");
            
            //取消显示
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(alertNonInternet) object:nil];
            break;
        default:
            LSLOG(@"当前有网络连接状态未知");
            
            if(self.view.window!=nil)
            {
                //七秒显示无网络连接
                [self performSelector:@selector(alertNonInternet) withObject:nil afterDelay:7.f];
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
- (void)setBackBarButtonItemWithImageName:(NSString *)imageName selectImageName:(NSString *)selectImageName
{
    if (self.navigationController==nil)
        return;
    else
    {
        UIButton* button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(0.f, 0.f, 44.f, 44.f);
        [button setImage:[UIImage lsImageNamed:imageName] forState:UIControlStateNormal];
        [button setImage:[UIImage lsImageNamed:selectImageName] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(leftBarButtonItemClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* otherBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.backBarButtonItem = otherBarButtonItem;
        [otherBarButtonItem release];
    }
}
- (void)setBarButtonItemWithImageName:(NSString *)imageName isRight:(BOOL)isRight
{
    if (self.navigationController==nil)
        return;
    else
    {
        UIBarButtonItem* otherBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage lsImageNamed:imageName] style:UIBarButtonItemStylePlain target:self action:isRight?@selector(rightBarButtonItemClick:):@selector(leftBarButtonItemClick:)];
        if (isRight)
        {
            self.navigationItem.rightBarButtonItem = otherBarButtonItem;
        }
        else
        {
            self.navigationItem.leftBarButtonItem = otherBarButtonItem;
        }
        [otherBarButtonItem release];
    }
}
- (void)setBarButtonItemWithImageName:(NSString *)imageName selectImageName:(NSString *)selectImageName isRight:(BOOL)isRight
{
    if (self.navigationController==nil)
        return;
    else
    {
        UIButton* button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(0.f, 0.f, 44.f, 44.f);
        [button setImage:[UIImage lsImageNamed:imageName] forState:UIControlStateNormal];
        [button setImage:[UIImage lsImageNamed:selectImageName] forState:UIControlStateHighlighted];
        [button addTarget:self action:isRight?@selector(rightBarButtonItemClick:):@selector(leftBarButtonItemClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem* otherBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        if (isRight)
        {
            self.navigationItem.rightBarButtonItem = otherBarButtonItem;
        }
        else
        {
            self.navigationItem.leftBarButtonItem = otherBarButtonItem;
        }
        [otherBarButtonItem release];
    }
}

- (void)setBarButtonItemWithTitle:(NSString *)title isRight:(BOOL)isRight
{
    if (self.navigationController==nil)
        return;
    else
    {
        UIBarButtonItem* otherBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:isRight?@selector(rightBarButtonItemClick:):@selector(leftBarButtonItemClick:)];
        if (isRight)
        {
            self.navigationItem.rightBarButtonItem = otherBarButtonItem;
        }
        else
        {
            self.navigationItem.leftBarButtonItem = otherBarButtonItem;
        }
        [otherBarButtonItem release];
    }
}

- (void)setBarButtonItemWithTitle:(NSString *)title imageName:(NSString *)imageName isRight:(BOOL)isRight
{
    if (self.navigationController==nil)
        return;
    else
    {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(0.f, 0.f, 54.f, 44.f);
        button.titleLabel.adjustsFontSizeToFitWidth=YES;
        button.titleLabel.textAlignment=NSTextAlignmentLeft;
        button.titleLabel.font = LSFontNavigationButton;
        [button setTitleColor:LSColorWhite forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        
        [button addTarget:self action:isRight?@selector(rightBarButtonItemClick:):@selector(leftBarButtonItemClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView* imageView=[[[UIImageView alloc] initWithImage:[UIImage lsImageNamed:imageName]] autorelease];
        imageView.contentMode=UIViewContentModeRight;
        imageView.frame=CGRectMake(0.f, 0.f, 59.f, 44.f);//下偏2.f
        
        UIView* view=[[[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 59.f, 44.f)] autorelease];
        [view addSubview:button];
        [view addSubview:imageView];

        UIBarButtonItem* otherBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
        if (isRight)
        {
            self.navigationItem.rightBarButtonItem = otherBarButtonItem;
        }
        else
        {
            self.navigationItem.leftBarButtonItem = otherBarButtonItem;
        }
        [otherBarButtonItem release];
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

#pragma mark - UITableView的委托方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
