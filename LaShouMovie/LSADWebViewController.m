//
//  LSADWebViewController.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-17.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSADWebViewController.h"
#import "LSCinema.h"
#import "LSFilm.h"
#import "LSFilmsSchedulesByCinemaViewController.h"
#import "LSFilmInfoViewController.h"

typedef enum
{
    LSJsTypeShowCinema=0,
    LSJsTypeShowFilm=1,
    LSJsTypeOther=2
}LSJsType;

@interface LSADWebViewController ()

@end

@implementation LSADWebViewController

@synthesize activity=_activity;

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
    self.title=@"活动";
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeADCinemaDetailByCinemaID object:nil];
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeADFilmDetailByFilmID object:nil];
    
    _webView=[[UIWebView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.width, HeightOfiPhoneX(460.f-44.f))];
    _webView.delegate=self;
    [self.view addSubview:_webView];
    [_webView release];
    [_webView loadRequest:[messageCenter LSMCActivityWapWithActivityID:_activity.activityID]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- 通知中心消息
- (void)lsHttpRequestNotification:(NSNotification*)notification
{
    if([self checkIsNotEmpty:notification])
    {
        if([notification.object isEqual:lsRequestFailed])
        {
            //超时
            return;
        }
        
        if([notification.object isKindOfClass:[LSStatus class]])
        {
            //状态
            return;
        }
        
        if([notification.object isKindOfClass:[LSError class]])
        {
            //错误
            return;
        }
        
        if([notification.name isEqualToString:lsRequestTypeADCinemaDetailByCinemaID])
        {
            LSFilmsSchedulesByCinemaViewController* filmsSchedulesByCinemaViewController=[[LSFilmsSchedulesByCinemaViewController alloc] init];
            LSCinema* cinema=[[[LSCinema alloc] initWithDictionary:notification.object] autorelease];
            filmsSchedulesByCinemaViewController.cinema=cinema;
            filmsSchedulesByCinemaViewController.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:filmsSchedulesByCinemaViewController animated:YES];
            [filmsSchedulesByCinemaViewController release];
        }
        else if([notification.name isEqualToString:lsRequestTypeADFilmDetailByFilmID])
        {
            LSFilmInfoViewController* filmInfoViewController=[[LSFilmInfoViewController alloc] init];
            LSFilm* film=[[[LSFilm alloc] initWithDictionary:notification.object] autorelease];
            filmInfoViewController.film=film;
            filmInfoViewController.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:filmInfoViewController animated:YES];
            [filmInfoViewController release];
        }
    }
}

- (void)doSomething:(LSJsType)jsType maybeID:(NSString*)maybeID
{
    if(jsType==LSJsTypeShowCinema)
    {
        [messageCenter LSMCADCinemaDetailWithCinemaID:maybeID];
    }
    else if(jsType==LSJsTypeShowFilm)
    {
        [messageCenter LSMCADFilmDetailWithFilmID:maybeID];
    }
    else
    {
        [LSAlertView showWithTag:0 title:nil message:maybeID delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    }
}

#pragma mark- UIWebView的委托方法
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString* urlString = [[request URL] absoluteString];
    NSArray* tmpArray = [urlString componentsSeparatedByString:@"://"];
    if(tmpArray.count>0 && [[tmpArray objectAtIndex:0] isEqual:lsURLScheme.lowercaseString])
    {
        NSString* argumentStr=[tmpArray objectAtIndex:1];
        
        NSArray* argumentArray = [argumentStr componentsSeparatedByString:@"-"];
        if(argumentArray.count>2)
        {
            [self doSomething:[[argumentArray objectAtIndex:1] integerValue] maybeID:[NSString stringWithFormat:@"%@",[argumentArray objectAtIndex:2]]];
        }
        else
        {
            [LSAlertView showWithTag:0 title:@"错误" message:@"参数错误，我们会尽快修复" delegate:nil cancelButtonTitle:@"原谅你们了" otherButtonTitles:nil];
        }
        return NO; 
    }; 
    return YES;
}

@end
