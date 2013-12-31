//
//  LSGroupCreateOrderViewController.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-10.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSGroupCreateOrderViewController.h"
#import "LSGroupCreateOrderCell.h"

@interface LSGroupCreateOrderViewController ()

@end

@implementation LSGroupCreateOrderViewController

@synthesize group=_group;
@synthesize delegate=_delegate;

#pragma mark- 生命周期
- (void)dealloc
{
    self.group=nil;
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
    self.title=@"提交订单";
    _amount=_group.minMustBuy;
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeGroupCreateByGroupID_Amount object:nil];
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeGroupInfoByOrderID object:nil];
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeUserProfile object:nil];
    
    if(user.userID!=nil && user.password!=nil)
    {
        [messageCenter LSMCUserProfile];
        [hud show:YES];
    }
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
            //状态
            if([notification.name isEqualToString:lsRequestTypeUserProfile] || [notification.name isEqualToString:lsRequestTypeGroupCreateByGroupID_Amount] || [notification.name isEqualToString:lsRequestTypeGroupInfoByOrderID])
            {
                LSStatus* status=notification.object;
                if(status.code==-3301)
                {
                    [LSAlertView showWithTag:0 title:nil message:@"您还有一笔尚未支付的订单，是否现在去支付" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
                    _maybeOrderID=[status.message retain];
                }
                else
                {
                    [LSAlertView showWithTag:-1 title:nil message:status.message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                }
            }
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
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
        else if([notification.name isEqualToString:lsRequestTypeGroupCreateByGroupID_Amount])
        {
            LSGroupOrder* groupOrder=[[LSGroupOrder alloc] initWithDictionary:notification.object];

            LSGroupPayViewController* groupPayViewController=[[LSGroupPayViewController alloc] init];
            groupPayViewController.groupOrder=groupOrder;
            groupPayViewController.delegate=self;
            [self.navigationController pushViewController:groupPayViewController animated:YES];
            [groupPayViewController release];
            
            [groupOrder release];
        }
        else if([notification.name isEqualToString:lsRequestTypeGroupInfoByOrderID])
        {
            LSGroupOrder* groupOrder=[[LSGroupOrder alloc] initWithDictionary:notification.object];
            
            LSGroupPayViewController* groupPayViewController=[[LSGroupPayViewController alloc] init];
            groupPayViewController.groupOrder=groupOrder;
            groupPayViewController.delegate=self;
            [self.navigationController pushViewController:groupPayViewController animated:YES];
            [groupPayViewController release];
            
            [groupOrder release];
        }
    }
}


#pragma mark- UITableView的委托方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.f;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel* label=[[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    label.backgroundColor=[UIColor clearColor];
    label.font=LSFont14;
    label.text=@" 订单详情";
    return label;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 64.f;
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    LSGroupCreateOrderSectionFooter* groupCreateOrderSectionFooter=[[[LSGroupCreateOrderSectionFooter alloc] initWithFrame:CGRectZero] autorelease];
    groupCreateOrderSectionFooter.delegate=self;
    return groupCreateOrderSectionFooter;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row!=4)
    {
        return 44.f;
    }
    return 44.f+10.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        LSGroupCreateOrderCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSGroupCreateOrderCellName"];
        if(cell==nil)
        {
            cell=[[[LSGroupCreateOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSGroupCreateOrderCellName"] autorelease];
            cell.topRadius=3.f;
            cell.textLabel.text=@"名称";
            cell.infoLabel.text=_group.groupTitle;
        }
        return cell;
    }
    else if(indexPath.row==1)
    {
        LSGroupCreateOrderCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSGroupCreateOrderCellPrice"];
        if(cell==nil)
        {
            cell=[[[LSGroupCreateOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSGroupCreateOrderCellPrice"] autorelease];
            NSString* text = [[NSString stringWithFormat:@"￥%.2f", _group.price] stringByReplacingOccurrencesOfString:@".00" withString:@""];
            cell.textLabel.text=@"单价";
            cell.infoLabel.text=text;
        }
        return cell;
    }
    else if(indexPath.row==2)
    {
        LSGroupCreateOrderAmountCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSGroupCreateOrderAmountCell"];
        if(cell==nil)
        {
            cell=[[[LSGroupCreateOrderAmountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSGroupCreateOrderAmountCell"] autorelease];
            cell.textLabel.text=@"数量";
            cell.group=_group;
            cell.delegate=self;
        }
        return cell;
    }
    else if(indexPath.row==3)
    {
        LSGroupCreateOrderCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSGroupCreateOrderCellTotalPrice"];
        if(cell==nil)
        {
            cell=[[[LSGroupCreateOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSGroupCreateOrderCellTotalPrice"] autorelease];

            cell.textLabel.text=@"总价";
            cell.infoLabel.font=[UIFont systemFontOfSize:18.0];
            cell.bottomRadius=3.f;
            cell.isBottomLine=YES;
        }
        NSString* text = [[NSString stringWithFormat:@"￥%.2f", _group.price*_amount] stringByReplacingOccurrencesOfString:@".00" withString:@""];
        cell.infoLabel.text=text;
        return cell;
    }
    else
    {
        LSGroupCreateOrderMobileCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSGroupCreateOrderMobileCell"];
        if(cell==nil)
        {
            cell=[[[LSGroupCreateOrderMobileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSGroupCreateOrderMobileCell"] autorelease];
            cell.delegate=self;
        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark- LSGroupCreateOrderAmountCell的委托方法
- (void)LSGroupCreateOrderAmountCell:(LSGroupCreateOrderAmountCell *)groupCreateOrderAmountCell didChangeAmount:(NSInteger)amount
{
    _amount=amount;
    [self.tableView reloadData];
}

#pragma mark- LSGroupCreateOrderMobileCell的委托方法
- (void)LSGroupCreateOrderMobileCellDidSelect
{
    LSBindViewController* bindViewController=[[LSBindViewController alloc] init];
    bindViewController.delegate=self;
    [self.navigationController pushViewController:bindViewController animated:YES];
    [bindViewController release];
}

#pragma mark- LSGroupCreateOrderSectionFooter的委托方法
- (void)LSGroupCreateOrderSectionFooter:(LSGroupCreateOrderSectionFooter *)groupCreateOrderSectionFooter didClickSubmitButton:(UIButton *)submitButton
{
    [messageCenter LSMCGroupCreateWithGroupID:_group.groupID amount:_amount];
    [hud show:YES];
}

#pragma mark- LSGroupInfoViewController的委托方法
- (void)LSGroupPayViewControllerDidPay
{
    if([_delegate respondsToSelector:@selector(LSGroupCreateOrderViewControllerDidCreateOrder)])
    {
        [_delegate LSGroupCreateOrderViewControllerDidCreateOrder];
    }
}
- (void)LSGroupPayViewControllerDidCancel
{
    [self.navigationController popToViewController:self animated:YES];
}

#pragma mark- LSBindViewController的委托方法
- (void)LSBindViewControllerDidBindOrNot
{
    [self.navigationController popToViewController:self animated:YES];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark- UIAlertView的委托方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex!=alertView.cancelButtonIndex)
    {
        [messageCenter LSMCGroupInfoWithOrderID:_maybeOrderID];
        [hud show:YES];
    }
}

@end
