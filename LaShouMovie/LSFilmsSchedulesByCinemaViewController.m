//
//  LSFilmsSchedulesByCinemaViewController.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-12.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSFilmsSchedulesByCinemaViewController.h"
#import "LSSeatsViewController.h"
#import "LSGroupInfoViewController.h"
#import "LSSchedule.h"
#import "LSScheduleDictionary.h"
#import "LSNothingCell.h"
#import "LSCinemaMapViewController.h"
#import "LSFilmInfoViewController.h"

@interface LSFilmsSchedulesByCinemaViewController ()

@end

@implementation LSFilmsSchedulesByCinemaViewController

@synthesize cinema=_cinema;
@synthesize film=_film;

#pragma mark- 生命周期

- (void)dealloc
{
    LSRELEASE(_today)

    self.cinema=nil;
    self.film=nil;
    LSRELEASE(_filmMArray)

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
    _filmMArray=[[NSMutableArray alloc] initWithCapacity:0];
    
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeCinemaFilmsByCinemaID object:nil];
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeSchedulesByCinemaID_FilmID object:nil];
    
    [hud show:YES];
    [messageCenter LSMCCinemaFilmsWithCinemaID:_cinema.cinemaID];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- 私有方法
- (void)refreshTableView
{
    _selectScheduleArray=nil;
    for(LSScheduleDictionary* dic in _selectFilm.scheduleDicArray)
    {
        if(dic.scheduleDate==_selectScheduleDate)
        {
            _selectScheduleArray=dic.scheduleArray;
            break;
        }
    }
    
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_cinema.groupArray.count>0?2:1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
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
        
        if([notification.name isEqual:lsRequestTypeCinemaFilmsByCinemaID])
        {
            NSArray* tmpArray=notification.object;
            for(NSDictionary* dic in tmpArray)
            {
                LSFilm* film=[[LSFilm alloc] initWithDictionary:dic];
                [_filmMArray addObject:film];
                [film release];
            }
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        }
        else if([notification.name isEqual:lsRequestTypeSchedulesByCinemaID_FilmID])
        {
            //数据结构
            //{
            //    paiqi = (
            //               {
            //                  days = 0;
            //                  schedule=();
            //               },
            //               {
            //                  days = 2;
            //                  schedule =();
            //               }
            //             );
            //    today = "2013-09-12";
            //}

            dispatch_queue_t queue_0=dispatch_queue_create("queue_0", NULL);
            dispatch_async(queue_0, ^{
                
                id result=[notification.object objectForKey:lsRequestResult];
                int mark=[[notification.object objectForKey:lsRequestMark] intValue];
                
                LSRELEASE(_today)
                _today=[[result objectForKey:@"today"] retain];
                
                NSArray* tmpArray=[result objectForKey:@"paiqi"];
                NSMutableArray* scheduleDicMArray=[NSMutableArray arrayWithCapacity:0];
                for(NSDictionary* dic in tmpArray)
                {
                    LSScheduleDictionary* scheduleDictionary=[[LSScheduleDictionary alloc] initWithDictionary:dic];
                    [scheduleDicMArray addObject:scheduleDictionary];
                    [scheduleDictionary release];
                    
                    _selectScheduleDate=INT32_MAX;
                    if(scheduleDictionary.scheduleDate<_selectScheduleDate)
                    {
                        _selectScheduleDate=scheduleDictionary.scheduleDate;
                    }
                }
                
                if(_selectFilmIndex==mark)//如果是当前影片的排期字典数组，就刷新
                {
                    _selectFilm.scheduleDicArray=scheduleDicMArray;
                    _selectScheduleDate=INT32_MAX;
                    for(LSScheduleDictionary* scheduleDictionary in _selectFilm.scheduleDicArray)
                    {
                        if(scheduleDictionary.scheduleDate<_selectScheduleDate)
                        {
                            _selectScheduleDate=scheduleDictionary.scheduleDate;
                        }
                    }
                    
                    dispatch_async(dispatch_get_main_queue(),^{
                        
                        [self refreshTableView];
                    });
                }
                else
                {
                    LSFilm* film=[_filmMArray objectAtIndex:mark];
                    film.scheduleDicArray=scheduleDicMArray;
                }
            });
            dispatch_release(queue_0);
        }
    }
}


