//
//  LSBindViewController.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-8-30.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSBindViewController.h"
#import "LSRegisterHeaderView.h"

@interface LSBindViewController ()

@end

@implementation LSBindViewController

@synthesize delegate=_delegate;

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
    if(user.mobile!=nil && ![user.mobile isEqualToString:LSNULL])
    {
        _isHasBind=YES;
    }
    
    if(_isHasBind)
    {
        self.title=@"更换";
    }
    else
    {
        self.title=@"验证";
    }
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.leftBarButtonSystemItem=UIBarButtonSystemItemStop;
    
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeMobileSecurityCodeByOldPhone_NewPhone object:nil];
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeMobileBindByOldPhone_NewPhone_SecurityCode object:nil];
    [messageCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [messageCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    LSRegisterHeaderView* registerHeaderView=[[LSRegisterHeaderView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.width, 44.f)];
    self.tableView.tableHeaderView=registerHeaderView;
    [registerHeaderView release];
    
    UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfTap:)];
    tapGestureRecognizer.delegate=self;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    [tapGestureRecognizer release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- 私有方法
- (void)selfTap:(UITapGestureRecognizer *)recognizer
{
    [_bindOriginPhoneCell.textField resignFirstResponder];
    [_bindPhoneCell.textField resignFirstResponder];
    [_bindVerifyCell.textField resignFirstResponder];
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
            if([notification.name isEqual:lsRequestTypeMobileSecurityCodeByOldPhone_NewPhone])
            {
                if (status.code == 1)
                {
                    [_bindVerifyCell.textField becomeFirstResponder];
                }
                //输入的旧手机和之前绑定过的手机号不一致
                else if (status.code == -3)
                {
                    [LSAlertView showWithTag:0 title:nil message:@"输入的原号码和绑定的手机号不一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    _bindPhoneCell.textField.text = nil;
                    [_bindPhoneCell.textField becomeFirstResponder];
                }
                //新手机号码格式有误
                else if (status.code == -4)
                {
                    [LSAlertView showWithTag:0 title:nil message:@"新号码格式不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    _bindPhoneCell.textField.text = nil;
                    [_bindPhoneCell.textField becomeFirstResponder];
                }
                //两次短信间隔不低于2分钟、验证码发送失败
                else if(status.code == -5)
                {
                    [LSAlertView showWithTag:0 title:nil message:@"验证码已发送，请稍后" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                }
                else
                {
                    [LSAlertView showWithTag:0 title:nil message:status.message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                }
            }
            else if([notification.name isEqual:lsRequestTypeMobileBindByOldPhone_NewPhone_SecurityCode])
            {
                if (status.code == 1)
                {
                    user.mobile=_bindPhoneCell.textField.text;
                    [_delegate LSBindViewControllerDidBindOrNot];
                }
                //输入的旧手机和之前绑定过的手机号不一致
                else if (status.code == -6)
                {
                    [LSAlertView showWithTag:0 title:nil message:@"输入的原号码和绑定的手机号不一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    _bindOriginPhoneCell.textField.text = nil;
                    [_bindOriginPhoneCell.textField becomeFirstResponder];
                }
                //新手机号码格式有误
                else if (status.code == -7)
                {
                    [LSAlertView showWithTag:0 title:nil message:@"新号码格式不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    _bindOriginPhoneCell.textField.text = nil;
                    [_bindOriginPhoneCell.textField becomeFirstResponder];
                }
                //验证码输入有误
                else if(status.code == -8)
                {
                    [LSAlertView showWithTag:0 title:nil message:@"验证码不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    
                    _bindVerifyCell.textField.text=nil;
                    [_bindVerifyCell.textField becomeFirstResponder];
                }
                //绑定失败
                else if(status.code == -9)
                {
                    [LSAlertView showWithTag:0 title:nil message:@"绑定失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                }
                else
                {
                    [LSAlertView showWithTag:0 title:nil message:status.message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                }
            }
            
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
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view=[[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section==1)
    {
        return 44.f+40.f;
    }
    else
    {
        return 0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(section==1)
    {
        LSBindFooterView* bindFooterView=[[[LSBindFooterView alloc] initWithFrame:CGRectZero] autorelease];
        bindFooterView.delegate=self;
        return bindFooterView;
    }
    else
    {
        return nil;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
    {
        return _isHasBind?2:1;
    }
    else
    {
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_isHasBind)
    {
        if(indexPath.row==0)
        {
            _bindOriginPhoneCell=[tableView dequeueReusableCellWithIdentifier:@"LSBindOriginPhoneCell"];
            if(_bindOriginPhoneCell==nil)
            {
                _bindOriginPhoneCell=[[[LSBindCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSBindOriginPhoneCell"] autorelease];
                _bindOriginPhoneCell.imageName=@"";
                _bindOriginPhoneCell.placeholder=user.mobile;
            }
            return _bindOriginPhoneCell;
        }
        else if(indexPath.row==1)
        {
            _bindPhoneCell=[tableView dequeueReusableCellWithIdentifier:@"LSRegisterCellEmail"];
            if(_bindPhoneCell==nil)
            {
                _bindPhoneCell=[[[LSBindPhoneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSBindPhoneCell"] autorelease];
                _bindPhoneCell.imageName=@"";
                _bindPhoneCell.placeholder=@"新手机号";
                _bindPhoneCell.delegate=self;
            }
            return _bindPhoneCell;
        }
        else
        {
            _bindVerifyCell=[tableView dequeueReusableCellWithIdentifier:@"LSBindVerifyCell"];
            if(_bindVerifyCell==nil)
            {
                _bindVerifyCell=[[[LSBindCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSBindVerifyCell"] autorelease];
                _bindVerifyCell.imageName=@"";
                _bindVerifyCell.placeholder=@"验证码";
            }
            return _bindVerifyCell;
        }
    }
    else
    {
        if(indexPath.row==0)
        {
            _bindPhoneCell=[tableView dequeueReusableCellWithIdentifier:@"LSRegisterCellEmail"];
            if(_bindPhoneCell==nil)
            {
                _bindPhoneCell=[[[LSBindPhoneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSBindPhoneCell"] autorelease];
                _bindPhoneCell.imageName=@"";
                _bindPhoneCell.placeholder=@"手机号";
                _bindPhoneCell.delegate=self;
            }
            return _bindPhoneCell;
        }
        else
        {
            _bindVerifyCell=[tableView dequeueReusableCellWithIdentifier:@"LSBindVerifyCell"];
            if(_bindVerifyCell==nil)
            {
                _bindVerifyCell=[[[LSBindCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSBindVerifyCell"] autorelease];
                _bindVerifyCell.imageName=@"";
                _bindVerifyCell.placeholder=@"验证码";
            }
            return _bindVerifyCell;
        }
    }
}

#pragma mark- LSBindPhoneCell的委托方法
- (void)LSBindPhoneCell:(LSBindPhoneCell *)cell didClickSendButton:(UIButton *)sendButton
{
    [hud show:YES];
    [messageCenter LSMCMobileSecurityCodeWithOldPhone:_isHasBind?(_bindOriginPhoneCell.textField.text!=nil?_bindOriginPhoneCell.textField.text:_bindOriginPhoneCell.textField.placeholder):nil newPhone:_bindPhoneCell.textField.text];
}

#pragma mark- LSBindFooterView的委托方法
- (void)LSBindFooterView:(LSBindFooterView *)bindFooterView didClickBindButton:(UIButton *)bindButton
{
    if(_bindPhoneCell.textField.text!=nil && _bindVerifyCell.textField.text!=nil)
    {
        [hud show:YES];
        [messageCenter LSMCMobileBindWithOldPhone:_isHasBind?(_bindOriginPhoneCell.textField.text!=nil?_bindOriginPhoneCell.textField.text:_bindOriginPhoneCell.textField.placeholder):nil newPhone:_bindPhoneCell.textField.text securityCode:_bindVerifyCell.textField.text];
    }
}

@end
