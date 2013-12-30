//
//  LSUnpayOrdersViewController.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-29.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSUnpayOrdersViewController.h"
#import "LSOrder.h"
#import "LSUnpayOrderCell.h"
#import "LSFilmsSchedulesByCinemaViewController.h"

@interface LSUnpayOrdersViewController ()

@end

@implementation LSUnpayOrdersViewController

#pragma mark- 生命周期
- (void)dealloc
{
    LSRELEASE(_orderMArray)
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"待付款";
    _orderMArray=[[NSMutableArray alloc] initWithCapacity:0];
    _offset=0;
    _pageSize=10;
    
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeOrdersByType_Offset_PageSize object:nil];
    
    [self initRefreshControl];
    [messageCenter LSMCOrdersWithStatus:LSOrderStatusUnpay offset:_offset pageSize:_pageSize];
    [hud show:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- 重载方法
- (void)refreshControlEventValueChanged
{
    _offset=0;
    _isRefresh=YES;
    
    [hud show:YES];
    [messageCenter LSMCOrdersWithStatus:LSOrderStatusUnpay offset:_offset pageSize:_pageSize];
}

#pragma mark- 消息中心通知
- (void)lsHttpRequestNotification:(NSNotification*)notification
{
    [hud hide:YES];
    if(LSiOS6 && self.refreshControl.refreshing)
    {
        [self.refreshControl endRefreshing];
    }
    
    if([self checkIsNotEmpty:notification])
    {
        if([notification.object isEqual:lsRequestFailed])
        {
            //超时
            return;
        }
        
        if([notification.object isKindOfClass:[LSStatus class]])
        {
            if([notification.name isEqualToString:lsRequestTypeOrdersByType_Offset_PageSize])
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
        
        if([notification.name isEqualToString:lsRequestTypeOrdersByType_Offset_PageSize])
        {
            //数据结构
            //{
            //    count = 0;
            //   offset = 10;
            //    orders = (
            //    );
            //}
            if(_isRefresh)
            {
                [_orderMArray removeAllObjects];
            }
            
            NSArray* tmpArray=[notification.object objectForKey:@"orders"];
            for(NSDictionary* dic in tmpArray)
            {
                LSOrder* order=[[LSOrder alloc] initWithDictionaryOfUnpay:dic];
                [_orderMArray addObject:order];
                [order release];
            }

            _isRefresh=NO;
            _isAdd=NO;
            [self.tableView reloadData];
        }
    }
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _orderMArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSUnpayOrderCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSUnpayOrderCell"];
    if(cell==nil)
    {
        cell=[[[LSUnpayOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSUnpayOrderCell"] autorelease];
    }
    cell.order=[_orderMArray objectAtIndex:indexPath.row];
    [cell setNeedsDisplay];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSOrder* order=[_orderMArray objectAtIndex:indexPath.row];
    if([order expireSecond]>0)
    {
        LSPayViewController* payViewController=[[LSPayViewController alloc] init];
        payViewController.order=[_orderMArray objectAtIndex:indexPath.row];
        payViewController.delegate=self;
        [self.navigationController pushViewController:payViewController animated:YES];
        [payViewController release];
    }
    else
    {
        LSFilmsSchedulesByCinemaViewController* filmsSchedulesByCinemaViewController=[[LSFilmsSchedulesByCinemaViewController alloc] init];
        filmsSchedulesByCinemaViewController.cinema=order.cinema;
        filmsSchedulesByCinemaViewController.film=order.film;
        [self.navigationController pushViewController:filmsSchedulesByCinemaViewController animated:YES];
        [filmsSchedulesByCinemaViewController release];
    }
}

/*
#pragma mark- LSUnpayOrderCell的委托方法
- (void)LSUnpayOrderCell:(LSUnpayOrderCell *)unpayOrderCell didClickMapButtonForOrder:(LSOrder *)order
{
    LSCinemaMapViewController* cinemaMapViewController=[[LSCinemaMapViewController alloc] init];
    cinemaMapViewController.cinema=order.cinema;
    [self.navigationController pushViewController:cinemaMapViewController animated:YES];
    [cinemaMapViewController release];
}
- (void)LSUnpayOrderCell:(LSUnpayOrderCell *)unpayOrderCell didClickPhoneButtonForOrder:(LSOrder *)order
{
    UIActionSheet* actionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:[NSString stringWithFormat:@"呼叫 %@",order.cinema.phone] otherButtonTitles:nil];
    actionSheet.tag=[_orderMArray indexOfObject:order];
    [actionSheet showInView:self.view];
    [actionSheet release];
}
- (void)LSUnpayOrderCell:(LSUnpayOrderCell *)unpayOrderCell didClickPayButtonForOrder:(LSOrder *)order
{
 
}
- (void)LSUnpayOrderCell:(LSUnpayOrderCell *)unpayOrderCell didTimeoutForOrder:(LSOrder *)order
{
    [self refreshControlEventValueChanged];
}

#pragma mark- UIActionSheet的委托方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==actionSheet.destructiveButtonIndex)
    {
        LSOrder* order=[_orderMArray objectAtIndex:actionSheet.tag];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", order.cinema.phone]]];
    }
}
 */

#pragma mark- LSPayViewController的委托方法
- (void)LSPayViewControllerDidPay
{
    [self.navigationController popToViewController:self animated:YES];
    [self refreshControlEventValueChanged];
}

@end
