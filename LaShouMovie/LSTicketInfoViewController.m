//
//  LSTicketInfoViewController.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-16.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTicketInfoViewController.h"
#import "LSTicketInfoInfoCell.h"
#import "LSTicketInfoPositionCell.h"
#import "LSTicketInfoDetailCell.h"
#import "LSTicketInfoCell.h"
#import "LSCinemasMapViewController.h"
#import "LSBranch.h"

@interface LSTicketInfoViewController ()

@end

@implementation LSTicketInfoViewController

@synthesize ticket=_ticket;

- (void)dealloc
{
    self.ticket=nil;
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
    self.title=@"拉手券详情";
    
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeTicketPasswordByTicketID object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark- 消息中心通知
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
            if([notification.name isEqualToString:lsRequestTypeTicketPasswordByTicketID])
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
    }
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        return [LSTicketInfoInfoCell heightOfTicket:_ticket];
    }
    else if(indexPath.row==1)
    {
        return [LSTicketInfoPositionCell heightOfTicket:_ticket];
    }
    else if(indexPath.row==2)
    {
        return 100.f;
    }
    else if(indexPath.row==3)
    {
        return 54.f;
    }
    else
    {
        return _webHeight;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        LSTicketInfoInfoCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSTicketInfoInfoCell"];
        if(cell==nil)
        {
            cell=[[[LSTicketInfoInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSTicketInfoInfoCell"] autorelease];
            cell.ticket=_ticket;
        }
        return cell;
    }
    else if(indexPath.row==1)
    {
        LSTicketInfoPositionCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSTicketInfoPositionCell"];
        if(cell==nil)
        {
            cell=[[[LSTicketInfoPositionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSTicketInfoPositionCell"] autorelease];
            cell.ticket=_ticket;
        }
        return cell;
    }
    else if(indexPath.row==2)
    {
        LSTicketInfoDetailCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSTicketInfoDetailCell"];
        if(cell==nil)
        {
            cell=[[[LSTicketInfoDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSTicketInfoDetailCell"] autorelease];
            cell.ticket=_ticket;
        }
        return cell;
    }
    else if(indexPath.row==3)
    {
        LSTicketInfoCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSTicketInfoCell"];
        if(cell==nil)
        {
            cell=[[[LSTicketInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSTicketInfoCell"] autorelease];
        }
        return cell;
    }
    else
    {
        LSTicketInfoWebCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSTicketInfoWebCell"];
        if(cell==nil)
        {
            cell=[[[LSTicketInfoWebCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSTicketInfoWebCell"] autorelease];
            cell.delegate=self;
            cell.html=_ticket.goodsTips;
        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==1)
    {
        NSMutableArray* cinemaMArray=[NSMutableArray arrayWithCapacity:0];
        for (LSBranch* branch in _ticket.branchArray)
        {
            LSCinema* cinema=[[LSCinema alloc] init];
            cinema.cinemaName=branch.cinemaName;
            cinema.address=branch.address;
            cinema.latitude=branch.latitude;
            cinema.longitude=branch.longitude;
            [cinemaMArray addObject:branch];
            [cinema release];
        }
        if(cinemaMArray.count==0)
        {
            [cinemaMArray addObject:@"没有影院"];
        }
        
        LSCinemasMapViewController* cinemasMapViewController=[[LSCinemasMapViewController alloc] init];
        cinemasMapViewController.cinemaArray=cinemaMArray;
        [self.navigationController pushViewController:cinemasMapViewController animated:YES];
        [cinemasMapViewController release];
    }
    else if(indexPath.row==3)
    {
        [messageCenter LSMCTicketPasswordWithTicketID:_ticket.ticketID];
    }
}

#pragma mark- LSTicketInfoWebCell的委托方法
- (void)LSTicketInfoWebCellDidLoadHTMLContentHeight:(CGFloat)height
{
    _webHeight=height;
    [self.tableView reloadData];
}

@end
