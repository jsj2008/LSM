//
//  LSAppDelegate.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-8-22.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSAppDelegate.h"
#import "MobClick.h"
#import "LSLocationManager.h"

#import "AlixPayResult.h"
#import "NSURL+scheme.h"

@implementation LSAppDelegate

@synthesize loadUserInfo=_loadUserInfo;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#ifdef LSDEBUG
    NSLog(@"\n%@\n",NSHomeDirectory());
#endif
    //设置状态栏文字颜色
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    
    messageCenter=[LSMessageCenter defaultCenter];
    
    [UIImage setIsRetina];//设置一个全局的屏幕变量
    [LSSave setUserDefaults];//设置全局的用户信息存储变量
    user=[LSUser currentUser];
    [user copyPreUser:[LSSave obtainUser]];//获取上次存储的用户信息
    [LSLocationManager start];//开始定位
    
    //启动网络监控
    [self startInternetMonitor];
    
    //友盟的方法本身是异步执行，所以不需要再异步调用
    [self initUMAnalyticsSDK];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    tabBarController=[[LSTabBarController alloc] init];
    self.window.rootViewController=tabBarController;
    [tabBarController release];
    
    /*
    if([LSSave obtainForKey:LSWelcome]==nil)
    {
        LSWelcomeView* welcomeView=[[LSWelcomeView alloc] initWithFrame:CGRectMake(0.f, 20.f, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
        welcomeView.delegate=self;
        [self.window addSubview:welcomeView];
        [self.window bringSubviewToFront:welcomeView];
        [welcomeView release];
    }
     */

    
    //启动推送功能
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    
    //判断程序是不是由推送服务启动的
    if (launchOptions)
    {
        //launchOptions包装了userInfo
        NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if(userInfo)
        {
//    {
//        activityId = 2162;
//        aps =     {
//            alert = "\U54c7\U585e\Uff0c\U5a03\U5a03\U8138\U4f60\U597d\U5e05\U554a\Uff01";
//            badge = 2;
//            sound = default;
//        };
//        type = 1;
//    }
        }
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    if(user.loginType==LSLoginTypeAlipay)
    {
        user.loginType=LSLoginTypeAlipayNotActive;
        if([LSSave saveUser])
        {
            LSLOG(@"已经重置用户登录状态并保存了User信息");
        }
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [LSLocationManager start];//开始定位
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    application.applicationIconBadgeNumber=0;//每次只要启动应用就将icon上的标记数字设置为0
#if TARGET_IPHONE_SIMULATOR
    
#elif TARGET_OS_IPHONE
    [messageCenter LSMCUpdateAction];//查询软件更新操作
    [messageCenter postNotificationName:LSNotificationOrderTimeChanged object:nil];//更新订单时间
#endif
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 推送信息唤起
//解析deviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString* token=[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [[token componentsSeparatedByString:@" "] componentsJoinedByString:@""];
    LSLOG(@"deviceToken : %@", token);
    [messageCenter LSMCAPNSWithDeviceToken:token];
}
//推送信息相关处理
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    LSLOG(@"注册推送功能错误，错误信息:\n%@",error);
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    LSLOG(@"获取推送信息:\n%@", userInfo);
#warning 需要处理推送信息
//    {
//        activityId = 2162;
//        aps =     {
//            alert = "\U54c7\U585e\Uff0c\U5a03\U5a03\U8138\U4f60\U597d\U5e05\U554a\Uff01";
//            badge = 2;
//            sound = default;
//        };
//        type = 1;
//    }
    
    UIApplicationState state = [application applicationState];
    if (state==UIApplicationStateActive)
    {
        //如果程序在前台
    }
    else
    {
        //如果程序在后台
    }
}



