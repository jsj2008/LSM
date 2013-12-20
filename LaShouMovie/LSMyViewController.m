//
//  LSMyViewController.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-30.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSMyViewController.h"
#import "LSMyInfoCell.h"
#import "LSMyCell.h"
#import "LSPaidOrdersViewController.h"
#import "LSUnpayOrdersViewController.h"
#import "LSGroupsViewController.h"
#import "LSTicketsViewController.h"
#import "LSTabBarController.h"

@interface LSMyViewController ()

@end

@implementation LSMyViewController

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
    self.internetStatusRemindType=LSInternetStatusRemindTypeNon;
    
    CGSize size=[@"我的账户" sizeWithFont:[UIFont systemFontOfSize:21.0]];
    UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    label.backgroundColor=[UIColor clearColor];
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:21.0];
    label.textColor=[UIColor whiteColor];
    label.text=@"我的账户";
    self.navigationItem.titleView=label;
    [label release];
    
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeUserProfile object:nil];
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeOrderCount object:nil];
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:LSNotificationAlipayUserInfo object:nil];
    
    [self setBarButtonItemWithImageName:@"nav_logout.png" clickedImageName:@"nav_logout_d.png" isRight:YES buttonType:LSOtherButtonTypeLogout];
    
    [self initRefreshControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if(user.loginType==LSLoginTypeAlipay)
    {
        self.navigationItem.rightBarButtonItem.enabled=NO;
    }
    else
    {
        self.navigationItem.rightBarButtonItem.enabled=YES;
    }
    
    [self refreshControlEventValueChanged];
}

