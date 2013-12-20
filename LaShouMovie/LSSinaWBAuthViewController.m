//
//  LSSinaWBAuthViewController.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-24.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSSinaWBAuthViewController.h"
#import "NSObject+SBJSON.h"
#import "NSString+SBJSON.h"

@interface LSSinaWBAuthViewController ()

@end

@implementation LSSinaWBAuthViewController

- (id)init
{
    self = [super init];
    if (self!=nil)
    {
        //清空QQ相关cookies
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie *cookie in [storage cookies])
        {
            if ([[cookie domain] rangeOfString:@".weibo.com"].location!=NSNotFound)
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
    self.title = @"新浪微博授权";
    
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeLoginSinaWBAccessTokenByCode object:nil];
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeLoginSinaWBUserInfoByAccessToken_UserID object:nil];
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeLoginUnionLoginByUserID_UserName_Type object:nil];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _webView.delegate = self;
    [self.view addSubview:_webView];
    [_webView release];
    
    NSString* URLString = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&response_type=%@&redirect_uri=%@&display=%@",
                           [LSSinaWBConsumerKey encodingURL],
                           [@"code" encodingURL],
                           [@"http://mobile.lashou.com" encodingURL],
                           [@"mobile" encodingURL]];

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
        
        
        if([notification.name isEqual:lsRequestTypeLoginSinaWBAccessTokenByCode])
        {
//#warning 这里需要解析数据
            
            //{
            //   "access_token" = "2.00Jetl_C0VKDgD33735d527c0DJKLa";
            //   "expires_in" = 2648229;
            //   "remind_in" = 2648229;
            //   uid = 2124431373;
            //}
            
            NSString* accessToken=nil;
            [LSSave saveObject:accessToken forKey:LSSinaWBAccessToken];
            
             NSString* expireTime=nil;
             [NSString stringWithFormat:@"%lf", ([[NSDate dateWithTimeIntervalSinceNow:[expireTime doubleValue]] timeIntervalSince1970] - 60)];
             [LSSave saveObject:expireTime forKey:LSSinaWBExpireTime];
             
             NSString* userID=nil;
             [LSSave saveObject:userID forKey:LSSinaWBUID];
             
            //就此检验是否保存成功
            [messageCenter LSMCLoginSinaWBUserInfoWithAccessToken:[LSSave obtainForKey:LSSinaWBAccessToken] userID:[LSSave obtainForKey:LSSinaWBUID]];
        }
        else if([notification.name isEqual:lsRequestTypeLoginSinaWBUserInfoByAccessToken_UserID])
        {
            //{
            //   "allow_all_act_msg" = 0;
            //   "allow_all_comment" = 1;
            //   "avatar_hd" = "http://tp2.sinaimg.cn/2124431373/180/0/1";
            //   "avatar_large" = "http://tp2.sinaimg.cn/2124431373/180/0/1";
            //   "bi_followers_count" = 0;
            //   "block_word" = 0;
            //   city = 1000;
            //   class = 1;
            //   "created_at" = "Fri Aug 16 19:24:48 +0800 2013";
            //   description = "";
            //   domain = "";
            //   "favourites_count" = 0;
            //   "follow_me" = 0;
            //   "followers_count" = 0;
            //   following = 0;
            //   "friends_count" = 0;
            //   gender = m;
            //   "geo_enabled" = 1;
            //   id = 2124431373;
            //   idstr = 2124431373;
            //   lang = "zh-cn";
            //   location = "\U5176\U4ed6";
            //   mbrank = 0;
            //   mbtype = 0;
            //   name = "\U52a0\U5dde\U65c5\U9986\U5ba22013";
            //   "online_status" = 0;
            //   "profile_image_url" = "http://tp2.sinaimg.cn/2124431373/50/0/1";
            //   "profile_url" = "u/2124431373";
            //   province = 100;
            //   ptype = 0;
            //   remark = "";
            //   "screen_name" = "\U52a0\U5dde\U65c5\U9986\U5ba22013";
            //   star = 0;
            //   "statuses_count" = 0;
            //   url = "";
            //   verified = 0;
            //   "verified_reason" = "";
            //   "verified_type" = "-1";
            //   weihao = "";
            //}
            
            NSString* userName=[NSString stringWithFormat:@"%@",[notification.object objectForKey:@"screen_name"]];
            [LSSave saveObject:userName forKey:LSSinaWBUserName];
            
            [messageCenter LSMCLoginWithUserID:[LSSave obtainForKey:LSSinaWBUID] userName:[LSSave obtainForKey:LSSinaWBUserName] type:LSLoginTypeSinaWB];
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
            //                 type = 1;
            //               };
            //}
            NSDictionary* dic=[notification.object objectForKey:@"profile"];
            [user completePropertyWithDictionary:dic];
            
            if([_delegate respondsToSelector:@selector(LSSinaWBAuthViewControllerDidLogin)])
            {
                [_delegate LSSinaWBAuthViewControllerDidLogin];
            }
        }
    }
}


