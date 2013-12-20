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
#import "AlixPayResult.h"

#if TARGET_IPHONE_SIMULATOR

#elif TARGET_OS_IPHONE
//在真机上才允许使用支付宝SDK(此SDK不支持i386模拟器架构)
#import "AlixLibService.h"
#endif

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
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeOrderAlipayInfoByOrderID object:nil];
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypePayBalancePayByOrderID_SecurityCode object:nil];
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:LSNotificationAlipaySuccess object:nil];
    
    _payFooterView=[[LSPayFooterView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 135.f)];
    _payFooterView.order=_order;
    _payFooterView.delegate=self;
    self.tableView.tableFooterView=_payFooterView;
    [_payFooterView release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- 重载方法
- (void)backButtonClick:(UIButton *)sender
{
    [_payFooterView stopCountDown];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- 私有方法
- (void)makePaidOrdersViewController:(LSPayType)payType
{
    LSPaidOrdersViewController* paidOrdersViewController=[[LSPaidOrdersViewController alloc] init];
    if(user.isCreateCard && payType==LSPayTypeAlipay)
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
            if([notification.name isEqualToString:lsRequestTypePayBalancePayByOrderID_SecurityCode])
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
            else if([notification.name isEqualToString:lsRequestTypeOrderAlipayInfoByOrderID] || [notification.name isEqualToString:LSNotificationAlipaySuccess])
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
        
        if([notification.name isEqualToString:lsRequestTypePayBalancePayByOrderID_SecurityCode])
        {
            [_payFooterView stopCountDown];
            [self makePaidOrdersViewController:LSPayTypeBalance];
        }
        else if([notification.name isEqualToString:lsRequestTypeOrderAlipayInfoByOrderID])
        {
#if TARGET_IPHONE_SIMULATOR
            
#elif TARGET_OS_IPHONE
            [AlixLibService payOrder:notification.object AndScheme:lsURLScheme seletor:@selector(aliPaymentResult:) target:self];
#endif
        }
        else if([notification.name isEqualToString:LSNotificationAlipaySuccess])
        {
            [_payFooterView stopCountDown];
            if(user.isCreateCard)
            {
                [messageCenter LSMCAlipayCreateCardWithOrderID:_order.orderID];
            }
            [self makePaidOrdersViewController:LSPayTypeAlipay];
        }
        else if([notification.name isEqualToString:LSNotificationOrderTimeChanged])
        {
            [hud show:NO];
            [_payFooterView resetCountDown];
            [hud performSelector:@selector(hide:) withObject:nil afterDelay:1];
        }
    }
}

#pragma mark - UITableView委托方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        return [LSPayFilmCell heightForOrder:_order];
    }
    else if(indexPath.row==1)
    {
        return _isSpread?[LSPaySeatCell heightForOrder:_order]:0.f;
    }
    else if(indexPath.row==2)
    {
        return 54.f;
    }
    else if(indexPath.row==3)
    {
        return 44.f;
    }
    else if(indexPath.row==4)
    {
        return 44.f;
    }
    else
    {
        return 44.f;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        LSPayFilmCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSPayFilmCell"];
        if(cell==nil)
        {
            cell=[[[LSPayFilmCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSPayFilmCell"] autorelease];
            cell.order=_order;
            cell.delegate=self;
        }
        return cell;
    }
    else if(indexPath.row==1)
    {
        LSPaySeatCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSPaySeatCell"];
        if(cell==nil)
        {
            cell=[[[LSPaySeatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSPaySeatCell"] autorelease];
            cell.order=_order;
            cell.delegate=self;
        }
        return cell;
    }
    else if(indexPath.row==2)
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

#pragma mark- LSPayFilmCell的委托
- (void)LSPayFilmCellDidSpread
{
    _isSpread=YES;
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
}

#pragma mark- LSPaySeatCell的委托
- (void)LSPaySeatCellDidFold
{
    _isSpread=NO;
    LSPayFilmCell* cell=(LSPayFilmCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell showSpreadButton];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
}

#pragma mark- LSPayCouponCell的委托
- (void)LSPayCouponCellDidSelect
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
        [messageCenter LSMCOrderAlipayInfoWithOrderID:_order.orderID isUseCoupon:_order.isUseCoupon];
    }
}
- (void)LSPayFooterViewDidTimeOut
{
    if([_delegate respondsToSelector:@selector(LSPayViewControllerDidPay)])
    {
        [_delegate LSPayViewControllerDidPay];
    }
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
        [_payFooterView stopCountDown];
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
    [_payFooterView setNeedsLayout];
}

#pragma mark- LSPaidOrdersViewController的委托方法
- (void)LSPaidOrdersViewControllerDidBack
{
    if([_delegate respondsToSelector:@selector(LSPayViewControllerDidPay)])
    {
        [_delegate LSPayViewControllerDidPay];
    }
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
            [_payFooterView stopCountDown];
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
