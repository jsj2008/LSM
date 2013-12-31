//
//  LSGroupInfoViewController.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-10.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSGroupInfoViewController.h"
#import "LSGroupDetailViewController.h"
#import "LSGroupsViewController.h"
#import "LSShareViewController.h"
#import "LSCinemaMapViewController.h"
#import "LSNavigationController.h"

#import "LSGroupInfoImageCell.h"
#import "LSGroupInfoInfoCell.h"
#import "LSGroupInfoWebCell.h"
#import "LSGroupInfoDetailCell.h"

@interface LSGroupInfoViewController ()

@end

@implementation LSGroupInfoViewController

@synthesize group=_group;
@synthesize cinema=_cinema;

- (void)dealloc
{
    self.group=nil;
    self.cinema=nil;
    LSRELEASE(_otherGroupMArray)
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
    self.title=@"商品描述";
    _otherGroupMArray=[[NSMutableArray alloc] initWithCapacity:0];

    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeGroupInfoByGroupID object:nil];
    [messageCenter LSMCGroupInfoWithGroupID:_group.groupID];
    
    [self makeOtherGroupMArray];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)makeOtherGroupMArray
{
    [_otherGroupMArray removeAllObjects];
    if(_cinema.groupArray.count>1)
    {
        for(LSGroup* group in _cinema.groupArray)
        {
            if(![group isEqual:_group])
            {
                if(![_otherGroupMArray containsObject:group])
                {
                    [_otherGroupMArray addObject:group];
                }
            }
        }
    }
}

#pragma mark- 重载方法
- (void)otherButtonClick:(UIButton *)sender
{
    UIActionSheet* actionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享到新浪微博", @"分享到腾讯微博", nil];
    actionSheet.tag=0;
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    [actionSheet release];
}

