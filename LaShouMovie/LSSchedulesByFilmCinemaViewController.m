//
//  LSSchedulesByFilmCinemaViewController.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-8-29.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSSchedulesByFilmCinemaViewController.h"

#import "LSSchedule.h"
#import "LSScheduleDictionary.h"
#import "LSCinemaInfoNoScheduleCell.h"
#import "LSSeatsViewController.h"
#import "LSGroupInfoViewController.h"
#import "LSCinemaMapViewController.h"

@interface LSSchedulesByFilmCinemaViewController ()

@end

@implementation LSSchedulesByFilmCinemaViewController

@synthesize cinema=_cinema;
@synthesize film=_film;

#pragma mark- 生命周期

- (void)dealloc
{
    _film.scheduleDicArray=nil;
    self.film=nil;
    self.cinema=nil;
    LSRELEASE(_today)

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
    self.title=_cinema.cinemaName;
    _selectScheduleDate=INT32_MAX;
    
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeSchedulesByCinemaID_FilmID object:nil];
    [messageCenter LSMCSchedulesWithCinemaID:_cinema.cinemaID filmID:_film.filmID mark:-1];
    [hud show:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- 重载方法
- (void)backButtonClick:(UIButton *)sender
{
    _film.scheduleDicArray=nil;
    [self.navigationController popViewControllerAnimated:YES];
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
            if([notification.name isEqualToString:lsRequestTypeSchedulesByCinemaID_FilmID])
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
        
        if([notification.name isEqual:lsRequestTypeSchedulesByCinemaID_FilmID])
        {
            //数据结构
            //{
            //paiqi = (
            //           {
            //               days = 0;
            //               schedule=();
            //           },
            //           {
            //               days = 2;
            //               schedule =();
            //           }
            //        );
            //        today = "2013-09-12";
            //}
            
            LSRELEASE(_today)
            _today=[[notification.object objectForKey:@"today"] retain];
            
            NSArray* tmpArray=[notification.object objectForKey:@"paiqi"];
            NSMutableArray* scheduleDicMArray=[NSMutableArray arrayWithCapacity:0];
            for(NSDictionary* dic in tmpArray)
            {
                LSScheduleDictionary* scheduleDictionary=[[LSScheduleDictionary alloc] initWithDictionary:dic];
                [scheduleDicMArray addObject:scheduleDictionary];
                [scheduleDictionary release];
                
                if(scheduleDictionary.scheduleDate<_selectScheduleDate)
                {
                    _selectScheduleDate=scheduleDictionary.scheduleDate;
                }
            }
            
            _film.scheduleDicArray=scheduleDicMArray;
            [self refreshTableView];
        }
    }
}

