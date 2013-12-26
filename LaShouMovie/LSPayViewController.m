//
//  LSPayViewController.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-26.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSPayViewController.h"

#import "LSPayShouldPayCell.h"
#import "LSPayBalanceCell.h"
#import "LSPayNeedPayCell.h"
#import "LSPayWayCell.h"

#import "AlixPayResult.h"
#import "AlixLibService.h"

@interface LSPayViewController ()

@end

@implementation LSPayViewController

@synthesize order=_order;
@synthesize delegate=_delegate;

#pragma mark- 生命周期
- (void)dealloc
{
    self.order=nil;
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
    self.title=@"支付";

    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:LSNotificationOrderTimeChanged object:nil];
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeOrderOtherPayInfoByOrderID_PayWay_IsCoupon object:nil];
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypePayBalancePayByOrderID_IsCoupon_SecurityCode object:nil];
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:LSNotificationAlipaySuccess object:nil];
    
    _countDownView=[[LSCountDownView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.width, 44.f)];
    _countDownView.minute=[_order expireSecond]/60;
    _countDownView.second=[_order expireSecond]%60;
    [_countDownView startCountDown];
    self.tableView.tableHeaderView=_countDownView;
    [_countDownView release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- 重载方法
- (void)leftBarButtonItemClick:(UIBarButtonItem *)sender
{
    [_countDownView stopCountDown];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- 私有方法
- (void)makePaidOrdersViewController:(LSPayWayType)payWayType
{
    LSPaidOrdersViewController* paidOrdersViewController=[[LSPaidOrdersViewController alloc] init];
    if(user.isCreateCard && payWayType==LSPayWayTypeAlipay)
    {
        paidOrdersViewController.isCardRemind=YES;
    }
    paidOrdersViewController.delegate=self;
    [self.navigationController pushViewController:paidOrdersViewController animated:YES];
    [paidOrdersViewController release];
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
            LSStatus* status=notification.object;
            if([notification.name isEqualToString:lsRequestTypePayBalancePayByOrderID_IsCoupon_SecurityCode])
            {
                if (status.code == 1)//正常的余额付款流程
                {
                    [LSAlertView showWithTag:0 title:nil message:status.message delegate:self cancelButtonTitle:@"余额支付" otherButtonTitles:nil];
                }
                else if (status.code == 2)//完全使用优惠券付款
                {
                    [LSAlertView showWithTag:1 title:nil message:status.message delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                }
                else
                {
                    [LSAlertView showWithTag:-1 title:nil message:status.message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                }
            }
            else
            {
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
        
        if([notification.name isEqualToString:lsRequestTypePayBalancePayByOrderID_IsCoupon_SecurityCode])
        {
            [_countDownView stopCountDown];
            [self makePaidOrdersViewController:LSPayWayTypeBalance];
        }
        else if([notification.name isEqualToString:lsRequestTypeOrderOtherPayInfoByOrderID_PayWay_IsCoupon])
        {
#warning 这里需要处理所有的支付类型
            if(_order.payWay==LSPayWayTypeAlipay)
            {
                [AlixLibService payOrder:notification.object AndScheme:lsURLScheme seletor:@selector(aliPaymentResult:) target:self];
            }
        }
        else if([notification.name isEqualToString:LSNotificationAlipaySuccess])
        {
            [_countDownView stopCountDown];
            if(user.isCreateCard)
            {
                [messageCenter LSMCAlipayCreateCardWithOrderID:_order.orderID];
            }
            [self makePaidOrdersViewController:LSPayWayTypeAlipay];
        }
        else if([notification.name isEqualToString:LSNotificationOrderTimeChanged])
        {
            [_countDownView stopCountDown];
            _countDownView.minute=[_order expireSecond]/60;
            _countDownView.second=[_order expireSecond]%60;
            [_countDownView startCountDown];
        }
    }
}

#pragma mark - UITableView委托方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.f;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel* headerLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    headerLabel.backgroundColor=LSColorBackgroundGray;
    headerLabel.textColor = LSColorTextGray;
    headerLabel.font = LSFontSectionHeader;
    if(section==0)
    {
        headerLabel.text=@"支付信息";
    }
    else
    {
        headerLabel.text=@"支付方式";
    }
    return headerLabel;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
    {
        return 4;
    }
    else
    {
        return user.payWayArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        if(indexPath.row==0)
        {
            LSPayShouldPayCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSPayShouldPayCell"];
            if(cell==nil)
            {
                cell=[[[LSPayShouldPayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSPayShouldPayCell"] autorelease];
                cell.order=_order;
            }
            return cell;
        }
        else if(indexPath.row==3)
        {
            LSPayCouponCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSPayCouponCell"];
            if(cell==nil)
            {
                cell=[[[LSPayCouponCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSPayCouponCell"] autorelease];
                cell.order=_order;
                cell.delegate=self;
            }
            [cell setNeedsDisplay];
            return cell;
        }
        else if(indexPath.row==4)
        {
            LSPayBalanceCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSPayBalanceCell"];
            if(cell==nil)
            {
                cell=[[[LSPayBalanceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSPayBalanceCell"] autorelease];
                cell.order=_order;
            }
            return cell;
        }
        else
        {
            LSPayNeedPayCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSPayNeedPayCell"];
            if(cell==nil)
            {
                cell=[[[LSPayNeedPayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSPayNeedPayCell"] autorelease];
                cell.order=_order;
            }
            [cell setNeedsDisplay];
            return cell;
        }
    }
    else
    {
        LSPayWayCell* cell=[tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"LSPayWayCell%d",indexPath.row]];
        if(cell==nil)
        {
            cell=[[[LSPayWayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"LSPayWayCell%d",indexPath.row]] autorelease];
            cell.payWay=[user.payWayArray objectAtIndex:indexPath.row];
            cell.isInitial=!indexPath.row;
        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==1)
    {
        for(UITableViewCell* cell in tableView.visibleCells)
        {
            if([cell isKindOfClass:[LSPayWayCell class]])
            {
                ((LSPayWayCell*)cell).isInitial=NO;
                [cell setNeedsLayout];
            }
        }
        
        LSPayWayCell* cell=(LSPayWayCell*)[tableView cellForRowAtIndexPath:indexPath];
        cell.isInitial=YES;
        [cell setNeedsLayout];
        
        _order.payWay=cell.payWay.payWayID;
    }
}

#pragma mark- LSPayCouponCell的委托
- (void)LSPayCouponCell:(LSPayCouponCell *)payCouponCell didClickCouponButton:(UIButton *)sender
{
    LSCouponViewController* couponViewController=[[LSCouponViewController alloc] init];
    couponViewController.order=_order;
    couponViewController.delegate=self;
    [self.navigationController pushViewController:couponViewController animated:YES];
    [couponViewController release];
}

#pragma mark- LSPayFooterView的委托
- (void)LSPayFooterViewDidToPayByPayType:(LSPayType)payType
{
    if(payType==LSPayTypeBalance)
    {
        [hud show:YES];
        [messageCenter LSMCPayBalancePayWithOrderID:_order.orderID isUseCoupon:_order.isUseCoupon securityCode:nil];
    }
    else if(payType==LSPayTypeAlipay)
    {
        [hud show:YES];
        [messageCenter LSMCOrderOtherPayInfoWithOrderID:_order.orderID payWay:_order.payWay isUseCoupon:_order.isUseCoupon];
    }
}
- (void)LSCountDownViewDidTimeout
{
    [_delegate LSPayViewControllerDidPay];
}

#pragma mark- UIAlertView的委托方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==0)
    {
        LSSecurityCodeView* securityCodeView=[[LSSecurityCodeView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, HeightOfiPhoneX(480.f))];
        securityCodeView.delegate=self;
        [self.tabBarController.view addSubview:securityCodeView];
        [securityCodeView release];
    }
    else if (alertView.tag==1)
    {
        //纯优惠券支付完成
        [_countDownView stopCountDown];
        [self makePaidOrdersViewController:LSPayTypeBalance];
    }
}

#pragma mark- LSCouponViewController的委托方法
- (void)LSCouponViewControllerDidChangeCoupon
{
    [self.navigationController popToViewController:self animated:YES];
    
    if(_order.userBalance>=[_order.totalPrice floatValue])
    {
        _order.needPay=0.f;
    }
    else
    {
        _order.needPay=[_order.totalPrice floatValue]-_order.userBalance;//需支付
    }
    [self.tableView reloadData];
}

#pragma mark- LSPaidOrdersViewController的委托方法
- (void)LSPaidOrdersViewControllerDidBack
{
    [_delegate LSPayViewControllerDidPay];
}

#pragma mark- LSSecurityCodeView的委托方法
- (void)LSSecurityCodeView:(LSSecurityCodeView *)securityCodeView didPayWithSecurityCode:(NSString *)securityCode
{
    [hud show:YES];
    [messageCenter LSMCPayBalancePayWithOrderID:_order.orderID isUseCoupon:_order.isUseCoupon securityCode:securityCode];
}


#pragma mark- Wap的回调方法
-(void)aliPaymentResult:(NSString *)resultd
{
#if TARGET_OS_IPHONE
    //结果处理
    #if __has_feature(objc_arc)
    AlixPayResult* result = [[AlixPayResult alloc] initWithString:resultd];
    #else
    AlixPayResult* result = [[[AlixPayResult alloc] initWithString:resultd] autorelease];
    #endif
	if (result)
    {
		if (result.statusCode == 9000)
        {
			/*
			 *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
			 */
            
            //交易成功
            //            NSString* key = @"签约帐户后获取到的支付宝公钥";
            //			id<DataVerifier> verifier;
            //            verifier = CreateRSADataVerifier(key);
            //
            //			if ([verifier verifyString:result.resultString withSign:result.signString])
            //            {
            //                //验证签名成功，交易结果无篡改
            //			}
            LSLOG(@"支付宝支付成功从WAP跳回来");
            [_countDownView stopCountDown];
            [self makePaidOrdersViewController:LSPayTypeAlipay];
        }
        else
        {
            //交易失败
            LSLOG(@"支付宝WAP支付失败");
            [LSAlertView showWithView:self.view message:@"支付失败" time:2.f];
        }
    }
    else
    {
        LSLOG(@"支付宝WAP支付失败");
        [LSAlertView showWithView:self.view message:@"支付失败" time:2.f];
    }
#endif
}

#pragma mark- UPOMP的回调方法
-(void)viewClose:(NSData*)data//获得返回数据并释放内存
{
//	[self readXML:data]; //对回传数据进行解析(自行实现)
//	if(respCode==0)
//  {
//		[tableView reloadData];
//	}
}

@end
