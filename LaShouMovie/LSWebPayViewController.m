//
//  LSWebPayViewController.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-26.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSWebPayViewController.h"

@interface LSWebPayViewController ()

@end

@implementation LSWebPayViewController

@synthesize request=_request;
@synthesize delegate=_delegate;

- (void)dealloc
{
    self.request=nil;
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
    
    UIWebView* payWebView=[[UIWebView alloc]initWithFrame:self.view.bounds];
    payWebView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    payWebView.delegate=self;
    [self.view addSubview:payWebView];
    [payWebView release];
    
    [payWebView loadRequest:_request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- 重载方法
- (void)leftBarButtonItemClick:(UIBarButtonItem *)sender
{
    [_delegate LSWebPayViewControllerDidPay];
}

#pragma mark- UIWebView的委托方法
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    LSLOG(@"%@",request.URL.absoluteString);
    if([request.URL.absoluteString rangeOfString:@""].location!=NSNotFound)
    {
        [_delegate LSWebPayViewControllerDidPay];
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
