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
    self.title=@"我的团购订单";
    
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
                        
                        [self.tableView reloadData];
                    });
                }
            });
            dispatch_release(queue_0);
        }
    }
}


#pragma mark- UITableView的委托方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _groupMArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    LSGroupPayViewController* groupPayViewController=[[LSGroupPayViewController alloc] init];
    groupPayViewController.groupOrder=[_groupMArray objectAtIndex:indexPath.row];
    groupPayViewController.delegate=self;
    [self.navigationController pushViewController:groupPayViewController animated:YES];
    [groupPayViewController release];
}

#pragma mark- LSGroupsHeaderView的委托方法
- (void)LSGroupsHeaderView:(LSGroupsHeaderView *)groupsHeaderView didSelectGroupStatus:(LSGroupStatus)groupStatus
{
    _groupStatus=groupStatus;
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
        [hud show:YES];
        [messageCenter LSMCGroupsWithStatus:_groupStatus offset:_offset pageSize:_pageSize];
    }
    else
    {
        [self.tableView reloadData];
    }
}

#pragma mark- LSGroupPayViewController的委托方法
- (void)LSGroupPayViewControllerDidPay
{
    [self.navigationController popToViewController:self animated:YES];
    
    _offset=0;
    _groupStatus=LSGroupStatusPaid;
    _groupsHeaderView.groupStatus=_groupStatus;
    [_groupsHeaderView setNeedsLayout];
    
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
