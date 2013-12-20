//
//  LSGroupInfoViewController.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-9.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSGroupPayViewController.h"
#import "LSGroupPayCell.h"
#import "LSGroupPayNeedPayCell.h"

@interface LSGroupPayViewController ()

@end

@implementation LSGroupPayViewController

@synthesize groupOrder=_groupOrder;
@synthesize delegate=_delegate;

#pragma mark- 生命周期
- (void)dealloc
{
    self.groupOrder=nil;
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
    self.title=@"订单详情";
    self.view.backgroundColor=LSColorBgWhiteColor;
    
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeGroupCancelByOrderID object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- 通知中心消息
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
            LSStatus* status=notification.object;
            if([notification.name isEqualToString:lsRequestTypeGroupCancelByOrderID])
            {
                if(status.code==11)
                {
                    //成功取消订单
                    if([_delegate respondsToSelector:@selector(LSGroupPayViewControllerDidCancel)])
                    {
                        [_delegate LSGroupPayViewControllerDidCancel];
                    }
                }
                else
                {
                    [LSAlertView showWithTag:-1 title:nil message:status.message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                }
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
    label.textColor=LSColorBlackRedColor;
    label.text=@" 订单信息";
    return label;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(_groupOrder.orderStatus==LSGroupStatusPaid)
    {
        return 0.f;
    }
    else
    {
        return 64.f;
    }
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    LSGroupPaySectionFooter* groupPaySectionFooter=[[[LSGroupPaySectionFooter alloc] initWithFrame:CGRectZero] autorelease];
    groupPaySectionFooter.delegate=self;
    return groupPaySectionFooter;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        LSGroupPayCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSGroupInfoCellName"];
        if(cell==nil)
        {
            cell=[[[LSGroupPayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSGroupPayCellName"] autorelease];
            cell.topRadius=3.f;
            cell.textLabel.text=@"商品名称";
            cell.infoLabel.text=_groupOrder.groupTitle;
        }
        return cell;
    }
    else if(indexPath.row==1)
    {
        LSGroupPayCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSGroupInfoCellOrderID"];
        if(cell==nil)
        {
            cell=[[[LSGroupPayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSGroupPayCellOrderID"] autorelease];
            cell.textLabel.text=@"订单号";
            cell.infoLabel.text=_groupOrder.orderID;
        }
        return cell;
    }
    else if(indexPath.row==2)
    {
        LSGroupPayCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSGroupPayCellTime"];
        if(cell==nil)
        {
            cell=[[[LSGroupPayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSGroupPayCellTime"] autorelease];
            cell.textLabel.text=@"购买时间";
            cell.infoLabel.text=[_groupOrder.buyTime stringValueByFormatter:@"yyyy-MM-dd hh:mm"];
        }
        return cell;
    }
    else if(indexPath.row==3)
    {
        LSGroupPayCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSGroupPayCellAmount"];
        if(cell==nil)
        {
            cell=[[[LSGroupPayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSGroupPayCellAmount"] autorelease];
            cell.textLabel.text=@"数量";
            cell.infoLabel.text=_groupOrder.amount;
        }
        return cell;
    }
    else if(indexPath.row==4)
    {
        LSGroupPayCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSGroupPayCellPrice"];
        if(cell==nil)
        {
            cell=[[[LSGroupPayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSGroupPayCellPrice"] autorelease];
            cell.textLabel.text=@"总价";
            cell.infoLabel.text=_groupOrder.totalPrice;
        }
        return cell;
    }
    else if(indexPath.row==5)
    {
        if(_groupOrder.orderStatus==LSGroupStatusPaid)
        {
            LSGroupPayCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSGroupPayCellPaid"];
            if(cell==nil)
            {
                cell=[[[LSGroupPayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSGroupPayCellPaid"] autorelease];
                cell.bottomRadius=3.f;
                cell.isBottomLine=YES;
                cell.textLabel.text=@"总价";
                cell.infoLabel.text=@"已经购买";
            }
            return cell;
        }
        else
        {
            LSGroupPayNeedPayCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSGroupPayNeedPayCell"];
            if(cell==nil)
            {
                cell=[[[LSGroupPayNeedPayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSGroupPayNeedPayCell"] autorelease];
                cell.bottomRadius=3.f;
                cell.isBottomLine=YES;
                cell.needPay=_groupOrder.needPay;
            }
            return cell;
        }
    }
    
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark- LSGroupInfoSectionFooter的委托方法
- (void)LSGroupPaySectionFooter:(LSGroupPaySectionFooter *)groupPaySectionFooter didClickCancelButton:(UIButton *)cancelButton
{
    [messageCenter LSMCGroupCancelWithOrderID:_groupOrder.orderID];
}

- (void)LSGroupPaySectionFooter:(LSGroupPaySectionFooter *)groupPaySectionFooter didClickPayButton:(UIButton *)payButton
{
    LSGroupWebPayViewController* groupWebPayViewController=[[LSGroupWebPayViewController alloc] init];
    groupWebPayViewController.groupOrder=_groupOrder;
    groupWebPayViewController.delegate=self;
    [self.navigationController pushViewController:groupWebPayViewController animated:YES];
    [groupWebPayViewController release];
}

#pragma mark- LSGroupPayViewController的委托方法
- (void)LSGroupWebPayViewControllerDidPay
{
    if([_delegate respondsToSelector:@selector(LSGroupPayViewControllerDidPay)])
    {
        [_delegate LSGroupPayViewControllerDidPay];
    }
}

@end
