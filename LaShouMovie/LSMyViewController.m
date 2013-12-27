//
//  LSMyViewController.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-30.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSMyViewController.h"
#import "LSMyCell.h"
#import "LSMyCouponCell.h"
#import "LSMyLogoutCell.h"
#import "LSSeparatorCell.h"
#import "LSPaidOrdersViewController.h"
#import "LSUnpayOrdersViewController.h"
#import "LSGroupsViewController.h"
#import "LSTicketsViewController.h"
#import "LSCouponsViewController.h"
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
    self.navigationController.navigationBarHidden=YES;
    
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeUserProfile object:nil];
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeOrderCount object:nil];
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:LSNotificationAlipayUserInfo object:nil];
    
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
            
            user.paidCount=[[notification.object objectForKey:@"type0"] intValue];
            user.unpayCount=[[notification.object objectForKey:@"type1"] intValue];
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


#pragma mark- UITableViewd的委托方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 65.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(_myHeaderView==nil)
    {
        _myHeaderView=[[LSMyHeaderView alloc] initWithFrame:CGRectZero];
    }
    [_myHeaderView setNeedsDisplay];
    return _myHeaderView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(user.networkStatus==NotReachable)
    {
        return 3;
    }
    else
    {
        return 15;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0 || indexPath.row==2 || indexPath.row==6 || indexPath.row==10 || indexPath.row==12 || indexPath.row==14)
    {
        return 20.f;
    }
    else
    {
        if(indexPath.row==4 || indexPath.row==5)
        {
            if(_isMovieOpen)
            {
                return 44.f;
            }
            else
            {
                return 0.f;
            }
        }
        else if(indexPath.row==8 || indexPath.row==9)
        {
            if(_isGroupOpen)
            {
                return 44.f;
            }
            else
            {
                return 0.f;
            }
        }
        else
        {
            return 44.f;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0 || indexPath.row==2 || indexPath.row==6 || indexPath.row==10 || indexPath.row==12 || indexPath.row==14)
    {
        LSSeparatorCell* cell=[tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"LSSeparatorCell%d",indexPath.row]];
        if(cell==nil)
        {
            cell=[[[LSSeparatorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"LSSeparatorCell%d",indexPath.row]] autorelease];
        }
        return cell;
    }
    else
    {
        if(indexPath.row==1)
        {
            LSMyPhoneCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSMyPhoneCell"];
            if(cell==nil)
            {
                cell=[[[LSMyPhoneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSMyMobileCell"] autorelease];
                if(user.mobile==nil)
                {
                    cell.title=@"未绑定手机号码";
                    cell.titleClick=@"绑定";
                }
                else
                {
                    cell.title=user.mobile;
                    cell.titleClick=@"更换";
                }
                cell.delegate=self;
            }
            [cell setNeedsDisplay];
            return cell;
        }
        else if(indexPath.row==3)
        {
            LSMyCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSMyCellMovieTitle"];
            if(cell==nil)
            {
                cell=[[[LSMyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSMyCellMovieTitle"] autorelease];
                cell.title=@"订座电影票";
                cell.imageName=@"";
            }
            return cell;
        }
        else if(indexPath.row==4)
        {
            LSMyCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSMyCellMoviePaid"];
            if(cell==nil)
            {
                cell=[[[LSMyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSMyCellMoviePaid"] autorelease];
                cell.title=[NSString stringWithFormat:@"已付款(%d)",user.paidCount];
            }
            return cell;
        }
        else if(indexPath.row==5)
        {
            LSMyCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSMyCellMovieUnpay"];
            if(cell==nil)
            {
                cell=[[[LSMyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSMyCellMovieUnpay"] autorelease];
                cell.title=[NSString stringWithFormat:@"待付款(%d)",user.unpayCount];
            }
            return cell;
        }
        else if(indexPath.row==7)
        {
            LSMyCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSMyCellGroupTitle"];
            if(cell==nil)
            {
                cell=[[[LSMyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSMyCellGroupTitle"] autorelease];
                cell.title=@"团购电影票";
                cell.imageName=@"";
            }
            return cell;
        }
        else if(indexPath.row==8)
        {
            LSMyCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSMyCellGroupOrder"];
            if(cell==nil)
            {
                cell=[[[LSMyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSMyCellGroupOrder"] autorelease];
                cell.title=@"我的订单";
            }
            return cell;
        }
        else if(indexPath.row==9)
        {
            LSMyCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSMyCellGroupTicket"];
            if(cell==nil)
            {
                cell=[[[LSMyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSMyCellGroupTicket"] autorelease];
                cell.title=@"我的拉手券";
            }
            return cell;
        }
        else if(indexPath.row==11)
        {
            LSMyCouponCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSMyCouponCell"];
            if(cell==nil)
            {
                cell=[[[LSMyCouponCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSMyCouponCell"] autorelease];
                cell.title=@"我的抵用券";
                cell.imageName=@"";
            }
            return cell;
        }
        else
        {
            LSMyLogoutCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSMyLogoutCell"];
            if(cell==nil)
            {
                cell=[[[LSMyLogoutCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSMyLogoutCell"] autorelease];
                cell.title=@"注销";
                cell.imageName=@"";
            }
            return cell;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==3)
    {
        _isMovieOpen=!_isMovieOpen;
        [self.tableView reloadData];
    }
    else if(indexPath.row==4)
    {
        LSPaidOrdersViewController* paidOrdersViewController=[[LSPaidOrdersViewController alloc] init];
        paidOrdersViewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:paidOrdersViewController animated:YES];
        [paidOrdersViewController release];
    }
    else if(indexPath.row==5)
    {
        LSUnpayOrdersViewController* unpayOrdersViewController=[[LSUnpayOrdersViewController alloc] init];
        unpayOrdersViewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:unpayOrdersViewController animated:YES];
        [unpayOrdersViewController release];
    }
    else if(indexPath.row==7)
    {
        _isGroupOpen=!_isGroupOpen;
        [self.tableView reloadData];
    }
    else if(indexPath.row==8)
    {
        LSGroupsViewController* groupsViewController=[[LSGroupsViewController alloc] init];
        groupsViewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:groupsViewController animated:YES];
        [groupsViewController release];
    }
    else if(indexPath.row==9)
    {
        LSTicketsViewController* ticketsViewController=[[LSTicketsViewController alloc] init];
        ticketsViewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:ticketsViewController animated:YES];
        [ticketsViewController release];
    }
    else if(indexPath.row==11)
    {
        LSCouponsViewController* couponsViewController=[[LSCouponsViewController alloc] init];
        couponsViewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:couponsViewController animated:YES];
        [couponsViewController release];
    }
    else if(indexPath.row==13)
    {
        [LSAlertView showWithTag:0 title:@"确定注销？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"注销", nil];
    }
}

#pragma mark- LSMyPhoneCell的委托方法
- (void)LSMyPhoneCell:(LSMyPhoneCell *)myPhoneCell didClickBindButton:(UIButton *)bindButton
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
