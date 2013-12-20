//
//  LSFilmInfoViewController.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-5.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSFilmInfoViewController.h"

#import "LSComment.h"
#import "LSFilmInfoInfoCell.h"
#import "LSFilmInfoDescriptionCell.h"
#import "LSCinemasByFilmViewController.h"
#import "LSStillsViewController.h"
#import "LSShareViewController.h"

@interface LSFilmInfoViewController ()

@end

@implementation LSFilmInfoViewController

@synthesize film=_film;
@synthesize isHideFooter=_isHideFooter;

#pragma mark- 生命周期
- (void)dealloc
{
    self.film=nil;
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
    self.title=_film.filmName;
    [self setBarButtonItemWithImageName:@"nav_share.png" clickedImageName:@"nav_share_d.png" isRight:YES buttonType:LSOtherButtonTypeShare];
    
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeFilmInfoByFilmID object:nil];
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.width, self.view.height-(_isHideFooter?0.f:54.f))];
    _tableView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.backgroundView=nil;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    [_tableView release];
    
    LSSeatSectionFooter* seatSectionFooter=[[LSSeatSectionFooter alloc] initWithFrame:CGRectMake(0.f, self.view.height-44.f-(LSiOS7?20.f:0.f)-54.f, self.view.width, 54.f)];
    seatSectionFooter.delegate=self;
    [self.view addSubview:seatSectionFooter];
    [seatSectionFooter release];
    seatSectionFooter.hidden=_isHideFooter;
    
    if(!_film.isFetchDetail)
    {
        [messageCenter LSMCFilmInfoWithFilmID:_film.filmID];
        [hud show:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- 重载方法
- (void)otherButtonClick:(UIButton *)sender
{
    [super otherButtonClick:sender];
    if(sender.tag==LSOtherButtonTypeShare)
    {
        UIActionSheet* actionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享到新浪微博", @"分享到腾讯微博", nil];
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
        [actionSheet release];
    }
}

#pragma mark- 私有方法
- (void)makeShareViewController:(LSShareType)shareType
{
    LSShareViewController* shareViewController=[[LSShareViewController alloc] init];
    NSString* url=[NSString stringWithFormat:@"...http://www.lashou.com/movies/film/%@",_film.filmID];
    NSString* tmp=[NSString stringWithFormat:@"推荐电影#%@#,%@",_film.filmName,_film.description];
    NSString* message=nil;
    if(tmp.length+url.length>140)
    {
        message=[NSString stringWithFormat:@"%@%@",[tmp substringToIndex:tmp.length-(tmp.length+url.length-140)],url];
    }
    else
    {
        message=[NSString stringWithFormat:@"%@%@",tmp,url];
    }
    shareViewController.message=message;
    shareViewController.imgURL=_film.posterURL;
    shareViewController.shareType=shareType;
    [self.navigationController pushViewController:shareViewController animated:YES];
    [shareViewController release];
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
            if([notification.name isEqualToString:lsRequestTypeFilmInfoByFilmID])
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
        
        if([notification.name isEqualToString:lsRequestTypeFilmInfoByFilmID])
        {
            NSDictionary* filmPart=notification.object;
            [_film completePropertyWithDictionary:filmPart];
            
            _isShowFooter=YES;
            [_tableView reloadData];
        }
    }
}


#pragma mark - UITableView委托方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    if(_isHideFooter)
//    {
//        return 0.f;
//    }
//    if(_isShowFooter)
//    {
//        return 54.f;
//    }
//    else
//    {
//        return 0.f;
//    }
//}
//- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    if(_isHideFooter)
//    {
//        return nil;
//    }
//    if(_isShowFooter)
//    {
//        LSSeatSectionFooter* seatSectionFooter=[[[LSSeatSectionFooter alloc] initWithFrame:CGRectZero] autorelease];
//        seatSectionFooter.delegate=self;
//        return seatSectionFooter;
//    }
//    else
//    {
//        return nil;
//    }
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        return 120.f;
    }
    else if(indexPath.row == 1)
    {
        return [LSFilmInfoDescriptionCell heightForFilm:_film isSpread:_isDescriptionSpread];
    }
    else
    {
        return 130.f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        //影片信息单元
        LSFilmInfoInfoCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSFilmInfoInfoCell"];
        if(cell==nil)
        {
            cell=[[[LSFilmInfoInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSFilmInfoInfoCell"] autorelease];
            cell.film=_film;
        }
        [cell setNeedsDisplay];
        return cell;
    }
    else if(indexPath.row==1)
    {
        //影片简介单元
        LSFilmInfoDescriptionCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSFilmInfoDescriptionCell"];
        if(cell==nil)
        {
            cell=[[[LSFilmInfoDescriptionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSFilmInfoDescriptionCell"] autorelease];
            cell.film=_film;
        }
        cell.isSpread=_isDescriptionSpread;//设置展开状态
        [cell setNeedsDisplay];
        return cell;
    }
    else if(indexPath.row==2)
    {
        //影片剧照单元
        LSFilmInfoStillCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSFilmInfoStillCell"];
        if(cell==nil)
        {
            cell=[[[LSFilmInfoStillCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSFilmInfoStillCell"] autorelease];
            cell.delegate=self;
        }
        cell.stillArray=_film.stillArray;
        [cell setNeedsLayout];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==1)
    {
        _isDescriptionSpread=!_isDescriptionSpread;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


#pragma mark-LSSeatSectionFooter委托方法
- (void)LSSeatSectionFooter:(LSSeatSectionFooter *)seatSectionFooter didClickButton:(UIButton *)button
{
    LSCinemasByFilmViewController* cinemasByFilmViewController=[[LSCinemasByFilmViewController alloc] init];
    cinemasByFilmViewController.film=_film;
    [self.navigationController pushViewController:cinemasByFilmViewController animated:YES];
    [cinemasByFilmViewController release];
}


#pragma mark- LSFilmInfoStillCell委托方法
- (void)LSFilmInfoStillCell:(LSFilmInfoStillCell *)filmInfoStillCell didSelectRowAtIndexPath:(NSInteger)indexPath
{
    LSStillsViewController* stillsViewController=[[LSStillsViewController alloc] init];
    stillsViewController.film=_film;
    [self.navigationController pushViewController:stillsViewController animated:YES];
    [stillsViewController release];
}

#pragma mark- UIActionSheet的委托方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        if([LSShare sinaWBShareAuthStatus])
        {
            [self makeShareViewController:LSShareTypeSinaWB];
        }
        else
        {
            LSSinaWBAuthViewController* sinaWBAuthViewController = [[LSSinaWBAuthViewController alloc] init];
            sinaWBAuthViewController.delegate=self;
            [self.navigationController pushViewController:sinaWBAuthViewController animated:YES];
            [sinaWBAuthViewController release];
        }
    }
    else if(buttonIndex==1)
    {
        if([LSShare qqWBShareAuthStatus])
        {
            [self makeShareViewController:LSShareTypeQQWB];
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
    [self.navigationController popToViewController:self animated:NO];
    [self makeShareViewController:LSShareTypeSinaWB];
}

#pragma mark- LSQQWBAuthViewController的委托方法
- (void)LSQQWBAuthViewControllerDidLogin
{
    [self.navigationController popToViewController:self animated:NO];
    [self makeShareViewController:LSShareTypeQQWB];
}

@end
