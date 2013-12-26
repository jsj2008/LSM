//
//  LSGroupPayViewController.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-10.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSGroupWebPayViewController.h"

@interface LSGroupWebPayViewController ()

@end

@implementation LSGroupWebPayViewController

@synthesize groupOrder=_groupOrder;
@synthesize delegate=_delegate;

- (void)dealloc
{
    self.groupOrder=nil;
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
    self.title = @"支付";
    
//      String postDate = "uid="+userId+"&pw="+password+"&tn="+trade_no+"&fr="+FR;  // uid=49296162&pw=8cb4cfffa6d2b305749374bfe98c4ce9&tn=7809412d920a8eb1158&fr=10179
//		public static final String KEY = "Qi/n%;3w<*e#T6)";
//		private String FR="10179";
//      String postSign = userId+password+trade_no+FR+Preferences.KEY;  //492961628cb4cfffa6d2b305749374bfe98c4ce97809412d920a8eb115810179Qi/n%;3w<*e#T6)
    
//     wv_group_pay.getSettings().setJavaScriptEnabled(true);
//     wv_group_pay.addJavascriptInterface(new DemoJavaScriptInterface(), "WapCallApp");
//     String encrypt = MD5.toMD5(postSign);
//     postDate=postDate+"&sn="+encrypt;
//     byte[] encode = MyBase64.encode(postDate.getBytes());
//     //par=dWlkPTQ5Mjk2MTYyJnB3PThjYjRjZmZmYTZkMmIzMDU3NDkzNzRiZmU5OGM0Y2U5JnRuPTc4MDk0MTJkOTIwYThlYjExNTgmZnI9MTAxNzkmc249NWE2NGY0MGZkM2RhNjY2YTM1NDg1ZjY2MDgzNjBkOGE=
//     postDate="par="+new String(encode);
    
    UIWebView* payWebView=[[UIWebView alloc]initWithFrame:self.view.bounds];
    payWebView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    payWebView.delegate=self;
    [self.view addSubview:payWebView];
    [payWebView release];
    
    
    NSString* key=@"Qi/n%;3w<*e#T6)";
    NSString* signStr=[[NSString stringWithFormat:@"%@%@%@%@%@",user.userID,user.password,_groupOrder.orderID,@"10179",key] MD5];
    NSString* parStr=[NSString stringWithFormat:@"uid=%@&pw=%@&tn=%@&fr=10179&sn=%@",user.userID,user.password,_groupOrder.orderID,signStr];
    NSData *data=[parStr dataUsingEncoding:NSASCIIStringEncoding];
    NSURL* url=[NSURL URLWithString:API_GROUPORDERPAY_HEADER];
    NSString* body=[NSString stringWithFormat:@"par=%@",[data base64Encode]];
    
    NSMutableURLRequest* request=[[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    [payWebView loadRequest:request];
    [request release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backButtonClick:(UIButton *)sender
{
    if(_isBalanceWap && [_delegate respondsToSelector:@selector(LSGroupWebPayViewControllerDidPay)])
    {
        [_delegate LSGroupWebPayViewControllerDidPay];
    }
    else
    {
        [super backButtonClick:sender];
    }
}

#pragma mark- UIWebView的委托方法
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    LSLOG(@"%@",request.URL.absoluteString);
    if([request.URL.absoluteString rangeOfString:@"alipay.com"].location!=NSNotFound)
    {
        _isAliWap=YES;
        _isBalanceWap=NO;
    }
    else if([request.URL.absoluteString rangeOfString:@"lashou.com/pay.php?fr=0"].location!=NSNotFound)
    {
        _isAliWap=NO;
        _isBalanceWap=YES;
    }
    
    if(_isAliWap)
    {
        if([request.URL.absoluteString rangeOfString:@"alipay.com/cashier/asyn_payment_result.htm"].location!=NSNotFound)
        {
            if([_delegate respondsToSelector:@selector(LSGroupWebPayViewControllerDidPay)])
            {
                [_delegate LSGroupWebPayViewControllerDidPay];
            }
        }
    }
    
//http://m216.lashou.com/api/moviePay.php
//http://m216.lashou.com/pay.php?trade_no=1001798aeb3b15a8135&fr=10179&vt=3
//http://m216.lashou.com/pay.php?fr=0
    

//http://m216.lashou.com/api/moviePay.php
//http://m216.lashou.com/pay.php?trade_no=1001798d22b45342790&fr=10179&vt=3
//http://m216.lashou.com/pay.php?fr=0
//http://wappaygw.alipay.com/service/rest.htm?req_data=%3Cauth_and_execute_req%3E%3Crequest_token%3E20131107a2fa395965e90c211b747b3e991947ba%3C/request_token%3E%3C/auth_and_execute_req%3E&service=alipay.wap.auth.authAndExecute&sec_id=MD5&partner=2088201737030331&call_back_url=http://m216.lashou.com/myOrder.php?ors=2&format=xml&v=2.0&sign=2f37bbfc861e4e8a5d04aace6619ce48
//http://wappaygw.alipay.com/cashier/wapcashier_confirm_login.htm;jsessionid=82BD10C16056AEF90EAA861BE6C01A3E?awid=1u5HfVU7TTwaAYws0ZnoYM5vibsFakmcashier
//http://wappaygw.alipay.com/cashier/wapcashier_confirm_login.htm?awid=1u5HfVU7TTwaAYws0ZnoYM5vibsFakmcashier
//https://wapcashier.alipay.com/cashier/exCashier.htm?awid=1u5HfVU7TTwaAYws0ZnoYM5vibsFakmcashier&orderId=34590b0a788d63f5fa8d17a6043a135c
//http://mbuf.alipay.com/la.htm?token=P4edb844dfbd2f840746dfba5728b20b0&jsInfo=320%7C416%7C320%7C416%7C-%7C-%7C-%7C-%7C-%7C-%7C-
//https://wapcashier.alipay.com/cashier/trade_payment.htm?awid=1u5HfVU7TTwaAYws0ZnoYM5vibsFakmcashier&orderId=34590b0a788d63f5fa8d17a6043a135c
//http://wapcashier.alipay.com/cashier/asyn_payment_result.htm;jsessionid=9AF7988093FE38366FC44A9658FE69D6?promotion=false&channelToken=none&umidSwitch=open&_umid_token=P4edb844dfbd2f840746dfba5728b20b0&promotionImag=false&depositId=201311072NS40643&orderId=34590b0a788d63f5fa8d17a6043a135c&awid=1u5HfVU7TTwaAYws0ZnoYM5vibsFakmcashier
    
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
