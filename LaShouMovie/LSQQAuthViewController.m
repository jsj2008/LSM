//
//  LSQQAuthViewController.m
//  LaShouMovie
//
//  Created by Li XiangYu on 13-9-21.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSQQAuthViewController.h"

@interface LSQQAuthViewController ()

@end

@implementation LSQQAuthViewController

- (id)init
{
    self = [super init];
    if (self!=nil)
    {
        //清空QQ相关cookies
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie *cookie in [storage cookies])
        {
            if ([[cookie domain] rangeOfString:@".qq.com"].location!=NSNotFound)
            {
                [storage deleteCookie:cookie];
            }
        }
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
    
    self.title = @"QQ授权";
    
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeLoginQQOpenIDByAccessToken object:nil];
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeLoginQQUserInfoByAppID_AccessToken_OpenID object:nil];
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeLoginUnionLoginByUserID_UserName_Type object:nil];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _webView.delegate = self;
    [self.view addSubview:_webView];
    [_webView release];
    
    NSString* URLString = [NSString stringWithFormat:@"https://graph.qq.com/oauth2.0/authorize?client_id=%@&response_type=%@&redirect_uri=%@",
                           [LSQQAppID encodingURL],
                           [@"token" encodingURL],
                           [@"http://mobile.lashou.com" encodingURL]];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark- 通知中心消息
- (void)lsHttpRequestNotification:(NSNotification*)notification
{
    [hud hide:YES];
    if([self checkIsNotEmpty:notification])
    {
        if([notification.object isEqual:lsRequestFailed])
        {
            //超时
            return;
        }
        
        if([notification.object isKindOfClass:[LSStatus class]])
        {
            if([notification.name isEqualToString:lsRequestTypeLoginUnionLoginByUserID_UserName_Type])
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
        
        //因为QQ授权发生变化，所以可以绕过获取AccessToken这一步
        if([notification.name isEqual:lsRequestTypeLoginQQOpenIDByAccessToken])
        {
            //{
            //  "client_id" = 100218908;
            //  openid = 6DB95229E5648DB79098BF4163814AFB;
            //}
            NSString* openID=[NSString stringWithFormat:@"%@",[notification.object objectForKey:@"openid"]];
            [LSSave saveObject:openID forKey:LSQQUID];
            
            //就此检验是否保存成功
            [messageCenter LSMCLoginQQUserInfoWithAppID:LSQQAppID accessToken:[LSSave obtainForKey:LSQQAccessToken] openID:[LSSave obtainForKey:LSQQUID]];
        }
        else if([notification.name isEqual:lsRequestTypeLoginQQUserInfoByAppID_AccessToken_OpenID])
        {
            //{
            //   figureurl = "http://qzapp.qlogo.cn/qzapp/218908/6DB95229E5648DB79098BF4163814AFB/30";
            //   "figureurl_1" = "http://qzapp.qlogo.cn/qzapp/218908/6DB95229E5648DB79098BF4163814AFB/50";
            //   "figureurl_2" = "http://qzapp.qlogo.cn/qzapp/218908/6DB95229E5648DB79098BF4163814AFB/100";
            //   "figureurl_qq_1" = "http://q.qlogo.cn/qqapp/218908/6DB95229E5648DB79098BF4163814AFB/40";
            //   "figureurl_qq_2" = "http://q.qlogo.cn/qqapp/218908/6DB95229E5648DB79098BF4163814AFB/100";
            //   gender = "";
            //   "is_yellow_vip" = 0;
            //   "is_yellow_year_vip" = 0;
            //   level = 0;
            //   msg = "";
            //   nickname = "\U5ffd\U7136\U4e4b\U95f4";
            //   ret = 0;
            //   vip = 0;
            //   "yellow_vip_level" = 0;
            //}
            if([[notification.object objectForKey:@"ret"] intValue]==0)//在状态值为0的时候为有效的
            {
                NSString* userName=[NSString stringWithFormat:@"%@",[notification.object objectForKey:@"nickname"]];
                [LSSave saveObject:userName forKey:LSQQUserName];

//                for(int i=0;i<20;i++)
                [messageCenter LSMCLoginWithUserID:[LSSave obtainForKey:LSQQUID] userName:[LSSave obtainForKey:LSQQUserName] type:LSLoginTypeQQ];
                [hud show:YES];
            }
        }
        else if([notification.name isEqual:lsRequestTypeLoginUnionLoginByUserID_UserName_Type])
        {
            //{
            //    profile = {
            //                 email = "";
            //                 id = 1613127784;
            //                 name = qatest;
            //                 password = 54381fb45e52e442fe76112ade14a24b;
            //                 type = 3;
            //               };
            //}
            NSDictionary* dic=[notification.object objectForKey:@"profile"];
            [user completePropertyWithDictionary:dic];
            
            if([_delegate respondsToSelector:@selector(LSQQAuthViewControllerDidLogin)])
            {
                [_delegate LSQQAuthViewControllerDidLogin];
            }
        }
    }
}


#pragma mark- UIWebView的委托方法
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    LSLOG(@"%@",request.URL.absoluteString);
    
//    认证过程会经历多次请求，只有一次跳转为可用的链接，需要判断
//    http://qzs.qq.com/open/mobile/login/proxy.html?#&openid=6DB95229E5648DB79098BF4163814AFB&appid=218908&access_token=CFBD0B007D0000F345A6D8EEA089501D&key=d95db396579de7dfade8cfe27a1e6918&expires_in=7776000
    NSString* absoluteString=request.URL.absoluteString;    
    if([absoluteString rangeOfString:@"&openid="].location!=NSNotFound && [absoluteString rangeOfString:@"&access_token="].location!=NSNotFound && /*[absoluteString rangeOfString:@"&key="].location!=NSNotFound && */[absoluteString rangeOfString:@"&expires_in="].location!=NSNotFound)
    {
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
            NSArray* array=[absoluteString componentsSeparatedByString:@"&"];
            for(NSString* component in array)
            {
                if([component hasPrefix:@"openid"])
                {
                    NSArray* subArray=[component componentsSeparatedByString:@"="];
                    [LSSave saveObject:[subArray objectAtIndex:1] forKey:LSQQUID];
                }
                else if([component hasPrefix:@"access_token"])
                {
                    NSArray* subArray=[component componentsSeparatedByString:@"="];
                    [LSSave saveObject:[subArray objectAtIndex:1] forKey:LSQQAccessToken];
                }
                else if([component hasPrefix:@"expires_in"])
                {
                    NSArray* subArray=[component componentsSeparatedByString:@"="];
                    [LSSave saveObject:[subArray objectAtIndex:1] forKey:LSQQExpireTime];
                }
            }
            
//            [messageCenter LSMCLoginQQOpenIDByAccessToken:[LSSave obtainForKey:LSQQAccessToken]];
            [messageCenter LSMCLoginQQUserInfoWithAppID:LSQQAppID accessToken:[LSSave obtainForKey:LSQQAccessToken] openID:[LSSave obtainForKey:LSQQUID]];
//        });
    }

    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

@end
