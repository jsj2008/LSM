//
//  LSRegisterViewController.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-8-29.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSRegisterViewController.h"
#import "LSRegisterHeaderView.h"

@interface LSRegisterViewController ()

@end

@implementation LSRegisterViewController

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
    self.title=@"注册";
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.leftBarButtonSystemItem=UIBarButtonSystemItemStop;
    
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeRegisterByUserName_Password_Email object:nil];
    [messageCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [messageCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    LSRegisterHeaderView* registerHeaderView=[[LSRegisterHeaderView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.width, 44.f)];
    self.tableView.tableHeaderView=registerHeaderView;
    [registerHeaderView release];

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

#pragma mark- 私有方法
- (void)selfTap:(UITapGestureRecognizer *)recognizer
{
    [_emailCell.textField resignFirstResponder];
    [_nameCell.textField resignFirstResponder];
    [_passwordCell.textField resignFirstResponder];
}

#pragma mark- 通知中心方法
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
            if([notification.name isEqualToString:lsRequestTypeRegisterByUserName_Password_Email])
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

        if([notification.name isEqual:lsRequestTypeRegisterByUserName_Password_Email])
        {
            //{
            //    profile = {
            //                 email = "2352214850@qq.com";
            //                 id = 1613127784;
            //                 name = qatest;
            //              };
            //}
            
            NSDictionary* dic=[notification.object objectForKey:@"profile"];
            [user completePropertyWithDictionary:dic];
            user.password=[_passwordCell.textField.text MD5];
            user.loginType=LSLoginTypeNormal;
            
            //弹出绑定手机号界面
            LSBindViewController* bindViewController=[[LSBindViewController alloc] init];
            bindViewController.delegate=self;
            [self.navigationController pushViewController:bindViewController animated:YES];
            [bindViewController release];
        }
    }
}

#pragma mark- UITableView的委托方法
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
    return 44.f+40.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    LSRegisterFooterView* registerFooterView=[[[LSRegisterFooterView alloc] initWithFrame:CGRectZero] autorelease];
    registerFooterView.delegate=self;
    return registerFooterView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        _emailCell=[tableView dequeueReusableCellWithIdentifier:@"LSRegisterCellEmail"];
        if(_emailCell==nil)
        {
            _emailCell=[[[LSRegisterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSRegisterCellEmail"] autorelease];
            _emailCell.imageName=@"";
            _emailCell.placeholder=@"用户名";
            _emailCell.keyboardType=UIKeyboardTypeEmailAddress;
        }
        return _emailCell;
    }
    else if(indexPath.row==1)
    {
        _nameCell=[tableView dequeueReusableCellWithIdentifier:@"LSRegisterCellName"];
        if(_nameCell==nil)
        {
            _nameCell=[[[LSRegisterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSRegisterCellName"] autorelease];
            _nameCell.imageName=@"";
            _nameCell.placeholder=@"用户名";
        }
        return _nameCell;
    }
    else
    {
        _passwordCell=[tableView dequeueReusableCellWithIdentifier:@"LSRegisterCellPassword"];
        if(_passwordCell==nil)
        {
            _passwordCell=[[[LSRegisterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSRegisterCellPassword"] autorelease];
            _passwordCell.imageName=@"";
            _passwordCell.placeholder=@"密码";
        }
        return _passwordCell;
    }
}

#pragma mark- LSRegisterFooterView的委托方法
- (void)LSRegisterFooterView:(LSRegisterFooterView *)registerFooterView didClickRegisterButton:(UIButton *)registerButton
{
    if (_emailCell.textField.text!=nil && _nameCell.textField.text!=nil && _passwordCell.textField.text!=nil)
    {
        [hud show:YES];
        [messageCenter LSMCRegisterWithUserName:_nameCell.textField.text password:[_passwordCell.textField.text MD5] email:_emailCell.textField.text];
    }
    else
    {
        [LSAlertView showWithView:self.view message:@"用户名、密码和邮箱不可为空" time:2];
    }
}

#pragma mark- LSBindViewController的委托方法
- (void)LSBindViewControllerDidBindOrNot
{
    [_delegate LSRegisterViewControllerDidRegister];
}

@end
