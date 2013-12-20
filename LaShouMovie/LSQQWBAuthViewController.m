//
//  LSQQWBAuthViewController.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-24.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSQQWBAuthViewController.h"

@interface LSQQWBAuthViewController ()

@end

@implementation LSQQWBAuthViewController

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
    
    self.title = @"腾讯微博授权";
    
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeLoginQQWBUserInfoByCode object:nil];
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeLoginUnionLoginByUserID_UserName_Type object:nil];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _webView.delegate = self;
    [self.view addSubview:_webView];
    [_webView release];
    
    NSString* URLString = [NSString stringWithFormat:@"https://open.t.qq.com/cgi-bin/oauth2/authorize?client_id=%@&response_type=%@&redirect_uri=%@",
                           [LSQQWBConsumerKey encodingURL],
                           [@"code" encodingURL],
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
        
        
        if([notification.name isEqual:lsRequestTypeLoginQQWBUserInfoByCode])
        {
//            access_token=2b587aab1173002e5d1804038ef51fcc&expires_in=8035200&refresh_token=21b2bfc51bf8192a380b9e6ed143f13d&openid=5606cafab48e6916058c553dd2a44db4&name=jiazhoulvguanke&nick=å¿½ç¶ä¹é´&state=
            NSArray* array=[notification.object componentsSeparatedByString:@"&"];
            for(NSString* str in array)
            {
                if([str rangeOfString:@"access_token"].location!=NSNotFound)
                {
                    NSArray* subArray=[str componentsSeparatedByString:@"="];
                    NSString* accessToken=[subArray objectAtIndex:1];
                    [LSSave saveObject:accessToken forKey:LSQQWBAccessToken];
                }
                else if([str rangeOfString:@"expires_in"].location!=NSNotFound)
                {
                    NSArray* subArray=[str componentsSeparatedByString:@"="];
                    NSString* expireTime=[subArray objectAtIndex:1];
                    expireTime=[NSString stringWithFormat:@"%lf", ([[NSDate dateWithTimeIntervalSinceNow:[expireTime doubleValue]] timeIntervalSince1970] - 60)];
                    [LSSave saveObject:expireTime forKey:LSQQWBExpireTime];
                }
                else if([str rangeOfString:@"nick"].location!=NSNotFound)
                {
                    NSArray* subArray=[str componentsSeparatedByString:@"="];
                    NSString* userName=[subArray objectAtIndex:1];
                    [LSSave saveObject:userName forKey:LSQQWBUserName];
                }
            }
            
            //就此检验是否保存成功
            [messageCenter LSMCLoginWithUserID:[LSSave obtainForKey:LSQQWBUID] userName:[LSSave obtainForKey:LSQQWBUserName] type:LSLoginTypeQQWB];
            [hud show:YES];
        }
        else if([notification.name isEqual:lsRequestTypeLoginUnionLoginByUserID_UserName_Type])
        {
            //{
            //    profile = {
            //                 email = "";
            //                 id = 1613127784;
            //                 name = qatest;
            //                 password = 54381fb45e52e442fe76112ade14a24b;
            //                 type = 2;
            //               };
            //}
            NSDictionary* dic=[notification.object objectForKey:@"profile"];
            [user completePropertyWithDictionary:dic];
            
            if([_delegate respondsToSelector:@selector(LSQQWBAuthViewControllerDidLogin)])
            {
                [_delegate LSQQWBAuthViewControllerDidLogin];
            }
        }
    }
}


#pragma mark- UIWebView的委托方法
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    LSLOG(@"%@",request.URL.absoluteString);
    
//    认证过程会经历多次请求，只有一次跳转为可用的链接，需要判断
//    http://mobile.lashou.com/?code=64096ade567f0b438f7842becf235879&openid=5606CAFAB48E6916058C553DD2A44DB4&openkey=EC13CAD0AF0462DE15A40F9A2FFA0119&state=
    NSString* absoluteString=request.URL.absoluteString;
    if([absoluteString rangeOfString:@"code="].location!=NSNotFound && [absoluteString rangeOfString:@"openid="].location!=NSNotFound)
    {
        NSArray* array=[absoluteString componentsSeparatedByString:@"?"];
        
        NSString* code = nil;
        array=[[array objectAtIndex:1] componentsSeparatedByString:@"&"];
        for(NSString* component in array)
        {
            if([component hasPrefix:@"openid"])
            {
                NSArray* subArray=[component componentsSeparatedByString:@"="];
                [LSSave saveObject:[subArray objectAtIndex:1] forKey:LSQQWBUID];
            }
            else if([component hasPrefix:@"code"])
            {
                NSArray* subArray=[component componentsSeparatedByString:@"="];
                code=[subArray objectAtIndex:1];
            }
        }
        
        [messageCenter LSMCLoginQQWBUserInfoWithCode:code];
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
