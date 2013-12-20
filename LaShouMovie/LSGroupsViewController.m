//
//  LSGroupsViewController.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-9.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSGroupsViewController.h"
#import "LSGroupOrder.h"
#import "LSGroupCell.h"
#import "LSNothingCell.h"
#import "LSTicket.h"
#import "LSTicketInfoViewController.h"

@interface LSGroupsViewController ()

@end

@implementation LSGroupsViewController

@synthesize groupStatus=_groupStatus;

#pragma mark- 生命周期
- (void)dealloc
{
    LSRELEASE(_unpayGroupMArray)
    LSRELEASE(_paidGroupMArray)
    
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
    self.title=@"我的团购";
    
    //初始化数据数组
    _unpayGroupMArray=[[NSMutableArray alloc] initWithCapacity:0];
    _paidGroupMArray=[[NSMutableArray alloc] initWithCapacity:0];
    _groupMArray=_unpayGroupMArray;
    
    _offset=0;
    _pageSize=100;
    
    if(_groupStatus==0)
    {
        _groupStatus=LSGroupStatusUnpay;
    }
    
    //添加通知
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeGroupsByType_Offset_PageSize object:nil];
    
    
    _groupStatusView=[[LSGroupStatusView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 42.f)];
    _groupStatusView.groupStatus=_groupStatus-1;
    _groupStatusView.delegate=self;
    [self.view addSubview:_groupStatusView];
    [_groupStatusView release];
    
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0.f, 42.f, self.view.width, HeightOfiPhoneX(480.f-20.f-44.f-42.f)) style:UITableViewStylePlain];
    //_tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.backgroundView=nil;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    [_tableView release];
    
    [hud show:YES];
    [messageCenter LSMCGroupsWithStatus:_groupStatus offset:_offset pageSize:_pageSize];
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
            if([notification.name isEqualToString:lsRequestTypeGroupsByType_Offset_PageSize])
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

        if([notification.name isEqualToString:lsRequestTypeGroupsByType_Offset_PageSize])
        {
            dispatch_queue_t queue_0=dispatch_queue_create("queue_0", NULL);
            dispatch_async(queue_0, ^{
                
                id result=[notification.object objectForKey:lsRequestResult];
                int mark=[[notification.object objectForKey:lsRequestMark] intValue];
                
                if(mark==LSGroupStatusUnpay)
                {
                    //数据结构
                    //{
                    //   count = 1;
                    //   offset = 100;
                    //   orders = ();
                    //}
                    [_unpayGroupMArray removeAllObjects];
                    
                    NSArray* tmpArray=[result objectForKey:@"orders"];
                    for(NSDictionary* dic in tmpArray)
                    {
                        LSGroupOrder* groupOrder=[[LSGroupOrder alloc] initWithDictionary:dic];
                        [_unpayGroupMArray addObject:groupOrder];
                        [groupOrder release];
                    }
                    
                    if(_unpayGroupMArray.count==0)
                    {
                        [_unpayGroupMArray addObject:@"无订单"];
                    }
                }
                else
                {
                    //数据结构
                    //{
                    //   count = 1;
                    //   offset = 100;
                    //   orders = ();
                    //}
                    [_paidGroupMArray removeAllObjects];
                    
                    NSArray* tmpArray=[result objectForKey:@"orders"];
                    for(NSDictionary* dic in tmpArray)
                    {
                        LSGroupOrder* group=[[LSGroupOrder alloc] initWithDictionary:dic];
                        [_paidGroupMArray addObject:group];
                        [group release];
                    }
                    
                    if(_paidGroupMArray.count==0)
                    {
                        [_paidGroupMArray addObject:@"无订单"];
                    }
                }
                
                if(_groupStatus==LSGroupStatusUnpay)
                {
                    _groupMArray=_unpayGroupMArray;
                }
                else if(_groupStatus==LSGroupStatusPaid)
                {
                    _groupMArray=_paidGroupMArray;
                }
                
                if(mark==_groupStatus)
                {
                    dispatch_async(dispatch_get_main_queue(),^{
                        
                        [_tableView reloadData];
                    });
                }
            });
            dispatch_release(queue_0);
        }
    }
}


