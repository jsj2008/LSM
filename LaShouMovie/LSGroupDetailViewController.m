//
//  LSGroupDetailViewController.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-10.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSGroupDetailViewController.h"

@interface LSGroupDetailViewController ()

@end

@implementation LSGroupDetailViewController

@synthesize html=_html;

- (void)dealloc
{
    self.html=nil;
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
    self.title=@"商品详情";
    
    UIWebView* detailWebView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    detailWebView.delegate=self;
    [self.view addSubview:detailWebView];
    [detailWebView release];
    
    [detailWebView loadHTMLString:_html baseURL:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- UIWebView的委托方法
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    LSLOG(@"开始加载详情");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    LSLOG(@"结束加载详情");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    LSLOG(@"加载详情错误 %@",error);
}

@end