#pragma mark- 启动网络监视
- (void)startInternetMonitor
{
    //网络状态监控
    [messageCenter addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    //持续监视
    //监视服务器连通状况
    Reachability* hostReachability = [[Reachability reachabilityWithHostName:@"www.apple.com"] retain];
    [hostReachability startNotifier];
}

#pragma mark- 网络状态的监视方法
- (void)reachabilityChanged:(NSNotification*)notification//网络类型变化判断
{
    Reachability* reachability = notification.object;
    NSParameterAssert([reachability isKindOfClass: [Reachability class]]);
    switch ([reachability currentReachabilityStatus])
    {
        case NotReachable:
            LSLOG(@"当前无网络连接,通知来源于:%@",notification.name);
            break;
        case ReachableViaWiFi:
            LSLOG(@"当前连接WIFI,通知来源于:%@",notification.name);
            break;
        case ReachableViaWWAN:
            LSLOG(@"当前连接3G,通知来源于:%@",notification.name);
            break;
        default:
            LSLOG(@"当前有网络连接状态未知,通知来源于:%@",notification.name);
    }
    
    //只有在之前状态或者当前状态有一个为不连接的情况才发出通知
    NetworkStatus networkStatus=user.networkStatus;
    user.networkStatus=[reachability currentReachabilityStatus];
    if(networkStatus==NotReachable || [reachability currentReachabilityStatus]==NotReachable)
    {
        [messageCenter postNotificationName:LSNotificationNetworkStatusChanged object:nil];
    }
}


#pragma mark- 初始化友盟统计SDK
- (void)initUMAnalyticsSDK
{
    //[MobClick setCrashReportEnabled:NO];//如果不需要捕捉异常，注释掉此行
    //[MobClick setLogEnabled:YES];//打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    
    [MobClick startWithAppkey:UMENGAPPKEY reportPolicy:(ReportPolicy)REALTIME channelId:nil];
    //reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    //channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
    
    //[MobClick checkUpdate];   //自动更新检查, 如果需要自定义更新请使用下面的方法,需要接收一个(NSDictionary *)appInfo的参数
    //[MobClick checkUpdateWithDelegate:self selector:@selector(updateMethod:)];
    
    [MobClick updateOnlineConfig];//在线参数配置
    
    //1.6.8之前的初始化方法
    //[MobClick setDelegate:self reportPolicy:REALTIME];//建议使用新方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
}
- (void)onlineConfigCallBack:(NSNotification *)note
{
    LSLOG(@"online config has fininshed and note = %@\n",note.userInfo);
}



#pragma mark - 支付宝钱包独立客户端唤起
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if([url.absoluteString rangeOfString:@"auth_code"].location!=NSNotFound)//说明是钱包唤醒的我方应用
    {
        NSDictionary* paramsDic = [url queryParams];
        //{
        //    "alipay_client_version" = "7.0";
        //    "alipay_user_id" = 2088112072281824;
        //    "app_id" = 2013080500000706;
        //    "auth_code" = 61e6349d26b34a4994eff6c0b54824f3;
        //    version = "1.0";
        //}
        LSLOG(@"钱包唤醒我们的应用\n%@",paramsDic);
        
        NSString* appID=[paramsDic objectForKey:@"app_id"];
        //alipayInfo.aliUserID=[NSString stringWithFormat:@"%@",[paramsDic objectForKey:@"alipay_user_id"]];
        NSString* authCode=[paramsDic objectForKey:@"auth_code"];
        
        [user logout];
        if([LSSave saveUser])
        {
            LSLOG(@"已经注销登录并保存了User信息");
        }
        //获取支付宝用户共享信息
        [messageCenter LSMCLoginAlipayUserInfoWithAppID:appID authCode:authCode];
    }
    else if([url.scheme isEqualToString:lsURLScheme])//说明是我方应用启动钱包后的回调
    {
        LSLOG(@"付款结束回跳");
        [self parse:url application:application];
    }
    else
    {
        return NO;
    }
    return YES;
}
- (void)parse:(NSURL *)url application:(UIApplication *)application
{
    //结果处理
    AlixPayResult* result = [self handleOpenURL:url];
    
	if (result)
    {
		if (result.statusCode == 9000)
        {
            NSLog(@"独立客户端支付成功");
			/*
			 *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
			 */
            
            //交易成功
            //            NSString* key = @"签约帐户后获取到的支付宝公钥";
            //			id<DataVerifier> verifier;
            //            verifier = CreateRSADataVerifier(key);
            //
            //			if ([verifier verifyString:result.resultString withSign:result.signString])
            //            {
            //                //验证签名成功，交易结果无篡改
            //			}
            
            [messageCenter postNotificationName:LSNotificationAlipaySuccess object:nil];
        }
        else
        {
            //交易失败
            LSLOG(@"支付宝客户端支付失败");
        }
    }
    else
    {
        //失败
        LSLOG(@"支付宝客户端支付失败");
    }
}
- (AlixPayResult *)resultFromURL:(NSURL *)url
{
	NSString * query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#if ! __has_feature(objc_arc)
    return [[[AlixPayResult alloc] initWithString:query] autorelease];
#else
	return [[AlixPayResult alloc] initWithString:query];
#endif
}
- (AlixPayResult *)handleOpenURL:(NSURL *)url
{
	AlixPayResult * result = nil;
	if (url != nil && [[url host] compare:@"safepay"] == 0)
    {
		result = [self resultFromURL:url];
	}
	return result;
}

#pragma mark- LSWelcomeView的委托方法
- (void)LSWelcomeViewDidWelcome
{
    [tabBarController selectCity];
}

@end