#pragma mark- LSGroupStatusView的委托方法
- (void)LSGroupStatusView:(LSGroupStatusView *)groupStatusView didSelectRowAtIndexPath:(LSGroupStatus)status
{
    _groupStatus=status;
    if(_groupStatus==LSGroupStatusUnpay)
    {
        _groupMArray=_unpayGroupMArray;
    }
    else
    {
        _groupMArray=_paidGroupMArray;
    }
    
    if(_groupMArray.count==0)
    {
        [messageCenter LSMCGroupsWithStatus:_groupStatus offset:_offset pageSize:_pageSize];
        [hud show:YES];
    }
    else
    {
        [_tableView reloadData];
    }
}


#pragma mark- UITableView的委托方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _groupMArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[_groupMArray objectAtIndex:0] isKindOfClass:[NSString class]])
    {
        return 44.f;
    }
    else
    {
        return [LSGroupCell heightForGroupOrder:[_groupMArray objectAtIndex:indexPath.row]];
    }
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[_groupMArray objectAtIndex:0] isKindOfClass:[NSString class]])
    {
        LSNothingCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSNothingCell"];
        if(cell==nil)
        {
            cell=[[[LSNothingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSNothingCell"] autorelease];
            cell.title=[_groupMArray objectAtIndex:0];
        }
        return cell;
    }
    
    LSGroupCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSGroupCell"];
    if(cell==nil)
    {
        cell=[[[LSGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSGroupCell"] autorelease];
    }
    cell.groupOrder=[_groupMArray objectAtIndex:indexPath.row];
    [cell setNeedsDisplay];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[_groupMArray objectAtIndex:0] isKindOfClass:[NSString class]])
    {
        return;
    }

    LSGroupPayViewController* groupPayViewController=[[LSGroupPayViewController alloc] init];
    groupPayViewController.groupOrder=[_groupMArray objectAtIndex:indexPath.row];
    groupPayViewController.delegate=self;
    [self.navigationController pushViewController:groupPayViewController animated:YES];
    [groupPayViewController release];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    if(!decelerate)//是否有减速,没有减速说明是匀速拖动
//    {
//        [self soapSmooth];
//    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    [self soapSmooth];
}


#pragma mark 肥皂滑代码实现
- (void)soapSmooth
{
    NSArray* cellArray=[_tableView visibleCells];
    for(LSGroupCell* cell in cellArray)
    {
//        NSIndexPath* indexPath=[_tableView indexPathForCell:cell];
//        LSCinema* cinema=nil;
//        if(_cinemaStatus==LSCinemaStatusOnline)
//        {
//            cinema=[_onlineCinemaMArray objectAtIndex:indexPath.row];
//        }
//        else if(_cinemaStatus==LSCinemaStatusAll)
//        {
//            cinema=[_allCinemaMArray objectAtIndex:indexPath.row];
//        }
    }
}

#pragma mark- LSGroupInfoViewController的委托方法
- (void)LSGroupPayViewControllerDidPay
{
    [self.navigationController popToViewController:self animated:YES];
    
    _offset=0;
    _groupStatus=LSGroupStatusPaid;
    _groupStatusView.groupStatus=_groupStatus-1;
    [_groupStatusView setNeedsLayout];
    
    [hud show:YES];
    
    [messageCenter LSMCGroupsWithStatus:LSGroupStatusPaid offset:_offset pageSize:_pageSize];
    [messageCenter LSMCGroupsWithStatus:LSGroupStatusUnpay offset:_offset pageSize:_pageSize];
}
- (void)LSGroupPayViewControllerDidCancel
{
    [self.navigationController popToViewController:self animated:YES];
    
    [hud show:YES];
    [messageCenter LSMCGroupsWithStatus:LSGroupStatusUnpay offset:_offset pageSize:_pageSize];
}

@end
