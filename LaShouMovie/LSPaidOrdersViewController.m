//
//  LSPaidOrdersViewController.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-29.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSPaidOrdersViewController.h"
#import "LSOrder.h"
#import "LSNothingCell.h"
#import "LSCinemaMapViewController.h"   

@interface LSPaidOrdersViewController ()

@end

@implementation LSPaidOrdersViewController

@synthesize isCardRemind=_isCardRemind;
@synthesize delegate=_delegate;

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
    
    self.title = @"已付款";
    self.internetStatusRemindType=LSInternetStatusRemindTypeNon;
    _orderMArray=[[NSMutableArray alloc] initWithCapacity:0];
    _offset=0;
    _pageSize=10;
    _isRefresh=YES;
    
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeOrdersByType_Offset_PageSize object:nil];
    
    @try
    {
        //读取缓存数据
        NSArray* tmpOrderArray=[LSDataCache readOfFolderType:LSFolderTypeDocuments subFolder:LSSubFolderTypeNon name:lsDataCachePaidOrders];
        if(tmpOrderArray.count>0)
        {
            [_orderMArray addObjectsFromArray:tmpOrderArray];
        }
    }
    @catch (NSException* exception)
    {
        LSLOG(@"%@",exception);
        [_orderMArray removeAllObjects];
    }
    
    [self initRefreshControl];
    
    [hud show:YES];
    [messageCenter LSMCOrdersWithStatus:LSOrderStatusPaid offset:_offset pageSize:_pageSize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- 重载方法
- (void)backButtonClick:(UIButton*)sender
{
    if([_delegate respondsToSelector:@selector(LSPaidOrdersViewControllerDidBack)])
    {
        [_delegate LSPaidOrdersViewControllerDidBack];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark- 下拉刷新
- (void)refreshControlEventValueChanged
{
    _offset=0;
    _isRefresh=YES;
    
    [hud show:YES];
    [messageCenter LSMCOrdersWithStatus:LSOrderStatusPaid offset:_offset pageSize:_pageSize];
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
            //    offset = 10;
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
                LSOrder* order=[[LSOrder alloc] initWithDictionaryOfPaid:dic];
                [_orderMArray addObject:order];
                [order release];
            }
            
            [LSDataCache saveWithFolderType:LSFolderTypeDocuments subFolder:LSSubFolderTypeNon name:lsDataCachePaidOrders data:_orderMArray];
            
            if(_orderMArray.count==0)
            {
                [_orderMArray addObject:@"无订单"];
            }
            
            _isRefresh=NO;
            _isAdd=NO;
            [self.tableView reloadData];
            
            if(_isCardRemind)
            {
                [LSAlertView showWithView:self.view from:LSAlertViewFromTop message:@"您的电影票已同步到支付宝钱包，请登录查看吧！" time:5.f];
            }
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
        return [LSPaidOrderCell heightOfOrder:[_orderMArray objectAtIndex:indexPath.row]];
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
    
    LSPaidOrderCell* cell=[tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"LSPaidOrderCell%d",indexPath.row]];
    if(cell==nil)
    {
        cell=[[[LSPaidOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"LSPaidOrderCell%d",indexPath.row]] autorelease];
        cell.delegate=self;
    }
    LSOrder* order=[_orderMArray objectAtIndex:indexPath.row];
    cell.order=order;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //重复的点击需要首先取消之前的操作
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

#pragma mark- LSPaidOrderCell的委托方法
- (void)LSPaidOrderCell:(LSPaidOrderCell *)paidOrderCell didClickMapButtonForOrder:(LSOrder *)order
{
    if(user.networkStatus!=NotReachable)
    {
        LSCinemaMapViewController* cinemaMapViewController=[[LSCinemaMapViewController alloc] init];
        cinemaMapViewController.cinema=order.cinema;
        [self.navigationController pushViewController:cinemaMapViewController animated:YES];
        [cinemaMapViewController release];
    }
}
- (void)LSPaidOrderCell:(LSPaidOrderCell *)paidOrderCell didClickPhoneButtonForOrder:(LSOrder *)order
{
    UIActionSheet* actionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:[NSString stringWithFormat:@"呼叫 %@",order.cinema.phone] otherButtonTitles:nil];
    actionSheet.tag=[_orderMArray indexOfObject:order];
    [actionSheet showInView:self.view];
    [actionSheet release];
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

@end
