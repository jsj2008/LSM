//
//  LSLoginViewController.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-8-29.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSLoginViewController.h"

@interface LSLoginViewController ()

@end

@implementation LSLoginViewController

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
    self.title=@"登录";
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.leftBarButtonSystemItem=UIBarButtonSystemItemStop;
    [self setBarButtonItemWithTitle:@"注册" isRight:YES];
    
    LSUnionLoginView* unionLoginView=[[LSUnionLoginView alloc] initWithFrame:CGRectMake(0.f, self.view.height-95.f, self.view.width, 95.f)];
    unionLoginView.delegate=self;
    [self.view addSubview:unionLoginView];
    [unionLoginView release];
    
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
    [_nameCell.textField resignFirstResponder];
    [_passwordCell.textField resignFirstResponder];
}

#pragma mark- 重载方法
- (void)leftBarButtonItemClick:(UIBarButtonItem*)sender
{
    [self sureLoginByLoginType:user.loginType];
}
- (void)rightBarButtonItemClick:(UIBarButtonItem *)sender
{
    LSRegisterViewController* registerViewController=[[LSRegisterViewController alloc] init];
    registerViewController.delegate=self;
    [self.navigationController pushViewController:registerViewController animated:YES];
    [registerViewController release];
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
            if([notification.name isEqualToString:lsRequestTypeLoginNormalLoginByUserName_Password])
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

        if([notification.name isEqual:lsRequestTypeLoginNormalLoginByUserName_Password])
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
            user.password=[_nameCell.textField.text MD5];
            user.loginType=LSLoginTypeNormal;
            
            [self sureLoginByLoginType:LSLoginTypeNormal];
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
    return 44.f+20.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    LSLoginFooterView* loginFooterView=[[[LSLoginFooterView alloc] initWithFrame:CGRectZero] autorelease];
    loginFooterView.delegate=self;
    return loginFooterView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        _nameCell=[tableView dequeueReusableCellWithIdentifier:@"LSLoginCellName"];
        if(_nameCell==nil)
        {
            _nameCell=[[[LSLoginCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSLoginCellName"] autorelease];
            _nameCell.imageName=@"";
            _nameCell.placeholder=@"用户名";
        }
        return _nameCell;
    }
    else
    {
        _passwordCell=[tableView dequeueReusableCellWithIdentifier:@"LSLoginCellPassword"];
        if(_passwordCell==nil)
        {
            _passwordCell=[[[LSLoginCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSLoginCellPassword"] autorelease];
            _passwordCell.imageName=@"";
            _passwordCell.placeholder=@"密码";
        }
        return _passwordCell;
    }
}

#pragma mark- LSLoginFooterView委托方法
- (void)LSLoginFooterView:(LSLoginFooterView *)loginFooterView didClickLoginButton:(UIButton *)loginButton
{
    if (_nameCell.textField.text!=nil && _passwordCell.textField.text!=nil)
    {
        [messageCenter LSMCLoginWithUserName:_nameCell.textField.text password:[_passwordCell.textField.text MD5]];
        [hud show:YES];
    }
    else
    {
        [LSAlertView showWithView:self.view message:@"用户名和密码不可为空" time:2];
    }
}

#pragma mark- LSUnionLoginView委托方法
- (void)LSUnionLoginView:(LSUnionLoginView *)unionLoginView didClickUnionLoginButton:(UIButton *)unionLoginButton
{
    if (unionLoginButton.tag == LSLoginTypeSinaWB)
    {
        LSSinaWBAuthViewController* sinaWBAuthViewController = [[LSSinaWBAuthViewController alloc] init];
        sinaWBAuthViewController.delegate=self;
        [self.navigationController pushViewController:sinaWBAuthViewController animated:YES];
        [sinaWBAuthViewController release];
    }
    else if (unionLoginButton.tag == LSLoginTypeQQWB)
    {
        LSQQWBAuthViewController* QQWBAuthViewController = [[LSQQWBAuthViewController alloc] init];
        QQWBAuthViewController.delegate=self;
        [self.navigationController pushViewController:QQWBAuthViewController animated:YES];
        [QQWBAuthViewController release];
    }
    else if (unionLoginButton.tag == LSLoginTypeQQ)
    {
        LSQQAuthViewController* QQAuthViewController = [[LSQQAuthViewController alloc] init];
        QQAuthViewController.delegate=self;
        [self.navigationController pushViewController:QQAuthViewController animated:YES];
        [QQAuthViewController release];
    }
}


#pragma mark LSRegisterViewController的委托方法
- (void)LSRegisterViewControllerDidRegister
{
    [self.navigationController popToViewController:self animated:NO];
    [self sureLoginByLoginType:LSLoginTypeNormal];
}

#pragma mark LSSinaWBAuthViewController的委托方法
- (void)LSSinaWBAuthViewControllerDidLogin
{
    [self.navigationController popToViewController:self animated:NO];
    [self sureLoginByLoginType:LSLoginTypeSinaWB];
}

#pragma mark LSQQWBAuthViewController的委托方法
- (void)LSQQWBAuthViewControllerDidLogin
{
    [self.navigationController popToViewController:self animated:NO];
    [self sureLoginByLoginType:LSLoginTypeQQWB];
}

#pragma mark LSQQAuthViewController的委托方法
-(void)LSQQAuthViewControllerDidLogin
{
    [self.navigationController popToViewController:self animated:NO];
    [self sureLoginByLoginType:LSLoginTypeQQ];
}

#pragma mark- 授权、注册、登陆以后的回调方法
- (void)sureLoginByLoginType:(LSLoginType)loginType
{
    if([LSSave saveUser])
    {
        LSLOG(@"已经保存了User信息");
    }
    
    [_delegate LSLoginViewControllerDidLoginByType:loginType];
}

@end