#pragma mark- 私有方法
- (void)makeGroupCreateOrderViewController
{
    LSGroupCreateOrderViewController* groupCreateOrderViewController=[[LSGroupCreateOrderViewController alloc] init];
    groupCreateOrderViewController.group=_group;
    groupCreateOrderViewController.delegate=self;
    [self.navigationController pushViewController:groupCreateOrderViewController animated:YES];
    [groupCreateOrderViewController release];
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
            //状态
            return;
        }
        
        if([notification.object isKindOfClass:[LSError class]])
        {
            //错误
            return;
        }
        
        if([notification.name isEqualToString:lsRequestTypeGroupInfoByGroupID])
        {
            [_group completePropertyWithDictionary:notification.object];
            [self.tableView reloadData];
        }
    }
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 54.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    LSGroupInfoSectionFooter* groupInfoSectionFooter=[[[LSGroupInfoSectionFooter alloc] initWithFrame:CGRectZero] autorelease];
    groupInfoSectionFooter.group=_group;
    groupInfoSectionFooter.delegate=self;
    return groupInfoSectionFooter;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_otherGroupMArray.count>0)
    {
        return 7;
    }
    else
    {
        return 6;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        return 190.f;
    }
    else if(indexPath.row==1)
    {
        return [LSGroupInfoInfoCell heightOfGroup:_group];
    }
    else if(indexPath.row==2)
    {
        return [LSGroupInfoPositionCell heightOfCinema:_cinema];
    }
    else if(_otherGroupMArray.count>0)
    {
        if(indexPath.row==3)
        {
            if(_isOpen)
            {
                return 54.f+44.f*_otherGroupMArray.count;
            }
            else
            {
                return 54.f;
            }
        }
        else if(indexPath.row==4)
        {
            return 300.f;
        }
        else if(indexPath.row==5)
        {
            return 54.f;
        }
        else
        {
            return 64.f;
        }
    }
    else
    {
        if(indexPath.row==3)
        {
            return 300.f;
        }
        else if(indexPath.row==4)
        {
            return 54.f;
        }
        else
        {
            return 64.f;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        LSGroupInfoImageCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSGroupInfoImageCell"];
        if(cell==nil)
        {
            cell=[[[LSGroupInfoImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSGroupInfoImageCell"] autorelease];
        }
        [cell.imageView setImageWithURL:[NSURL URLWithString:_group.bigImageURL] placeholderImage:[UIImage lsImageNamed:@"goodsInfoDefaults.png"]];
        return cell;
    }
    else if(indexPath.row==1)
    {
        LSGroupInfoInfoCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSGroupInfoInfoCell"];
        if(cell==nil)
        {
            cell=[[[LSGroupInfoInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSGroupInfoInfoCell"] autorelease];
        }
        cell.group=_group;
        [cell setNeedsDisplay];
        return cell;
    }
    else if(indexPath.row==2)
    {
        LSGroupInfoPositionCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSGroupInfoPositionCell"];
        if(cell==nil)
        {
            cell=[[[LSGroupInfoPositionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSGroupInfoPositionCell"] autorelease];
            cell.cinema=_cinema;
            cell.delegate=self;
        }
        return cell;
    }
    else if(_otherGroupMArray.count>0)
    {
        if(indexPath.row==3)
        {
            LSGroupInfoGroupCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSGroupInfoGroupCell"];
            if(cell==nil)
            {
                cell=[[[LSGroupInfoGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSGroupInfoGroupCell"] autorelease];
                cell.delegate=self;
            }
            cell.isOpen=_isOpen;
            cell.groupArray=_otherGroupMArray;
            [cell setNeedsLayout];
            return cell;
        }
        else if(indexPath.row==4)
        {
            LSGroupInfoWebCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSGroupInfoWebCell"];
            if(cell==nil)
            {
                cell=[[[LSGroupInfoWebCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSGroupInfoWebCell"] autorelease];
            }
            cell.html=_group.goodsTips;
            [cell setNeedsLayout];
            return cell;
        }
        else if(indexPath.row==5)
        {
            LSGroupInfoDetailCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSGroupInfoDetailCell"];
            if(cell==nil)
            {
                cell=[[[LSGroupInfoDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSGroupInfoDetailCell"] autorelease];
            }
            return cell;
        }
        else
        {
            LSGroupInfoPhoneCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSGroupInfoPhoneCell"];
            if(cell==nil)
            {
                cell=[[[LSGroupInfoPhoneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSGroupInfoPhoneCell"] autorelease];
                cell.delegate=self;
            }
            return cell;
        }
    }
    else
    {
        if(indexPath.row==3)
        {
            LSGroupInfoWebCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSGroupInfoWebCell"];
            if(cell==nil)
            {
                cell=[[[LSGroupInfoWebCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSGroupInfoWebCell"] autorelease];
            }
            cell.html=_group.goodsTips;
            [cell setNeedsLayout];
            return cell;
        }
        else if(indexPath.row==4)
        {
            LSGroupInfoDetailCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSGroupInfoDetailCell"];
            if(cell==nil)
            {
                cell=[[[LSGroupInfoDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSGroupInfoDetailCell"] autorelease];
            }
            return cell;
        }
        else
        {
            LSGroupInfoPhoneCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSGroupInfoPhoneCell"];
            if(cell==nil)
            {
                cell=[[[LSGroupInfoPhoneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSGroupInfoPhoneCell"] autorelease];
                cell.delegate=self;
            }
            return cell;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_otherGroupMArray.count>0)
    {
        if(indexPath.row==5)
        {
            LSGroupDetailViewController* groupDetailViewController=[[LSGroupDetailViewController alloc] init];
            groupDetailViewController.html=_group.graphicDetails;
            [self.navigationController pushViewController:groupDetailViewController animated:YES];
            [groupDetailViewController release];
        }
    }
    else
    {
        if(indexPath.row==4)
        {
            LSGroupDetailViewController* groupDetailViewController=[[LSGroupDetailViewController alloc] init];
            groupDetailViewController.html=_group.graphicDetails;
            [self.navigationController pushViewController:groupDetailViewController animated:YES];
            [groupDetailViewController release];
        }
    }
}

#pragma mark- LSGroupInfoSectionFooter的委托方法
- (void)LSGroupInfoSectionFooter:(LSGroupInfoSectionFooter *)groupInfoSectionFooter didClickBuyButton:(UIButton *)buyButton
{
    if(user.userID!=nil)
    {
        [self makeGroupCreateOrderViewController];
    }
    else
    {
        //在确定按钮的时候首先保证用户是已经登陆的
        LSLoginViewController* loginViewController=[[LSLoginViewController alloc] init];
        loginViewController.delegate=self;
        
        LSNavigationController* navigationController=[[LSNavigationController alloc] initWithRootViewController:loginViewController];
        [self presentModalViewController:navigationController animated:YES];
        
        [loginViewController release];
        [navigationController release];
    }
}

#pragma mark- LSLoginViewController的委托方法
- (void)LSLoginViewControllerDidLoginByType:(LSLoginType)loginType
{
    [self dismissModalViewControllerAnimated:YES];
    if(loginType!=LSLoginTypeNon)
    {
        [self makeGroupCreateOrderViewController];
    }
}

#pragma mark- LSGroupInfoPositionCell的委托方法
- (void)LSGroupInfoPositionCell:(LSGroupInfoPositionCell *)groupInfoPositionCell didClickMapButton:(UIButton *)mapButton
{
    LSCinemaMapViewController* cinemaMapViewController=[[LSCinemaMapViewController alloc] init];
    cinemaMapViewController.cinema=_cinema;
    [self.navigationController pushViewController:cinemaMapViewController animated:YES];
    [cinemaMapViewController release];
}
- (void)LSGroupInfoPositionCell:(LSGroupInfoPositionCell *)groupInfoPositionCell didClickPhoneButton:(UIButton *)phoneButton
{
    UIActionSheet* actionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:[NSString stringWithFormat:@"呼叫 %@",_cinema.phone] otherButtonTitles:nil];
    actionSheet.tag=1;
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    [actionSheet release];
}

#pragma mark- LSGroupInfoGroupCell的委托方法
- (void)LSGroupInfoGroupCell:(LSGroupInfoGroupCell *)groupInfoGroupCell isOpen:(BOOL)isOpen
{
    _isOpen=isOpen;
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//    [self.tableView reloadData];
}
- (void)LSGroupInfoGroupCell:(LSGroupInfoGroupCell *)groupInfoGroupCell didSelectRowAtIndexPath:(NSInteger)indexPath
{
    self.group=[_otherGroupMArray objectAtIndex:indexPath];
    _isOpen=NO;
    [messageCenter LSMCGroupInfoWithGroupID:_group.groupID];
    [self makeOtherGroupMArray];
}

#pragma mark- LSGroupInfoPhoneCell的委托方法
- (void)LSGroupInfoPhoneCell:(LSGroupInfoPhoneCell *)groupInfoPhoneCell didClickPhoneButton:(UIButton *)phoneButton
{
    UIActionSheet* actionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:[NSString stringWithFormat:@"呼叫 %@",lsServicePhoneCall] otherButtonTitles:nil];
    actionSheet.tag=2;
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    [actionSheet release];
}

#pragma mark- UIActionSheet的委托方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag==0)
    {
        if(buttonIndex==0)
        {
            if([LSShare sinaWBShareAuthStatus])
            {
                [self makeShareViewController:LSShareTypeSinaWB];
            }
            else
            {
                LSSinaWBAuthViewController* sinaWBAuthViewController = [[LSSinaWBAuthViewController alloc] init];
                sinaWBAuthViewController.delegate=self;
                [self.navigationController pushViewController:sinaWBAuthViewController animated:YES];
                [sinaWBAuthViewController release];
            }
        }
        else if(buttonIndex==1)
        {
            if([LSShare qqWBShareAuthStatus])
            {
                [self makeShareViewController:LSShareTypeQQWB];
            }
            else
            {
                LSQQWBAuthViewController* QQWBAuthViewController = [[LSQQWBAuthViewController alloc] init];
                QQWBAuthViewController.delegate=self;
                [self.navigationController pushViewController:QQWBAuthViewController animated:YES];
                [QQWBAuthViewController release];
            }
        }
    }
    else if(actionSheet.tag==1)
    {
        if(buttonIndex==actionSheet.destructiveButtonIndex)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", lsServicePhoneReal]]];
        }
    }
    else if(actionSheet.tag==2)
    {
        if(buttonIndex==actionSheet.destructiveButtonIndex)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", _cinema.phone]]];
        }
    }
}

#pragma mark- LSGroupCreateOrderViewController的委托方法
- (void)LSGroupCreateOrderViewControllerDidCreateOrder
{
    [self.navigationController popToViewController:self animated:NO];
    
    LSGroupsViewController* groupsViewController=[[LSGroupsViewController alloc] init];
    groupsViewController.groupStatus=LSGroupStatusPaid;
    [self.navigationController pushViewController:groupsViewController animated:YES];
    [groupsViewController release];
}

#pragma mark- LSSinaWBAuthViewController的委托方法
- (void)LSSinaWBAuthViewControllerDidLogin
{
    [self.navigationController popToViewController:self animated:NO];
    [self makeShareViewController:LSShareTypeSinaWB];
}

#pragma mark- LSQQWBAuthViewController的委托方法
- (void)LSQQWBAuthViewControllerDidLogin
{
    [self.navigationController popToViewController:self animated:NO];
    [self makeShareViewController:LSShareTypeQQWB];
}

#pragma mark- 私有方法
- (void)makeShareViewController:(LSShareType)shareType
{
    LSShareViewController* shareViewController=[[LSShareViewController alloc] init];
    NSString* message=[NSString stringWithFormat:@"#拉手网##%@#%@，地址：http://m.lashou.com/detail.php?id=%@",user.cityName,_group.groupTitle,_group.groupID];
    shareViewController.message=message;
    shareViewController.shareType=shareType;
    shareViewController.imgURL=_group.bigImageURL;
    [self.navigationController pushViewController:shareViewController animated:YES];
    [shareViewController release];
}

@end
