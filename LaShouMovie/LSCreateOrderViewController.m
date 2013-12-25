//
//  LSCreateOrderViewController.m
//  LaShouMovie
//
//  Created by Li XiangYu on 13-9-23.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSCreateOrderViewController.h"
#import "LSSeat.h"
#import "LSCreateOrderCell.h"

@interface LSCreateOrderViewController ()

@end

@implementation LSCreateOrderViewController

@synthesize order=_order;
@synthesize delegate=_delegate;

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
    self.title=@"提交订单";
    self.view.backgroundColor = LSColorBackgroundGray;
    
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeOrderCreateOrderByScheduleID_SectionID_Seats_Mobile_OnSale object:nil];
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeUserProfile object:nil];
    
    UITapGestureRecognizer* tapGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfTap:)];
    tapGestureRecognizer.delegate=self;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    [tapGestureRecognizer release];
    
    if(user.userID!=nil && user.password!=nil)
    {
        [hud show:YES];
        [messageCenter LSMCUserProfile];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- 重载方法
- (void)leftBarButtonItemClick:(UIBarButtonItem *)sender
{
    if([_delegate respondsToSelector:@selector(LSCreateOrderViewControllerDidCreateOrder)])
    {
        [_delegate LSCreateOrderViewControllerDidCreateOrder];
    }
}

#pragma mark- 私有方法
- (void)selfTap:(UITapGestureRecognizer*)recognizer
{
    [_createOrderFooterView resignFirstResponder];
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
            if([notification.name isEqualToString:lsRequestTypeUserProfile] || [notification.name isEqualToString:lsRequestTypeOrderCreateOrderByScheduleID_SectionID_Seats_Mobile_OnSale])
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
            
            if(user.mobile!=nil && user.mobile.length>=11)
            {
                NSMutableString* placeholder=[NSMutableString stringWithString:user.mobile];
                [placeholder replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
                _mobileTextField.placeholder=placeholder;
            }
        }
        else if([notification.name isEqual:lsRequestTypeOrderCreateOrderByScheduleID_SectionID_Seats_Mobile_OnSale])
        {
            //{
            //   trade = {
            //              "expire_time" = 1380190174;
            //              "service_time" = 1380189274;
            //              "total_fee" = "60.00";
            //              "trade_no" = C1339d8b9757e;
            //              "trade_time" = 1380189274;
            //              userBalance = "1092.00";
            //            };
            //}
            
            //完成补充剩余部分
            NSDictionary* dic=[notification.object objectForKey:@"trade"];
            [_order completePropertyWithDictionary:dic];

            LSPayViewController* payViewController=[[LSPayViewController alloc] init];
            payViewController.order=_order;
            payViewController.delegate=self;
            [self.navigationController pushViewController:payViewController animated:YES];
            [payViewController release];
        }
    }
}

#pragma mark- UITableView的委托方法
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 44.f*2+50.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    _createOrderFooterView=[[[LSCreateOrderFooterView alloc] initWithFrame:CGRectZero] autorelease];
    _createOrderFooterView.delegate=self;
    return _createOrderFooterView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSCreateOrderCell* createOrderCell=[tableView dequeueReusableCellWithIdentifier:@"LSCreateOrderCell"];
    if(createOrderCell==nil)
    {
        createOrderCell=[[[LSCreateOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSCreateOrderCell"] autorelease];
    }
    return createOrderCell;
}

#pragma mark- LSCreateOrderFooterView的委托方法
- (void)LSCreateOrderFooterView:(LSCreateOrderFooterView *)createOrderFooterView didClickSubmitButton:(UIButton *)submitButton
{
    NSMutableString* seatsMString = [[NSMutableString alloc] initWithCapacity:0];
    for (LSSeat* seat in _order.selectSeatArray)
    {
        [seatsMString appendFormat:@"%@:%@|", seat.realRowID, seat.realColumnID];
    }
    [seatsMString deleteCharactersInRange:NSMakeRange((seatsMString.length - 1), 1)];
    NSString* mobileString=nil;
    if(_mobileTextField.text.length==0)
    {
        if(user.mobile!=nil)
        {
            mobileString=user.mobile;
        }
        else
        {
            [LSAlertView showWithTag:0 title:nil message:@"请输入手机号，用于接收取票码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            return;
        }
    }
    else
    {
        mobileString=user.otherMobile;
    }
    
    [hud show:YES];
    [messageCenter LSMCOrderCreateWithScheduleID:_order.schedule.scheduleID sectionID:_order.section.sectionID seats:seatsMString mobile:mobileString isOnSale:_order.schedule.isOnSale];
}

#pragma mark- UIAlertView的委托方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==0)
    {
        [_mobileTextField becomeFirstResponder];
    }
}

#pragma mark- LSPayViewController的委托方法
- (void)LSPayViewControllerDidPay
{
    if([_delegate respondsToSelector:@selector(LSCreateOrderViewControllerDidCreateOrder)])
    {
        [_delegate LSCreateOrderViewControllerDidCreateOrder];
    }
}

@end
