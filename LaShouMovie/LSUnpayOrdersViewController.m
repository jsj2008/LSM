//
//  LSUnpayOrdersViewController.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-29.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSUnpayOrdersViewController.h"
#import "LSOrder.h"
#import "LSNothingCell.h"
#import "LSCinemaMapViewController.h"

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

- (void)viewWillAppear:(BOOL)animated
{
    if(!_isRefresh)
    {
        [self.tableView reloadData];
    }
}


#pragma mark- 下拉刷新
- (void)refreshControlEventValueChanged
{
    _offset=0;
    _isRefresh=YES;
    
    [messageCenter LSMCOrdersWithStatus:LSOrderStatusUnpay offset:_offset pageSize:_pageSize];
    [hud show:YES];
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
            
            if(_orderMArray.count==0)
            {
                [_orderMArray addObject:@"无订单"];
            }
            
            _isRefresh=NO;
            _isAdd=NO;
            [self.tableView reloadData];
        }
    }
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _orderMArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[_orderMArray objectAtIndex:0] isKindOfClass:[NSString class]])
    {
        return 44.f;
    }
    else
    {
        return [LSUnpayOrderCell heightOfOrder:[_orderMArray objectAtIndex:indexPath.row]];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[_orderMArray objectAtIndex:0] isKindOfClass:[NSString class]])
    {
        LSNothingCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSNothingCell"];
        if(cell==nil)
        {
            cell=[[[LSNothingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSNothingCell"] autorelease];
            cell.title=[_orderMArray objectAtIndex:0];
        }
        return cell;
    }
    
    LSUnpayOrderCell* cell=[tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"LSUnpayOrderCell%d",indexPath.row]];
    if(cell==nil)
    {
        cell=[[[LSUnpayOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"LSUnpayOrderCell%d",indexPath.row]] autorelease];
        cell.order=[_orderMArray objectAtIndex:indexPath.row];
        cell.delegate=self;
    }
    return cell;
}

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
    LSPayViewController* payViewController=[[LSPayViewController alloc] init];
    payViewController.order=order;
    payViewController.delegate=self;
    [self.navigationController pushViewController:payViewController animated:YES];
    [payViewController release];
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

#pragma mark- LSPayViewController的委托方法
- (void)LSPayViewControllerDidPay
{
    [self.navigationController popToViewController:self animated:YES];
    [self refreshControlEventValueChanged];
}

@end