#pragma mark- 重载方法
- (void)otherButtonClick:(UIButton *)sender
{
    [super otherButtonClick:sender];
    if(sender.tag==LSOtherButtonTypeLogout)
    {
        [LSAlertView showWithTag:0 title:nil message:@"是否退出？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    }
}
//
- (void)refreshControlEventValueChanged
{
    if(user.userID!=nil && user.password!=nil)
    {
        [hud show:YES];
        
        [messageCenter LSMCUserProfile];
        [messageCenter LSMCOrderCount];
        
    }
}
//刷新方法
- (void)refreshBecauseInternet
{
    [self.tableView reloadData];
    if(user.networkStatus!=NotReachable)
    {
        [self refreshControlEventValueChanged];
    }
}


#pragma mark- 消息中心通知
- (void)lsHttpRequestNotification:(NSNotification*)notification
{
    [hud hide:YES];
    if(LSiOS6 && self.refreshControl.isRefreshing)
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
            if([notification.name isEqualToString:lsRequestTypeUserProfile] || [notification.name isEqualToString:lsRequestTypeOrderCount])
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
        
        if([notification.name isEqualToString:lsRequestTypeUserProfile])
        {
            //{
            //  profile = {
            //               balance = "716.00";
            //               email = "2352214850@qq.com";
            //               id = 1613127784;
            //               mobile = "159****9764";
            //               name = qatest;
            //            };
            //}
            NSDictionary* dic=[notification.object objectForKey:@"profile"];
            [user completePropertyWithDictionary:dic];
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        }
        else if([notification.name isEqualToString:lsRequestTypeOrderCount])
        {
            //{
            //    type0 = 2;
            //    type1 = 0;
            //    type2 = 0;
            //}
            
            user.paidCount=[[notification.object objectForKey:@"type0"] integerValue];
            user.unpayCount=[[notification.object objectForKey:@"type1"] integerValue];
            if(_isMovieOpen)
            {
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
        else if([notification.name isEqualToString:LSNotificationAlipayUserInfo])
        {
            [self refreshControlEventValueChanged];
        }
    }
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(user.networkStatus==NotReachable)
    {
        return 2;
    }
    else
    {
        return 3;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section!=0)
    {
        return 44.f+10.f;
    }
    return 0.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section==1)
    {
        LSMySectionHeader* mySectionHeader=[[[LSMySectionHeader alloc] initWithFrame:CGRectZero] autorelease];
        mySectionHeader.mySectionHeaderType=LSMySectionHeaderTypeMovie;
        mySectionHeader.isOpen=_isMovieOpen;
        mySectionHeader.delegate=self;
        return mySectionHeader;
    }
    else if(section==2)
    {
        LSMySectionHeader* mySectionHeader=[[[LSMySectionHeader alloc] initWithFrame:CGRectZero] autorelease];
        mySectionHeader.mySectionHeaderType=LSMySectionHeaderTypeGroup;
        mySectionHeader.isOpen=_isGroupOpen;
        mySectionHeader.delegate=self;
        return mySectionHeader;
    }
    return nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
    {
        if(user.networkStatus==NotReachable)
        {
            return 1;
        }
        else
        {
            return 2;
        }
    }
    if(section==1)
    {
        if(user.networkStatus==NotReachable)
        {
            _isMovieOpen=YES;
            return _isMovieOpen?1:0;
        }
        else
        {
            return _isMovieOpen?2:0;
        }
    }
    else
    {
        return _isGroupOpen?2:0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        if(indexPath.row==0)
        {
            return [LSMyInfoCell heightOfUser];
        }
        else
        {
            return 44.f+10.f;
        }
    }
    return 44.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        if(indexPath.row==0)
        {
            LSMyInfoCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSMyInfoCell"];
            if(cell==nil)
            {
                cell=[[[LSMyInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSMyInfoCell"] autorelease];
            }
            [cell setNeedsDisplay];
            return cell;
        }
        else
        {
            LSMyMobileCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSMyMobileCell"];
            if(cell==nil)
            {
                cell=[[[LSMyMobileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSMyMobileCell"] autorelease];
                cell.delegate=self;
            }
            [cell setNeedsDisplay];
            return cell;
        }
    }
    else if(indexPath.section==1)
    {
        if(indexPath.row==0)
        {
            LSMyCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSMyCellPaid"];
            if(cell==nil)
            {
                cell=[[[LSMyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSMyCellPaid"] autorelease];
                cell.category=@"已付款";
            }
            cell.count=user.paidCount;
            [cell setNeedsDisplay];
            return cell;
        }
        else
        {
            LSMyCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSMyCellUnpay"];
            if(cell==nil)
            {
                cell=[[[LSMyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSMyCellUnpay"] autorelease];
                cell.category=@"待付款";
            }
            cell.count=user.unpayCount;
            [cell setNeedsDisplay];
            return cell;
        }
    }
    else
    {
        if(indexPath.row==0)
        {
            LSMyCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSMyCellGroup"];
            if(cell==nil)
            {
                cell=[[[LSMyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSMyCellGroup"] autorelease];
                cell.category=@"我的订单";
                cell.count=-1;
            }
            return cell;
        }
        else
        {
            LSMyCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSMyCellTicket"];
            if(cell==nil)
            {
                cell=[[[LSMyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSMyCellTicket"] autorelease];
                cell.category=@"我的拉手券";
                cell.count=-1;
            }
            return cell;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==1)
    {
        if(indexPath.row==0)
        {
            LSPaidOrdersViewController* paidOrdersViewController=[[LSPaidOrdersViewController alloc] init];
            paidOrdersViewController.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:paidOrdersViewController animated:YES];
            [paidOrdersViewController release];
        }
        else
        {
            LSUnpayOrdersViewController* unpayOrdersViewController=[[LSUnpayOrdersViewController alloc] init];
            unpayOrdersViewController.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:unpayOrdersViewController animated:YES];
            [unpayOrdersViewController release];
        }
    }
    else if(indexPath.section==2)
    {
        if(indexPath.row==0)
        {
            LSGroupsViewController* groupsViewController=[[LSGroupsViewController alloc] init];
            groupsViewController.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:groupsViewController animated:YES];
            [groupsViewController release];
        }
        else
        {
            LSTicketsViewController* ticketsViewController=[[LSTicketsViewController alloc] init];
            ticketsViewController.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:ticketsViewController animated:YES];
            [ticketsViewController release];
        }
    }
}

#pragma mark- LSMySectionHeader的委托方法
- (void)LSMySectionHeader:(LSMySectionHeader *)mySectionHeader isOpen:(BOOL)isOpen
{
    if(mySectionHeader.mySectionHeaderType==LSMySectionHeaderTypeMovie)
    {
        _isMovieOpen=isOpen;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else
    {
        _isGroupOpen=isOpen;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark- LSMyMobileCell的委托方法
- (void)LSMyMobileCellDidSelect
{
    LSBindViewController* bindViewController=[[LSBindViewController alloc] init];
    bindViewController.delegate=self;
    bindViewController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:bindViewController animated:YES];
    [bindViewController release];
}

#pragma mark- LSBindViewController的委托方法
- (void)LSBindViewControllerDidBindOrNot
{
    [self.navigationController popToViewController:self animated:YES];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma UIAlertView的委托方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex!=alertView.cancelButtonIndex)
    {
        [user logout];
        if([LSSave saveUser])
        {
            LSLOG(@"已经注销登录并保存了User信息");
        }
        [(LSTabBarController*)(self.tabBarController) LSTabBarControllerSelectedIndex:2];
    }
}

@end
