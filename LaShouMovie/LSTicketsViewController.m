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
#import "LSTicketInfoViewController.h"

@interface LSTicketsViewController ()

@end

@implementation LSTicketsViewController

#pragma mark- 生命周期
- (void)dealloc
{
    LSRELEASE(_ticketMArray)
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
    _ticketMArray=[[NSMutableArray alloc] initWithCapacity:0];
    
    _offset=0;
    _pageSize=100;
    
    //添加通知
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeTicketsByOffset_PageSize object:nil];
    
    [messageCenter LSMCTicketsWithOffset:_offset pageSize:_pageSize];
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
            if([notification.name isEqualToString:lsRequestTypeTicketsByOffset_PageSize])
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
        
        if([notification.name isEqualToString:lsRequestTypeTicketsByOffset_PageSize])
        {
            dispatch_queue_t queue_0=dispatch_queue_create("queue_0", NULL);
            dispatch_async(queue_0, ^{
                
                //数据结构
                //{
                //   count = 1;
                //   offset = 100;
                //   orders = ();
                //}
                NSArray* tmpArray=[notification.object objectForKey:@"orders"];
                for(NSDictionary* dic in tmpArray)
                {
                    LSTicket* ticket=[[LSTicket alloc] initWithDictionary:dic];
                    [_ticketMArray addObject:ticket];
                    [ticket release];
                }
                
                //可以首先刷新视图
                dispatch_async(dispatch_get_main_queue(),^{
                    
                    [self.tableView reloadData];
                });
            });
            dispatch_release(queue_0);
        }
    }
}

#pragma mark- UITableView的委托方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _ticketMArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.f;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    LSTicketInfoViewController* ticketInfoViewController=[[LSTicketInfoViewController alloc] init];
    ticketInfoViewController.ticket=[_ticketMArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:ticketInfoViewController animated:YES];
    [ticketInfoViewController release];
}

@end