- (void)refreshTableView
{
    _selectScheduleArray=nil;
    for(LSScheduleDictionary* dic in _film.scheduleDicArray)
    {
        if(dic.scheduleDate==_selectScheduleDate)
        {
            _selectScheduleArray=dic.scheduleArray;
            break;
        }
    }
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark - UITableView委托方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.f;
    }
    else
    {
        return (_today!=nil)?(_film.scheduleDicArray.count?85.f:41.f):0.f;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section==0)
    {
        return nil;
    }
    else
    {
        LSDateSectionHeader* dateSectionHeader=[[[LSDateSectionHeader alloc] initWithFrame:CGRectZero] autorelease];
        dateSectionHeader.title=_film.filmName;
        dateSectionHeader.scheduleDicArray=_film.scheduleDicArray;
        dateSectionHeader.today=_today;
        dateSectionHeader.date=_selectScheduleDate;
        dateSectionHeader.delegate=self;
        return dateSectionHeader;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
    {
        if(_cinema.groupArray.count==0)
        {
            return 1;
        }
        else
        {
            return 2;
        }
    }
    else
    {
        if(_selectScheduleArray!=nil)
        {
            return _selectScheduleArray.count>0?_selectScheduleArray.count:1;
        }
        else
        {
            if(_film.scheduleDicArray!=nil)
            {
                return 1;
            }
            else
            {
                return 0;
            }
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        if(indexPath.row==0)
        {
            return [LSCinemaInfoInfoCell heightForCinema:_cinema];
        }
        else
        {
            return 64.f;//团购
        }
    }
    else
    {
        return 44.f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        if(indexPath.row==0)
        {
            //影院信息单元
            LSCinemaInfoInfoCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSCinemaInfoInfoCell"];
            if(cell==nil)
            {
                cell=[[[LSCinemaInfoInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSCinemaInfoInfoCell"] autorelease];
                cell.delegate=self;
            }
            cell.cinema=_cinema;
            [cell setNeedsDisplay];
            return cell;
        }
        else
        {
            //影片团购单元
            LSCinemaInfoGroupCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSCinemaInfoGroupCell"];
            if(cell==nil)
            {
                cell=[[[LSCinemaInfoGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSCinemaInfoGroupCell"] autorelease];
                cell.delegate=self;
            }
            cell.groupArray=_cinema.groupArray;
            [cell setNeedsLayout];
            return cell;
        }
    }
    else
    {
        if(_selectScheduleArray.count==0)
        {
            LSCinemaInfoNoScheduleCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSCinemaInfoNoScheduleCell"];
            if(cell==nil)
            {
                cell=[[[LSCinemaInfoNoScheduleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSCinemaInfoNoScheduleCell"] autorelease];
            }
            [cell setNeedsDisplay];
            return cell; 
        }
        
        //影片排期列表单元
        LSCinemaInfoScheduleCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSCinemaInfoScheduleCell"];
        if(cell==nil)
        {
            cell=[[[LSCinemaInfoScheduleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSCinemaInfoScheduleCell"] autorelease];
        }
        LSSchedule* schedule=[_selectScheduleArray objectAtIndex:indexPath.row];
        cell.schedule=schedule;
        [cell setNeedsDisplay];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //如果选择的是排期
    if(_selectScheduleArray!=nil && indexPath.section==1)
    {
        if(_selectScheduleArray.count==0)
        {
            return;
        }
        
        LSSeatsViewController* seatsViewController=[[LSSeatsViewController alloc] init];
        seatsViewController.cinema=_cinema;
        seatsViewController.film=_film;
        seatsViewController.schedule=[_selectScheduleArray objectAtIndex:indexPath.row];
        seatsViewController.scheduleArray=_selectScheduleArray;
        [self.navigationController pushViewController:seatsViewController animated:YES];
        [seatsViewController release];
    }
}


#pragma mark- LSCinemaInfoInfoCell的委托方法
- (void)LSCinemaInfoInfoCell:(LSCinemaInfoInfoCell *)cinemaInfoInfoCell didClickMapButton:(UIButton *)mapButton
{
    LSCinemaMapViewController* cinemaMapViewController=[[LSCinemaMapViewController alloc] init];
    cinemaMapViewController.cinema=_cinema;
    [self.navigationController pushViewController:cinemaMapViewController animated:YES];
    [cinemaMapViewController release];
}
- (void)LSCinemaInfoInfoCell:(LSCinemaInfoInfoCell *)cinemaInfoInfoCell didClickPhoneButton:(UIButton *)phoneButton
{
    UIActionSheet* actionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:[NSString stringWithFormat:@"呼叫 %@",_cinema.phone] otherButtonTitles:nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    [actionSheet release];
}

#pragma mark- UIActionSheet的委托方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==actionSheet.destructiveButtonIndex)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", _cinema.phone]]];
    }
}


#pragma mark- LSCinemaInfoGroupCell的委托方法
- (void)LSCinemaInfoGroupCell:(LSCinemaInfoGroupCell *)cinemaInfoGroupCell didSelectRowAtIndexPath:(NSInteger)indexPath
{
    LSGroupInfoViewController* groupInfoViewController=[[LSGroupInfoViewController alloc] init];
    groupInfoViewController.group=[_cinema.groupArray objectAtIndex:indexPath];
    groupInfoViewController.cinema=_cinema;
    [self.navigationController pushViewController:groupInfoViewController animated:YES];
    [groupInfoViewController release];
}


#pragma mark- LSDateSectionHeader的委托方法
- (void)LSDateSectionHeader:(LSDateSectionHeader *)dateSectionHeader didSelectRowAtIndexPath:(int)date
{
    _selectScheduleDate=date;
    [self refreshTableView];
}

@end
