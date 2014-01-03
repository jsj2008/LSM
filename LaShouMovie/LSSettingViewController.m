//
//  LSSettingViewController.m
//  LaShouMovie
//
//  Created by Li XiangYu on 13-10-4.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSSettingViewController.h"
#import "LSSettingTextCell.h"
#import "LSSettingCell.h"
#import "LSSeparatorCell.h"
#import "LSShareSettingViewController.h"
#import "LSFeedbackViewController.h"
#import "LSAboutViewController.h"

@interface LSSettingViewController ()

@end

@implementation LSSettingViewController

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
    self.title=@"设置";
    
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeUpdateInfo object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- 消息中心通知
- (void)lsHttpRequestNotification:(NSNotification*)notification
{
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
            if([notification.name isEqualToString:lsRequestTypeUpdateInfo])
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
        
        if([notification.name isEqualToString:lsRequestTypeUpdateInfo])
        {
            version=[LSVersion currentVersion];
            if ([version.version isEqualToString:lsSoftwareVersion])
            {
                [LSAlertView showWithView:self.view message:@"已经是最新版本" time:2.f];
            }
            else
            {
                [LSAlertView showWithTag:1 title:nil message:version.message delegate:self cancelButtonTitle:@"暂不升级" otherButtonTitles:@"马上升级", nil];
            }
        }
    }
}


#pragma mark- UITableView的委托方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 12;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0 || indexPath.row==4 || indexPath.row==6 || indexPath.row==11)
    {
        return 20.f;
    }
    else
    {
        return 44.f;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0 || indexPath.row==4 || indexPath.row==6 || indexPath.row==11)
    {
        LSSeparatorCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSSeparatorCell"];
        if(cell==nil)
        {
            cell=[[[LSSeparatorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSSeparatorCell"] autorelease];
            if(indexPath.row==11)
            {
                cell.noBottomLine=YES;
            }
        }
        return cell;
    }
    else if(indexPath.row==1)
    {
        LSSettingSwitchCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSSettingSwitchCellWifi"];
        if(cell==nil)
        {
            cell=[[[LSSettingSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSSettingSwitchCellWifi"] autorelease];
            cell.isTurnOn=user.isImageOnlyWhenWifi;
            cell.textLabel.text=@"仅Wifi下显示图片";
            cell.delegate=self;
            cell.standardBottomLine=YES;
        }
        return cell;
    }
    else if(indexPath.row==2)
    {
        LSSettingSwitchCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSSettingSwitchCellCard"];
        if(cell==nil)
        {
            cell=[[[LSSettingSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSSettingSwitchCellCard"] autorelease];
            cell.isTurnOn=user.isCreateCard;
            cell.textLabel.text=@"生成支付宝卡券";
            cell.delegate=self;
            cell.standardBottomLine=YES;
        }
        [cell setNeedsDisplay];
        return cell;
    }
    else if(indexPath.row==3)
    {
        LSSettingTextCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSSettingTextCellCache"];
        if(cell==nil)
        {
            cell=[[[LSSettingTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSSettingTextCellCache"] autorelease];
            cell.textLabel.text=@"清除图片缓存";
            cell.text=[[LSDataCache calculateImageCache] stringByReplacingOccurrencesOfString:@".00" withString:@""];
        }
        return cell;
    }
    else if(indexPath.row==5)
    {
        LSSettingCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSSettingCellShare"];
        if(cell==nil)
        {
            cell=[[[LSSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSSettingCellShare"] autorelease];
            cell.textLabel.text=@"分享设置";
        }
        [cell setNeedsDisplay];
        return cell;
    }
    else if(indexPath.row==7)
    {
        LSSettingCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSSettingCellUpdate"];
        if(cell==nil)
        {
            cell=[[[LSSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSSettingCellUpdate"] autorelease];
            cell.textLabel.text=@"软件升级";
            cell.standardBottomLine=YES;
        }
        [cell setNeedsDisplay];
        return cell;
    }
    else if(indexPath.row==8)
    {
        LSSettingCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSSettingCellFeedback"];
        if(cell==nil)
        {
            cell=[[[LSSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSSettingCellFeedback"] autorelease];
            cell.textLabel.text=@"意见反馈";
            cell.standardBottomLine=YES;
        }
        [cell setNeedsDisplay];
        return cell;
    }
    else if(indexPath.row==9)
    {
        LSSettingCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSSettingCellAbout"];
        if(cell==nil)
        {
            cell=[[[LSSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSSettingCellAbout"] autorelease];
            cell.textLabel.text=@"关于拉手电影";
            cell.standardBottomLine=YES;
        }
        return cell;
    }
    else
    {
        LSSettingTextCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSSettingTextCellPhone"];
        if(cell==nil)
        {
            cell=[[[LSSettingTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSSettingTextCellPhone"] autorelease];
            cell.textLabel.text=@"客服电话";
            cell.text=lsServicePhoneCall;
        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==1)
    {
    }
    else if(indexPath.row==2)
    {
        [LSSave saveObject:LSCardRemind forKey:LSCardRemind];
    }
    else if(indexPath.row==3)
    {
        [LSAlertView showWithTag:0 title:@"提示" message:@"清空全部图片缓存？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"清空", nil];
    }
    else if(indexPath.row==5)
    {
        LSShareSettingViewController* shareSettingViewController=[[LSShareSettingViewController alloc] init];
        shareSettingViewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:shareSettingViewController animated:YES];
        [shareSettingViewController release];
    }
    else if(indexPath.row==7)
    {
        [messageCenter LSMCUpdateInfo];
    }
    else if(indexPath.row==8)
    {
        LSFeedbackViewController* feedbackViewController=[[LSFeedbackViewController alloc] init];
        feedbackViewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:feedbackViewController animated:NO];
        [feedbackViewController release];
    }
    else if(indexPath.row==9)
    {
        LSAboutViewController* aboutViewController=[[LSAboutViewController alloc] init];
        aboutViewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:aboutViewController animated:YES];
        [aboutViewController release];
    }
    else if(indexPath.row==11)
    {
        UIActionSheet* actionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:[NSString stringWithFormat:@"呼叫 %@",lsServicePhoneCall] otherButtonTitles:nil];
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
        [actionSheet release];
    }
}

#pragma mark- LSSettingWifiCell的委托方法
- (void)LSSettingSwitchCell:(LSSettingSwitchCell *)settingSwitchCell didChangeValue:(BOOL)isTurnOn
{
    NSIndexPath* indexPath=[self.tableView indexPathForCell:settingSwitchCell];
    if(indexPath.row==0)
    {
        user.isImageOnlyWhenWifi=isTurnOn;
    }
    else
    {
        user.isCreateCard=isTurnOn;
    }
    
    if([LSSave saveUser])
    {
        LSLOG(@"已经重置用户选项状态并保存了User信息");
    }
}

#pragma mark- UIActionSheet的委托方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==actionSheet.destructiveButtonIndex)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", lsServicePhoneReal]]];
    }
}

#pragma mark- UIAlertView的委托方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==0)
    {
        if(buttonIndex!=alertView.cancelButtonIndex)
        {
            [LSDataCache clearImageCache];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    else if(alertView.tag==1)
    {
        if(buttonIndex!=alertView.cancelButtonIndex)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:version.downloadURL]];
        }
    }
}

@end
