//
//  LSPaidOrderInfoViewController.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-27.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSPaidOrderInfoViewController.h"
#import "LSCreateOrderView.h"
#import "LSRedeemCodeView.h"
#import "LSFilmsSchedulesByCinemaViewController.h"

@interface LSPaidOrderInfoViewController ()

@end

@implementation LSPaidOrderInfoViewController

@synthesize order=_order;

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
    self.title=[NSString stringWithFormat:@"电影票：%@",_order.film.filmName];
    
    UIScrollView* rootScrollView=[[UIScrollView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:rootScrollView];
    [rootScrollView release];
    
    CGFloat contentY=0.f;
    
    if(_order.confirmStatus==LSConfirmStatusWrong)
    {
        LSPaidWrongView* paidWrongView=[[LSPaidWrongView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.width, 200.f)];
        paidWrongView.delegate=self;
        [self.view addSubview:paidWrongView];
        [paidWrongView release];
        
        contentY+=200.f;
    }
    
    LSCreateOrderView* createOrderView=[[LSCreateOrderView alloc] initWithFrame:CGRectMake(0.f, contentY, self.view.width, 0.f)];
    createOrderView.order=_order;
    [rootScrollView addSubview:createOrderView];
    [createOrderView release];
    createOrderView.frame=CGRectMake(0.f, 0.f, self.view.width, createOrderView.contentY);
    [createOrderView setNeedsDisplay];
    
    LSRedeemCodeView* redeemCodeView=[[LSRedeemCodeView alloc] initWithFrame:CGRectMake(0.f, createOrderView.bottom, self.view.width, 128.f)];
    redeemCodeView.order=_order;
    [rootScrollView addSubview:redeemCodeView];
    [redeemCodeView release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- LSPaidWrongView的委托方法
- (void)LSPaidWrongView:(LSPaidWrongView *)paidWrongView didClickRebuyButton:(UIButton *)rebuyButton
{
    LSFilmsSchedulesByCinemaViewController* filmsSchedulesByCinemaViewController=[[LSFilmsSchedulesByCinemaViewController alloc] init];
    filmsSchedulesByCinemaViewController.cinema=_order.cinema;
    filmsSchedulesByCinemaViewController.film=_order.film;
    [self.navigationController pushViewController:filmsSchedulesByCinemaViewController animated:YES];
    [filmsSchedulesByCinemaViewController release];
    
}

@end
