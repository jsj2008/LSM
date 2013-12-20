//
//  LSShareSettingViewController.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-8.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSShareSettingViewController.h"
#import "LSShareSettingCell.h"

@interface LSShareSettingViewController ()

@end

@implementation LSShareSettingViewController

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
    self.view.backgroundColor = LSColorBgWhiteColor;
    self.title=@"分享设置";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        return 44.f+10.f;
    }
    return 44.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        LSShareSettingCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSShareSettingCellSinaWB"];
        if(cell==nil)
        {
            cell=[[[LSShareSettingCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"LSShareSettingCellSinaWB"] autorelease];
            cell.imageView.image=[UIImage lsImageNamed:@"s_sina.png"];
            cell.textLabel.text=@"新浪微博";
            cell.topMargin=10.f;
            cell.topRadius=3.f;
        }

        if([LSShare sinaWBShareAuthStatus])
        {
            cell.statusLabel.text=[LSSave obtainForKey:LSSinaWBUserName];
            _isSinaWBAuth=YES;
        }
        else
        {
            cell.statusLabel.text=@"未授权";
        }
        [cell setNeedsDisplay];
        return cell;
    }
    else if(indexPath.row==1)
    {
        LSShareSettingCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSShareSettingCellQQWB"];
        if(cell==nil)
        {
            cell=[[[LSShareSettingCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"LSShareSettingCellQQWB"] autorelease];
            cell.imageView.image=[UIImage lsImageNamed:@"s_qq.png"];
            cell.textLabel.text=@"腾讯微博";
            cell.bottomRadius=3.f;
            cell.isBottomLine=YES;
        }
        
        if([LSShare qqWBShareAuthStatus])
        {
            cell.statusLabel.text=[LSSave obtainForKey:LSQQWBUserName];
            _isQQWBAuth=YES;
        }
        else
        {
            cell.statusLabel.text=@"未授权";
        }
        [cell setNeedsDisplay];
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        if(_isSinaWBAuth)
        {
            [LSAlertView showWithTag:0 title:nil message:@"确定要取消新浪微博的授权?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        }
        else
        {
            LSSinaWBAuthViewController* sinaWBAuthViewController = [[LSSinaWBAuthViewController alloc] init];
            sinaWBAuthViewController.delegate=self;
            [self.navigationController pushViewController:sinaWBAuthViewController animated:YES];
            [sinaWBAuthViewController release];
        }
    }
    else if(indexPath.row==1)
    {
        if(_isQQWBAuth)
        {
            [LSAlertView showWithTag:1 title:nil message:@"确定要取消腾讯微博的授权?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        }
        else
        {
            LSQQWBAuthViewController* QQWBAuthViewController = [[LSQQWBAuthViewController alloc] init];
            QQWBAuthViewController.delegate=self;
            [self.navigationController pushViewController:QQWBAuthViewController animated:YES];
            [QQWBAuthViewController release];
        }
    }
}

#pragma mark- LSSinaWBAuthViewController的委托方法
- (void)LSSinaWBAuthViewControllerDidLogin
{
    _isSinaWBAuth=YES;
    [self.tableView reloadData];
    [self.navigationController popToViewController:self animated:YES];
}
#pragma mark- LSQQWBAuthViewController的委托方法
- (void)LSQQWBAuthViewControllerDidLogin
{
    _isQQWBAuth=YES;
    [self.tableView reloadData];
    [self.navigationController popToViewController:self animated:YES];
}

#pragma mark- UIAlertView的委托方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==0)
    {
        if(buttonIndex==0)
        {
            _isSinaWBAuth=NO;
            [LSShare logoutSinaWB];
            [self.tableView reloadData];
        }
    }
    else
    {
        if(buttonIndex==0)
        {
            _isQQWBAuth=NO;
            [LSShare logoutQQWB];
            [self.tableView reloadData];
        }
    }
}

@end
