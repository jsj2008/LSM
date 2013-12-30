//
//  LSCreateOrderViewController.m
//  LaShouMovie
//
//  Created by Li XiangYu on 13-9-23.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSCreateOrderViewController.h"
#import "LSSeat.h"
#import "LSCreateOrderView.h"

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
    [messageCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [messageCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    LSCreateOrderView* createOrderView=[[LSCreateOrderView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.width, 30.f)];
    createOrderView.order=_order;
    [self.view addSubview:createOrderView];
    [createOrderView release];
    
    [UIView animateWithDuration:1.f animations:^{
        
        createOrderView.frame=CGRectMake(0.f, 0.f, self.view.width, createOrderView.contentY);
    } completion:^(BOOL finished) {
        [createOrderView setNeedsDisplay];
        
        LSCreateOrderFooterView* createOrderFooterView=[[LSCreateOrderFooterView alloc] initWithFrame:CGRectMake(0.f, createOrderView.bottom, self.view.width, 128.f)];
        createOrderFooterView.delegate=self;
        [self.view addSubview:createOrderFooterView];
        [createOrderFooterView release];
    }];
    
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
    [_delegate LSCreateOrderViewControllerDidCreateOrder];
}

#pragma mark- 私有方法
- (void)selfTap:(UITapGestureRecognizer*)recognizer
{
    [_createOrderFooterView resignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification*)notification
{
    //得到键盘的高度
    CGFloat keyboardHeight=[[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    CGFloat gap=keyboardHeight-(self.view.height-_createOrderFooterView.bottom);
    [UIView animateWithDuration:0.3 animations:^{
        
        self.view.top=self.view.top-gap>0.f?gap:0.f;
    }];
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        
        self.view.top=LSiOS7?0.f:20.f+44.f;
    }];
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
                _createOrderFooterView.phoneTextField.placeholder=placeholder;
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

#pragma mark- LSCreateOrderFooterView的委托方法
- (void)LSCreateOrderFooterView:(LSCreateOrderFooterView *)createOrderFooterView didClickSubmitButton:(UIButton *)submitButton
{
    NSMutableString* seatsMString = [[NSMutableString alloc] initWithCapacity:0];
    
    for(NSArray* selectSeatArray in [_order.selectSeatArrayDic allValues])
    {
        for(LSSeat* seat in selectSeatArray)
        {
            [seatsMString appendFormat:@"%@:%@|", seat.realRowID, seat.realColumnID];
        }
    }
    [seatsMString deleteCharactersInRange:NSMakeRange((seatsMString.length - 1), 1)];
    NSString* mobileString=nil;
    if(_createOrderFooterView.phoneTextField.text.length==0)
    {
        if(user.mobile!=nil)
        {
            mobileString=user.mobile;
        }
        else
        {
            [LSAlertView showWithView:self.view message:@"请输入手机号，用于接收取票码" time:2.f completion:^(void) {
                
                [_createOrderFooterView.phoneTextField becomeFirstResponder];
            }];
            return;
        }
    }
    else
    {
        mobileString=user.otherMobile;
    }
    
    [hud show:YES];
    [messageCenter LSMCOrderCreateWithScheduleID:_order.schedule.scheduleID seats:seatsMString mobile:mobileString isOnSale:_order.schedule.isOnSale];
}

#pragma mark- LSPayViewController的委托方法
- (void)LSPayViewControllerDidPay
{
    [_delegate LSCreateOrderViewControllerDidCreateOrder];
}

@end