#pragma mark - UITableView委托方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.f;
    }
    else if (section == 1)
    {
        return 10.f;
    }
    else
    {
        return _today==nil?0.f:(_selectFilm.scheduleDicArray.count?44.f:0.f);
    }
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return nil;
    }
    else if (section == 1)
    {
        return [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    }
    else
    {
        if(_dateSectionHeader==nil)
        {
            _dateSectionHeader=[[[LSDateSectionHeader alloc] initWithFrame:CGRectZero] autorelease];
            _dateSectionHeader.scheduleDicArray=_selectFilm.scheduleDicArray;
            _dateSectionHeader.today=_today;
            _dateSectionHeader.date=_selectScheduleDate;
            _dateSectionHeader.delegate=self;
        }
        return _dateSectionHeader;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1+_cinema.groupArray.count;
    }
    else if(section == 1)
    {
        return 1;
    }
    else
    {
        return _selectScheduleArray.count>0?_selectScheduleArray.count:1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        if(indexPath.row==0)
        {
            return [LSCinemaInfoInfoCell heightForCinema:_cinema];//影院信息
        }
        else
        {
            return 35.f;//团购
        }
    }
    else if(indexPath.section == 1)
    {
        return 96.f+44.f;//影片
    }
    else
    {
        return 60.f;//排期
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
                LSGroup* group=[_cinema.groupArray objectAtIndex:indexPath.row-1];
                cell.title=group.groupTitle;
            }
            return cell;
        }
    }
    else if(indexPath.section == 1)
    {
        //影片列表单元
        LSCinemaInfoFilmCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSCinemaInfoFilmCell"];
        if(cell==nil)
        {
            cell=[[[LSCinemaInfoFilmCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSCinemaInfoFilmCell"] autorelease];
            cell.delegate=self;
            cell.filmArray=_filmMArray;
        }
        return cell;
    }
    else
    {
        if(_selectScheduleArray.count==0)
        {
            LSNothingCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSNothingCell"];
            if(cell==nil)
            {
                cell=[[[LSNothingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSNothingCell"] autorelease];
                cell.title=@"暂无排期";
            }
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
    if(indexPath.section==2)
    {
        if(_selectScheduleArray.count==0)
        {
            return;
        }
        
        LSSeatsViewController* seatsViewController=[[LSSeatsViewController alloc] init];
        seatsViewController.cinema=_cinema;
        seatsViewController.film=_selectFilm;
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


#pragma mark- LSCinemaInfoFilmCell的委托方法
- (void)LSCinemaInfoFilmCell:(LSCinemaInfoFilmCell*)cinemaInfoFilmCell didChangeRowToIndexPath:(NSInteger)indexPath
{
    if(_filmMArray.count<indexPath+1)
        return;
    
    _selectFilmIndex=indexPath;
    _selectFilm=[_filmMArray objectAtIndex:_selectFilmIndex];
    
    if(_selectFilm.scheduleDicArray==nil)
    {
        [hud show:NO];
        [messageCenter LSMCSchedulesWithCinemaID:_cinema.cinemaID filmID:_selectFilm.filmID mark:_selectFilmIndex];
    }
    else
    {
        _selectScheduleDate=INT32_MAX;
        for(LSScheduleDictionary* scheduleDictionary in _selectFilm.scheduleDicArray)
        {
            if(scheduleDictionary.scheduleDate<_selectScheduleDate)
            {
                _selectScheduleDate=scheduleDictionary.scheduleDate;
            }
        }

        [self refreshTableView];
    }
}
- (void)LSCinemaInfoFilmCell:(LSCinemaInfoFilmCell *)cinemaInfoFilmCell didSelectRowAtIndexPath:(NSInteger)indexPath
{
    LSFilmInfoViewController* filmInfoViewController=[[LSFilmInfoViewController alloc] init];
    filmInfoViewController.film=[_filmMArray objectAtIndex:indexPath];
    filmInfoViewController.isHideFooter=YES;
    [self.navigationController pushViewController:filmInfoViewController animated:YES];
    [filmInfoViewController release];
}


#pragma mark- LSDateSectionHeader的委托方法
- (void)LSDateSectionHeader:(LSDateSectionHeader *)dateSectionHeader didSelectRowAtIndexPath:(int)date
{
    _selectScheduleDate=date;
    [self refreshTableView];
}

@end