#pragma mark- UIWebView的委托方法
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    LSLOG(@"%@",request.URL.absoluteString);
//    认证过程会经历多次请求，只有一次跳转为可用的链接，需要判断
//    http://mobile.lashou.com/?code=e45813977d8c9b9c87088cc3936e16d8
    
    NSString* absoluteString=request.URL.absoluteString;
    if ([absoluteString rangeOfString:@"code="].location != NSNotFound)
    {
        NSArray* array=[absoluteString componentsSeparatedByString:@"?"];
        
        NSString* code = nil;
        for(NSString* component in array)
        {
            if([component hasPrefix:@"code"])
            {
                NSArray* subArray=[component componentsSeparatedByString:@"="];
                code=[subArray objectAtIndex:1];
            }
        }
        
        [self sinaWBAccessTokenByCode:code];
        
#warning ASIFormDataRequest和原生的NSURLConnection依然是有区别的，这导致了新浪微博无法解析Post过去的参数，具体问题必须研究清楚，暂时弃用ASIFormDataRequest
        //[messageCenter LSMCLoginSinaWBAccessTokenByCode:code];
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


#pragma mark- 私有方法
- (void)sinaWBAccessTokenByCode:(NSString*)code
{
    NSString *paramString = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&grant_type=%@&redirect_uri=%@&code=%@",
                             [LSSinaWBConsumerKey encodingURL],
                             [LSSinaWBConsumerSecret encodingURL],
                             [@"authorization_code" encodingURL],
                             [@"http://mobile.lashou.com" encodingURL],
                             [code encodingURL]];
    
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.weibo.com/oauth2/access_token"]
                                                              cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                          timeoutInterval:20];
	[urlRequest setHTTPMethod:@"POST"];
	[urlRequest setHTTPBody:[paramString dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection* urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:NO];
	[urlConnection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[urlConnection start];
}
/*
- (void)sinaWBUserInfoByAccessToken:(NSString*)accessToken userID:(NSString*)userID
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json?access_token=%@&uid=%@", accessToken, userID]];
	NSURLConnection* urlConnection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:20] delegate:self startImmediately:NO];
	[urlConnection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[urlConnection start];
}
 */


#pragma mark- NSURLConnection的委托方法
- (void)connection:(NSURLConnection *)_connection didReceiveResponse:(NSURLResponse *)response
{
	LSRELEASE(_responsMData)
	_responsMData = [[NSMutableData alloc] initWithCapacity:0];
}

- (void)connection:(NSURLConnection *)_connection didReceiveData:(NSData *)newData
{
	[_responsMData appendData:newData];
}

- (void)connection:(NSURLConnection *)_connection didFailWithError:(NSError *)error
{
	LSRELEASE(_responsMData)
    LSRELEASE(_connection)
}

- (void)connectionDidFinishLoading:(NSURLConnection *)_connection
{
    NSString* responsString=[[NSString alloc] initWithData:_responsMData encoding:NSUTF8StringEncoding];
	id result = [responsString JSONValue];
    LSLOG(@"%@",result);
    
    if([result isKindOfClass:[NSDictionary class]])
    {
        if([result objectForKey:@"access_token"]!=NULL && [result objectForKey:@"access_token"]!=[NSNull null] && [result objectForKey:@"expires_in"]!=NULL && [result objectForKey:@"expires_in"]!=[NSNull null] && [result objectForKey:@"uid"]!=NULL && [result objectForKey:@"uid"]!=[NSNull null])
        {
            NSString* accessToken=[NSString stringWithFormat:@"%@",[result objectForKey:@"access_token"]];
            [LSSave saveObject:accessToken forKey:LSSinaWBAccessToken];
            
            NSString* expireTime=[NSString stringWithFormat:@"%@",[result objectForKey:@"expires_in"]];
            expireTime=[NSString stringWithFormat:@"%lf", ([[NSDate dateWithTimeIntervalSinceNow:[expireTime doubleValue]] timeIntervalSince1970] - 60)];
            [LSSave saveObject:expireTime forKey:LSSinaWBExpireTime];
            
            NSString* userID=[NSString stringWithFormat:@"%@",[result objectForKey:@"uid"]];
            [LSSave saveObject:userID forKey:LSSinaWBUID];
            
            [messageCenter LSMCLoginSinaWBUserInfoWithAccessToken:[LSSave obtainForKey:LSSinaWBAccessToken] userID:[LSSave obtainForKey:LSSinaWBUID]];
        }
        else
        {
            
        }
    }
    else
    {
        
    }
}

@end
