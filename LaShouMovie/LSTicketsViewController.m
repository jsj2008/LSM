//
//  LSTicketsViewController.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-29.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTicketsViewController.h"
#import "LSTicket.h"
#import "LSTicketCell.h"
#import "LSNothingCell.h"

@interface LSTicketsViewController ()

@end

@implementation LSTicketsViewController

#pragma mark- 生命周期
- (void)dealloc
{
    LSRELEASE(_unuseTicketMArray)
    LSRELEASE(_usedTicketMArray)
    LSRELEASE(_timeoutTicketMArray)
    
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
    self.title=@"我的拉手券";
    
    //初始化数据数组
    _unuseTicketMArray=[[NSMutableArray alloc] initWithCapacity:0];
    _usedTicketMArray=[[NSMutableArray alloc] initWithCapacity:0];
    _timeoutTicketMArray=[[NSMutableArray alloc] initWithCapacity:0];
    _ticketMArray=_unuseTicketMArray;
    
    _offset=0;
    _pageSize=100;
    _ticketStatus=LSTicketStatusUnuse;
    
    //添加通知
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeTicketsByType_Offset_PageSize object:nil];
    
    
    _ticketStatusView=[[LSTicketStatusView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 42.f)];
    _ticketStatusView.delegate=self;
    [self.view addSubview:_ticketStatusView];
    [_ticketStatusView release];
    
    
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
    
    [messageCenter LSMCTicketsWithStatus:_ticketStatus offset:_offset pageSize:_pageSize];
    [hud show:YES];
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
            if([notification.name isEqualToString:lsRequestTypeTicketsByType_Offset_PageSize])
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
        
        if([notification.name isEqualToString:lsRequestTypeTicketsByType_Offset_PageSize])
        {
            id result=[notification.object objectForKey:lsRequestResult];
            int mark=[[notification.object objectForKey:lsRequestMark] intValue];
            
            if(mark==LSTicketStatusUnuse)
            {
                //数据结构
                //{
                //   count = 1;
                //   offset = 100;
                //   orders = ();
                //}
                NSArray* tmpArray=[result objectForKey:@"orders"];
                for(NSDictionary* dic in tmpArray)
                {
                    LSTicket* ticket=[[LSTicket alloc] initWithDictionary:dic];
                    [_unuseTicketMArray addObject:ticket];
                    [ticket release];
                }
                
                if(_unuseTicketMArray.count==0)
                {
                    [_unuseTicketMArray addObject:@"无订单"];
                }
            }
            else if(mark==LSTicketStatusUsed)
            {
                //数据结构
                //{
                //   count = 1;
                //   offset = 100;
                //   orders = ();
                //}
                
                NSArray* tmpArray=[result objectForKey:@"orders"];
                for(NSDictionary* dic in tmpArray)
                {
                    LSTicket* ticket=[[LSTicket alloc] initWithDictionary:dic];
                    [_usedTicketMArray addObject:ticket];
                    [ticket release];
                }
                
                if(_usedTicketMArray.count==0)
                {
                    [_usedTicketMArray addObject:@"无订单"];
                }
            }
            else
            {
                NSArray* tmpArray=[result objectForKey:@"orders"];
                for(NSDictionary* dic in tmpArray)
                {
                    LSTicket* ticket=[[LSTicket alloc] initWithDictionary:dic];
                    [_timeoutTicketMArray addObject:ticket];
                    [ticket release];
                }
                
                if(_timeoutTicketMArray.count==0)
                {
                    [_timeoutTicketMArray addObject:@"无订单"];
                }
            }
            
            if(mark==_ticketStatus)
            {
                [_tableView reloadData];
            }
        }
    }
}


#pragma mark- LSTicketStatusView的委托方法
- (void)LSTicketStatusView:(LSTicketStatusView *)ticketStatusView didSelectRowAtIndexPath:(LSTicketStatus)status
{
    _ticketStatus=status;
    if(_ticketStatus==LSTicketStatusUnuse)
    {
        _ticketMArray=_unuseTicketMArray;
    }
    else if(_ticketStatus==LSTicketStatusUsed)
    {
        _ticketMArray=_usedTicketMArray;
    }
    else
    {
        _ticketMArray=_timeoutTicketMArray;
    }
    
    if(_ticketMArray.count==0)
    {
        [messageCenter LSMCTicketsWithStatus:_ticketStatus offset:_offset pageSize:_pageSize];
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
    return _ticketMArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[_ticketMArray objectAtIndex:0] isKindOfClass:[NSString class]])
    {
        return 44.f;
    }
    else
    {
        return [LSTicketCell heightForTicket:[_ticketMArray objectAtIndex:indexPath.row]];
    }
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[_ticketMArray objectAtIndex:0] isKindOfClass:[NSString class]])
    {
        LSNothingCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSNothingCell"];
        if(cell==nil)
        {
            cell=[[[LSNothingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSNothingCell"] autorelease];
            cell.title=[_ticketMArray objectAtIndex:0];
        }
        return cell;
    }
    
    LSTicketCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSTicketCell"];
    if(cell==nil)
    {
        cell=[[[LSTicketCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSTicketCell"] autorelease];
    }
    cell.ticket=[_ticketMArray objectAtIndex:indexPath.row];
    [cell setNeedsDisplay];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[_ticketMArray objectAtIndex:0] isKindOfClass:[NSString class]])
    {
        return;
    }

    LSTicketInfoViewController* ticketInfoViewController=[[LSTicketInfoViewController alloc] init];
    ticketInfoViewController.ticket=[_ticketMArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:ticketInfoViewController animated:YES];
    [ticketInfoViewController release];
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
    for(LSTicketCell* cell in cellArray)
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
- (void)LSGroupPayViewControllerDidPayOrNot
{
    _offset=0;
    [messageCenter LSMCTicketsWithStatus:_ticketStatus offset:_offset pageSize:_pageSize];
}

@end
