//
//  LSCouponViewController.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-11-28.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSUseCouponViewController.h"
#import "LSCoupon.h"
#import "LSUseCouponTableFooterView.h"

@interface LSUseCouponViewController ()

@end

@implementation LSUseCouponViewController

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
    LSUseCouponTableFooterView* useCouponTableFooterView=[[LSUseCouponTableFooterView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.width, 160.f)];
    self.tableView.tableFooterView=useCouponTableFooterView;
    [useCouponTableFooterView release];
    
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
        
        [_delegate LSUseCouponViewControllerDidChangeCoupon];
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
    [_useCouponHeaderView resignFirstResponder];
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
    if(_useCouponHeaderView==nil)
    {
        _useCouponHeaderView=[[[LSUseCouponHeaderView alloc] initWithFrame:CGRectZero] autorelease];
        _useCouponHeaderView.delegate=self;
    }
    return _useCouponHeaderView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return _isHideButton?0.f:84.f;
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(_useCouponFooterView==nil)
    {
        _useCouponFooterView=[[[LSUseCouponFooterView alloc] initWithFrame:CGRectZero] autorelease];
        _useCouponFooterView.delegate=self;
    }
    return _useCouponFooterView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _couponMArray.count+1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row)
    {
        return 50.f;
    }
    else
    {
        return 44.f;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSCoupon* coupon=[_couponMArray objectAtIndex:indexPath.row];
    if(coupon.couponType==LSCouponTypeCommon)
    {
        LSUseCouponCommonCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSUseCouponCommonCell"];
        if(cell==nil)
        {
            cell=[[[LSUseCouponCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSUseCouponCommonCell"] autorelease];
            cell.delegate=self;
        }
        cell.coupon=coupon;
        if(!indexPath.row)
        {
            cell.topMargin=6.f;
        }
        else
        {
            cell.topMargin=0.f;
        }
        [cell setNeedsLayout];
        [cell setNeedsDisplay];
        return cell;
    }
    else if(coupon.couponType==LSCouponTypeMoney)
    {
        LSUseCouponMoneyCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSUseCouponMoneyCell"];
        if(cell==nil)
        {
            cell=[[[LSUseCouponMoneyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSUseCouponMoneyCell"] autorelease];
            cell.delegate=self;
        }
        cell.coupon=coupon;
        if(!indexPath.row)
        {
            cell.topMargin=6.f;
        }
        else
        {
            cell.topMargin=0.f;
        }
        [cell setNeedsLayout];
        [cell setNeedsDisplay];
        return cell;
    }
    else
    {
        return nil;
    }
}

#pragma maek- LSUseCouponCommonCell的委托方法
- (void)LSUseCouponCommonCell:(LSUseCouponCommonCell *)useCouponCommonCell didClickDeleteButton:(UIButton *)deleteButton
{
    [hud show:YES];
    [messageCenter LSMCCouponCancelWithOrderID:_order.orderID cinemaID:_order.cinema.cinemaID couponID:useCouponCommonCell.coupon.couponID];
}

#pragma maek- LSUseCouponMoneyCell的委托方法
- (void)LSUseCouponMoneyCell:(LSUseCouponMoneyCell *)useCouponMoneyCell didClickDeleteButton:(UIButton *)deleteButton
{
    [hud show:YES];
    [messageCenter LSMCCouponCancelWithOrderID:_order.orderID cinemaID:_order.cinema.cinemaID couponID:useCouponMoneyCell.coupon.couponID];
}

#pragma mark- LSUseCouponHeaderView的委托方法
- (void)LSUseCouponHeaderView:(LSUseCouponHeaderView *)useCouponHeaderView didClickAddButton:(UIButton *)addButton withCouponTextField:(UITextField *)couponTextField
{
    [hud show:YES];
    [messageCenter LSMCCouponUseWithOrderID:_order.orderID cinemaID:_order.cinema.cinemaID couponID:couponTextField.text];
}

#pragma mark- LSUseCouponFooterView的委托方法
- (void)LSUseCouponFooterView:(LSUseCouponFooterView *)useCouponFooterView didClickUseButton:(UIButton *)useButton
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
        [_delegate LSUseCouponViewControllerDidChangeCoupon];
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
    
    [_delegate LSUseCouponViewControllerDidChangeCoupon];
}

@end
