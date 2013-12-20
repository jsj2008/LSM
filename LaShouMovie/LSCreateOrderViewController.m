//
//  LSCreateOrderViewController.m
//  LaShouMovie
//
//  Created by Li XiangYu on 13-9-23.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSCreateOrderViewController.h"
#import "LSOrderView.h"
#import "LSSeat.h"

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
    self.view.backgroundColor = LSColorBgWhiteColor;
    
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeOrderCreateOrderByScheduleID_SectionID_Seats_Mobile_OnSale object:nil];
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeUserProfile object:nil];
    
    LSOrderView* orderView=[[LSOrderView alloc] initWithFrame:CGRectMake((self.view.width-265)/2, 10, 265, 0)];
    orderView.order=_order;
    [self.view  addSubview:orderView];
    [orderView release];
    
    if(orderView.contentY>0)
    {
        orderView.frame=CGRectMake((self.view.width-265)/2, 10, 265, orderView.contentY);
    }
    
    _mobileTextField=[[UITextField alloc] initWithFrame:CGRectMake((self.view.width-265)/2, 10+orderView.contentY+5, 265, 44)];
    _mobileTextField.font=LSFont17;
    if(user.mobile!=nil)
    {
        if(user.mobile.length>7)
        {
            NSMutableString* placeholder=[NSMutableString stringWithString:user.mobile];
            [placeholder replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            _mobileTextField.placeholder=placeholder;
        }
        else
        {
            _mobileTextField.placeholder=@" 请输入接收取票码的手机号";
        }
    }
    else
    {
        _mobileTextField.placeholder=@" 请输入接收取票码的手机号";
    }
    _mobileTextField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    _mobileTextField.borderStyle=UITextBorderStyleBezel;
    _mobileTextField.keyboardType=UIKeyboardTypeNumberPad;
    _mobileTextField.delegate=self;
    [self.view addSubview:_mobileTextField];
    [_mobileTextField release];
    
    _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitButton.frame = CGRectMake((self.view.width-265)/2, 10+orderView.contentY+5+44+10, 265, 44);
    [_submitButton setBackgroundImage:[UIImage stretchableImageWithImage:[UIImage lsImageNamed:@"corder_confirm.png"] top:23 left:4 bottom:23 right:4] forState:UIControlStateNormal];
    [_submitButton setBackgroundImage:[UIImage stretchableImageWithImage:[UIImage lsImageNamed:@"corder_confirm_d.png"] top:23 left:4 bottom:23 right:4] forState:UIControlStateHighlighted];
    _submitButton.titleLabel.font = LSFontBold18;
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitButton setTitle:@"提交订单" forState:UIControlStateNormal];
    [_submitButton addTarget:self action:@selector(submitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_submitButton];
    
    UITapGestureRecognizer* tapGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfTap:)];
    tapGestureRecognizer.delegate=self;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    [tapGestureRecognizer release];
    
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

- (void)backButtonClick:(UIButton *)sender
{
    if([_delegate respondsToSelector:@selector(LSCreateOrderViewControllerDidCreateOrder)])
    {
        [_delegate LSCreateOrderViewControllerDidCreateOrder];
    }
}

#pragma mark- 私有方法
- (void)submitButtonClick:(UIButton*)sender
{
    [_mobileTextField resignFirstResponder];
    
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

- (void)selfTap:(UITapGestureRecognizer*)recognizer
{
    [_mobileTextField resignFirstResponder];
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

#pragma mark- UITextField的委托方法
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        
        self.view.frame=CGRectMake(self.view.left, self.view.top-(216-(self.view.height-_submitButton.bottom))-10, self.view.width, self.view.height);
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    user.otherMobile=textField.text;
    /*
    if(user.otherMobile.length>3)
    {
        NSMutableString* placeholder=[NSMutableString stringWithString:user.otherMobile];
        NSString* s=nil;
        if(user.otherMobile.length==4)
        {
            s=@"*";
        }
        else if(user.otherMobile.length==5)
        {
            s=@"**";
        }
        else if(user.otherMobile.length==6)
        {
            s=@"***";
        }
        else
        {
            s=@"****";
        }
        [placeholder replaceCharactersInRange:NSMakeRange(3, user.otherMobile.length-3) withString:s];
    }
     */
    [UIView animateWithDuration:0.3 animations:^{
        
        self.view.frame=CGRectMake(self.view.left, LSiOS7?44.f+20.f:0.f, self.view.width, self.view.height);
    }];
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
