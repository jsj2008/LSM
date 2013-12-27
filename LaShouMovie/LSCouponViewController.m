//
//  LSCouponViewController.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-11-28.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSCouponViewController.h"
#import "LSCoupon.h"
#import "LSCouponTableFooterView.h"

@interface LSCouponViewController ()

@end

@implementation LSCouponViewController

@synthesize order=_order;
@synthesize delegate=_delegate;

#pragma mark- 生命周期
- (void)dealloc
{
    self.order=nil;
    LSRELEASE(_couponMArray)
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
    self.title=@"使用优惠券";
    _couponMArray=[[NSMutableArray alloc] initWithCapacity:0];
    if(_order.couponArray.count>0)
    {
        for(LSCoupon* coupon in _order.couponArray)
        {
            [_couponMArray addObject:coupon];
        }
        [self.tableView reloadData];
    }
    _order.couponArray=_couponMArray;
    
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeCouponUseByOrderID_CinemaID_CouponID object:nil];
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeCouponCancelByOrderID_CinemaID_CouponID object:nil];
    [messageCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [messageCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //生成底部说明
    LSCouponTableFooterView* couponTableFooterView=[[LSCouponTableFooterView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.width, 160.f)];
    self.tableView.tableFooterView=couponTableFooterView;
    [couponTableFooterView release];
    
    UITapGestureRecognizer* tapGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfTap:)];
    tapGestureRecognizer.delegate=self;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    [tapGestureRecognizer release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- 重载方法
- (void)leftBarButtonItemClick:(UIBarButtonItem *)sender
{
    for(int i=0;i<_couponMArray.count;i++)
    {
        LSCoupon* coupon=[_couponMArray objectAtIndex:i];
        if(coupon.couponValid==LSCouponValidInvalid || coupon.couponStatus==LSCouponStatusUnuse)
        {
            [_couponMArray removeObject:coupon];
            i-=1;
        }
    }
    
    if(_couponMArray.count>0)
    {
        //有优惠券却直接退出，此时需要提示用户是否使用优惠券
        [LSAlertView showWithTag:0 title:nil message:@"是否使用当前优惠券？" delegate:self cancelButtonTitle:@"放弃" otherButtonTitles:@"使用", nil];
    }
    else
    {
        //没有优惠券直接退出或者删除全部优惠券退出
        _order.totalPrice=_order.originTotalPrice;
        _order.isUseCoupon=LSOrderUseCouponNo;
        _order.couponArray=nil;
        
        if([_delegate respondsToSelector:@selector(LSCouponViewControllerDidChangeCoupon)])
        {
            [_delegate LSCouponViewControllerDidChangeCoupon];
        }
    }
}

- (void)keyboardWillShow:(NSNotification*)notification
{
    _isHideButton=YES;
    [self.tableView reloadData];
}
- (void)keyboardWillHide:(NSNotification*)notification
{
    _isHideButton=NO;
    [self.tableView reloadData];
}

- (void)selfTap:(UITapGestureRecognizer*)recognizer
{
    [_couponHeaderView resignFirstResponder];
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
            if([notification.name isEqualToString:lsRequestTypeCouponUseByOrderID_CinemaID_CouponID])
            {
                [LSAlertView showWithTag:-1 title:nil message:@"优惠券密码无效" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            }
            else if ([notification.name isEqualToString:lsRequestTypeCouponCancelByOrderID_CinemaID_CouponID])
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
        
        if([notification.name isEqualToString:lsRequestTypeCouponUseByOrderID_CinemaID_CouponID] || [notification.name isEqualToString:lsRequestTypeCouponCancelByOrderID_CinemaID_CouponID])
        {
            //数据格式
//            {
//                total = 40;//服务器计算的，新的需付金额
//                voucher = {};
//            }
            
            dispatch_queue_t queue_0=dispatch_queue_create("queue_0", NULL);
            dispatch_async(queue_0, ^{
                
                _order.totalPrice=[notification.object objectForKey:@"total"];
                [_couponMArray removeAllObjects];
                
                NSArray* tmpArray=[notification.object objectForKey:@"voucher"];
                for(NSDictionary* dic in tmpArray)
                {
                    LSCoupon* coupon=[[LSCoupon alloc] initWithDictionary:dic];
                    [_couponMArray addObject:coupon];
                    [coupon release];
                }
                
                dispatch_async(dispatch_get_main_queue(),^{
                    
                    [self.tableView reloadData];
                });
            });
            dispatch_release(queue_0);
        }
    }
}

#pragma mark - UITableView委托方法
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 84.f;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(_couponHeaderView==nil)
    {
        _couponHeaderView=[[[LSCouponHeaderView alloc] initWithFrame:CGRectZero] autorelease];
        _couponHeaderView.delegate=self;
    }
    return _couponHeaderView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return _isHideButton?0.f:84.f;
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(_couponFooterView==nil)
    {
        _couponFooterView=[[[LSCouponFooterView alloc] initWithFrame:CGRectZero] autorelease];
        _couponFooterView.delegate=self;
    }
    return _couponFooterView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _couponMArray.count+1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        return 64.f;
    }
    else
    {
        LSCoupon* coupon=[_couponMArray objectAtIndex:indexPath.row-1];
        if(coupon.couponType==LSCouponTypeMoney)
        {
            return [LSCouponMoneyCell heightForCoupon:coupon];
        }
        else if(coupon.couponType==LSCouponTypeCommon)
        {
            return [LSCouponCommonCell heightForCoupon:coupon];
        }
        else
        {
            return 0.f;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSCoupon* coupon=[_couponMArray objectAtIndex:indexPath.row];
    if(coupon.couponType==LSCouponTypeCommon)
    {
        LSCouponCommonCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSCouponCommonCell"];
        if(cell==nil)
        {
            cell=[[[LSCouponCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSCouponCommonCell"] autorelease];
            cell.delegate=self;
        }
        cell.coupon=coupon;
        [cell setNeedsLayout];
        [cell setNeedsDisplay];
        return cell;
    }
    else if(coupon.couponType==LSCouponTypeMoney)
    {
        LSCouponMoneyCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSCouponMoneyCell"];
        if(cell==nil)
        {
            cell=[[[LSCouponMoneyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSCouponMoneyCell"] autorelease];
            cell.delegate=self;
        }
        cell.coupon=coupon;
        [cell setNeedsLayout];
        [cell setNeedsDisplay];
        return cell;
    }
    else
    {
        return nil;
    }
}

#pragma maek- LSCouponCommonCell的委托方法
- (void)LSCouponCommonCellDidDeleteWithCoupon:(LSCoupon *)coupon
{
    [hud show:YES];
    [messageCenter LSMCCouponCancelWithOrderID:_order.orderID cinemaID:_order.cinema.cinemaID couponID:coupon.couponID];
}

#pragma maek- LSCouponMoneyCell的委托方法
- (void)LSCouponMoneyCellDidDeleteWithCoupon:(LSCoupon *)coupon
{
    [hud show:YES];
    [messageCenter LSMCCouponCancelWithOrderID:_order.orderID cinemaID:_order.cinema.cinemaID couponID:coupon.couponID];
}

#pragma mark- LSCouponHeaderView的委托方法
- (void)LSCouponHeaderView:(LSCouponHeaderView *)couponHeaderView didClickAddButton:(UIButton *)addButton withCouponTextField:(UITextField *)couponTextField
{
    [hud show:YES];
    [messageCenter LSMCCouponUseWithOrderID:_order.orderID cinemaID:_order.cinema.cinemaID couponID:couponTextField.text];
}

#pragma mark- LSCouponFooterView的委托方法
- (void)LSCouponFooterView:(LSCouponFooterView *)couponFooterView didClickUseButton:(UIButton *)useButton
{
    for(int i=0;i<_couponMArray.count;i++)
    {
        LSCoupon* coupon=[_couponMArray objectAtIndex:i];
        if(coupon.couponValid==LSCouponValidInvalid || coupon.couponStatus==LSCouponStatusUnuse)
        {
            [_couponMArray removeObject:coupon];
            i-=1;
        }
    }
    
    if(_couponMArray.count>0)
    {
        _order.isUseCoupon=LSOrderUseCouponYes;
        if([_delegate respondsToSelector:@selector(LSCouponViewControllerDidChangeCoupon)])
        {
            [_delegate LSCouponViewControllerDidChangeCoupon];
        }
    }
    else
    {
        [LSAlertView showWithTag:1 title:nil message:@"没有可用惠券" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
    }
}

#pragma mark- UIAlertView的委托方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==0)
    {
        if(buttonIndex==alertView.cancelButtonIndex)
        {
            //虽然锁定了卡券，但是没有使用
            _order.totalPrice=_order.originTotalPrice;
            _order.isUseCoupon=LSOrderUseCouponNo;
            _order.couponArray=nil;
        }
        else
        {
            _order.isUseCoupon=LSOrderUseCouponYes;
        }
    }
    else if(alertView.tag==1)
    {
        //没有可用卡券
        _order.totalPrice=_order.originTotalPrice;
        _order.isUseCoupon=LSOrderUseCouponNo;
        _order.couponArray=nil;
    }
    
    [_delegate LSCouponViewControllerDidChangeCoupon];
}

@end
