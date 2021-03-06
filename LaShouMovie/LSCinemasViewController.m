//
//  LSCinemasViewController.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-10.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSCinemasViewController.h"

#import "LSCinema.h"
#import "LSCinemaCell.h"
#import "LSFilmsSchedulesByCinemaViewController.h"
#import "LSFilmInfoViewController.h"
#import "LSADWebViewController.h"
#import "LSCinemasMapViewController.h"
#import "LSNothingCell.h"

@interface LSCinemasViewController ()

@end

@implementation LSCinemasViewController

#pragma mark- 生命周期
- (void)dealloc
{
    LSRELEASE(_cinemaMArray)
    
    LSRELEASE(_districtMArray)
    LSRELEASE(_areaMArray)
    
    LSRELEASE(_selectMArray)
    LSRELEASE(_district)
    
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
    self.title=@"影院";
    
    //实例化数组
    _cinemaMArray=[[NSMutableArray alloc] initWithCapacity:0];
    
    _districtMArray=[[NSMutableArray alloc] initWithCapacity:0];
    _areaMArray=[[NSMutableArray alloc] initWithCapacity:0];
    
    _selectMArray=[[NSMutableArray alloc] initWithCapacity:0];
    
    [self setBarButtonItemWithTitle:user.cityName imageName:@"" isRight:NO];
    [self setBarButtonItemWithImageName:@"" isRight:YES];
    
    //添加通知
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeCinemas object:nil];
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeAdvertisements object:nil];
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:LSNotificationCityChanged object:nil];
    
    _cinemaStatusView=[[LSCinemaStatusView alloc] initWithFrame:CGRectMake(0.f, 20.f+44.f, self.view.width, 54.f)];
    _cinemaStatusView.delegate=self;
    [self.view addSubview:_cinemaStatusView];
    [_cinemaStatusView release];
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0.f, 20.f+44.f+54.f, self.view.width, HeightOfiPhoneX(480.f-20.f-44.f-54.f)) style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    [_tableView release];
    
    [hud show:YES];
    [messageCenter LSMCCinemas];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- 重载方法
- (void)leftBarButtonItemClick:(UIBarButtonItem *)sender
{
    LSCitiesViewController* citiesViewController=[[LSCitiesViewController alloc] init];
    citiesViewController.delegate=self;
    
    UINavigationController* navigationController=[[UINavigationController alloc] initWithRootViewController:citiesViewController];
    [self presentViewController:navigationController animated:YES completion:^{}];
    
    [citiesViewController release];
    [navigationController release];
}
- (void)rightBarButtonItemClick:(UIBarButtonItem *)sender
{
    LSCinemasMapViewController* cinemasMapViewController=[[LSCinemasMapViewController alloc] init];
    cinemasMapViewController.cinemaArray=_selectMArray;
    [self.navigationController pushViewController:cinemasMapViewController animated:YES];
    [cinemasMapViewController release];
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
            if([notification.name isEqualToString:lsRequestTypeFilmCinemasByFilmID])
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
        
        if([notification.name isEqualToString:lsRequestTypeFilmCinemasByFilmID])
        {
            //myCinemas：常去的影院
            //cinemas:影院列表
            //数据结构
            //{
            //  cinemas = ();
            //  myCinemas = ();
            //}
            
            dispatch_queue_t queue_0=dispatch_queue_create("queue_0", NULL);
            dispatch_async(queue_0, ^{
                
                //处理myCinemas
                NSArray* tmpArray=[notification.object objectForKey:@"myCinemas"];
                NSMutableArray* myCinemaMArray=[NSMutableArray arrayWithCapacity:0];
                for(NSDictionary* dic in tmpArray)
                {
                    LSCinema* cinema=[[LSCinema alloc] initWithDictionary:dic];
                    [myCinemaMArray addObject:cinema];
                    [cinema release];
                }
                //注意此处的数组可能为空
                [_cinemaMArray addObject:myCinemaMArray];
                
                
                //处理cinemas
                tmpArray=[notification.object objectForKey:@"cinemas"];
                NSMutableArray* seatCinemaMArray=[NSMutableArray arrayWithCapacity:0];//记录只可订座方式的影院
                NSMutableArray* groupCinemaMArray=[NSMutableArray arrayWithCapacity:0];//记录只可团购方式的影院
                NSMutableArray* seatgroupCinemaMArray=[NSMutableArray arrayWithCapacity:0];//记录两种方式的影院
                NSMutableArray* otherCinemaMArray=[NSMutableArray arrayWithCapacity:0];//记录无购买方式的影院
                for(NSDictionary* dic in tmpArray)
                {
                    LSCinema* cinema=[[LSCinema alloc] initWithDictionary:dic];
                    if(cinema.buyType==LSCinemaBuyTypeOnlySeat)
                    {
                        [seatCinemaMArray addObject:cinema];
                    }
                    else if(cinema.buyType==LSCinemaBuyTypeOnlyGroup)
                    {
                        [groupCinemaMArray addObject:cinema];
                    }
                    else if(cinema.buyType==LSCinemaBuyTypeSeatGroup)
                    {
                        [seatgroupCinemaMArray addObject:cinema];
                    }
                    else
                    {
                        [otherCinemaMArray addObject:cinema];
                    }
                    [cinema release];
                }
                [_cinemaMArray addObject:seatCinemaMArray];
                [_cinemaMArray addObject:groupCinemaMArray];
                [_cinemaMArray addObject:seatgroupCinemaMArray];
                [_cinemaMArray addObject:otherCinemaMArray];
                
                
                if(_cinemaStatus==LSCinemaStatusSeat)
                {
                    [_selectMArray addObjectsFromArray:seatCinemaMArray];
                    [_selectMArray addObjectsFromArray:seatgroupCinemaMArray];
                }
                else if(_cinemaStatus==LSCinemaStatusGroup)
                {
                    [_selectMArray addObjectsFromArray:groupCinemaMArray];
                    [_selectMArray addObjectsFromArray:seatgroupCinemaMArray];
                }
                else if(_cinemaStatus==LSCinemaStatusAll)
                {
                    [_selectMArray addObjectsFromArray:seatCinemaMArray];
                    [_selectMArray addObjectsFromArray:groupCinemaMArray];
                    [_selectMArray addObjectsFromArray:seatgroupCinemaMArray];
                    [_selectMArray addObjectsFromArray:otherCinemaMArray];
                }
                
                if(_selectMArray.count>0)
                {
                    [_selectMArray sortUsingSelector:@selector(distanceSort:)];
                }
                
                //可以首先刷新视图
                dispatch_async(dispatch_get_main_queue(),^{
                    
                    [_tableView reloadData];
                });
                
                
                NSMutableDictionary* seatDistrictMDic=[NSMutableDictionary dictionaryWithCapacity:0];
                //可订座影院位置数组
                for (LSCinema* cinema in [_cinemaMArray objectAtIndex:LSCinemaArrayIndexSeat])
                {
                    [seatDistrictMDic setObject:[NSNumber numberWithInt:[[seatDistrictMDic objectForKey:cinema.districtName] intValue]+1] forKey:cinema.districtName];
                }
                for (LSCinema* cinema in [_cinemaMArray objectAtIndex:LSCinemaArrayIndexSeatGroup])
                {
                    [seatDistrictMDic setObject:[NSNumber numberWithInt:[[seatDistrictMDic objectForKey:cinema.districtName] intValue]+1] forKey:cinema.districtName];
                }
                
                NSMutableDictionary* groupDistrictMDic=[NSMutableDictionary dictionaryWithCapacity:0];
                //可团购影院位置数组
                for (LSCinema* cinema in [_cinemaMArray objectAtIndex:LSCinemaArrayIndexGroup])
                {
                    [groupDistrictMDic setObject:[NSNumber numberWithInt:[[groupDistrictMDic objectForKey:cinema.districtName] intValue]+1] forKey:cinema.districtName];
                }
                for (LSCinema* cinema in [_cinemaMArray objectAtIndex:LSCinemaArrayIndexSeatGroup])
                {
                    [groupDistrictMDic setObject:[NSNumber numberWithInt:[[groupDistrictMDic objectForKey:cinema.districtName] intValue]+1] forKey:cinema.districtName];
                }
                
                NSMutableDictionary* seatgroupDistrictMDic=[NSMutableDictionary dictionaryWithCapacity:0];
                //全部影院位置数组,需要包含四个数组
                for(int i=1;i<_cinemaMArray.count;i++)
                {
                    for (LSCinema* cinema in [_cinemaMArray objectAtIndex:i])
                    {
                        [seatgroupDistrictMDic setObject:[NSNumber numberWithInt:[[seatgroupDistrictMDic objectForKey:cinema.districtName] intValue]+1] forKey:cinema.districtName];
                    }
                }
                
                [_districtMArray addObject:seatDistrictMDic];
                [_districtMArray addObject:groupDistrictMDic];
                [_districtMArray addObject:seatgroupDistrictMDic];
            });
            dispatch_release(queue_0);
        }
        else if([notification.name isEqualToString:lsRequestTypeAdvertisements])
        {
            _adView=[[LSAdView alloc] initWithFrame:CGRectMake(0.f, 20.f+44.f, self.view.width, 50.f)];
            _adView.delegate=self;
            [self.view addSubview:_adView];
            [_adView release];
            
            _advertisment=[[LSAdvertisment alloc] initWithDictionary:notification.object];
            _adView.advertisment=_advertisment;
            [_adView setNeedsLayout];
            [_advertisment release];
            
            _tableView.frame=CGRectMake(0.f, _tableView.top+50.f, _tableView.width, _tableView.height-50.f);
        }
    }
}


#pragma mark- LSStatusView委托方法
- (void)LSCinemaStatusView:(LSCinemaStatusView *)cinemaStatusView didSelectCinemaStatus:(LSCinemaStatus)status
{
    [_selectMArray removeAllObjects];
    _cinemaStatus=status;
    
    if(_cinemaStatus==LSCinemaStatusSeat)
    {
        [_selectMArray addObjectsFromArray:[_cinemaMArray objectAtIndex:LSCinemaArrayIndexSeat]];
        [_selectMArray addObjectsFromArray:[_cinemaMArray objectAtIndex:LSCinemaArrayIndexSeatGroup]];
    }
    else if(_cinemaStatus==LSCinemaStatusGroup)
    {
        [_selectMArray addObjectsFromArray:[_cinemaMArray objectAtIndex:LSCinemaArrayIndexGroup]];
        [_selectMArray addObjectsFromArray:[_cinemaMArray objectAtIndex:LSCinemaArrayIndexSeatGroup]];
    }
    else
    {
        [_selectMArray addObjectsFromArray:[_cinemaMArray objectAtIndex:LSCinemaArrayIndexSeat]];
        [_selectMArray addObjectsFromArray:[_cinemaMArray objectAtIndex:LSCinemaArrayIndexGroup]];
        [_selectMArray addObjectsFromArray:[_cinemaMArray objectAtIndex:LSCinemaArrayIndexSeatGroup]];
        [_selectMArray addObjectsFromArray:[_cinemaMArray objectAtIndex:LSCinemaArrayIndexNon]];
    }
    
    if(_selectMArray.count>0)
    {
        [_selectMArray sortUsingSelector:@selector(distanceSort:)];
    }
    
    [_tableView reloadData];
}

#pragma mark- LSPositionSectionHeader的委托方法
- (void)LSPositionSectionHeader:(LSPositionSectionHeader *)positionSectionHeader didClickPositionButton:(UIButton *)positionButton
{
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    LSDistrictSelectorView* selectorView=[[LSDistrictSelectorView alloc] initWithFrame:CGRectMake(0.f, 44.f+44.f, self.view.width, HeightOfiPhoneX(480.f-20.f-44.f-44.f))];
    selectorView.contentSize=CGSizeMake(selectorView.width, 44.f*5);
    selectorView.delegate=self;
    selectorView.districtDic=[_districtMArray objectAtIndex:_cinemaStatus];
    [self.view addSubview:selectorView];
    [selectorView release];
}

#pragma mark- LSDistrictSelectorView的委托方法
- (void)LSDistrictSelectorView:(LSDistrictSelectorView *)districtSelectorView didSelectDistrict:(NSString *)district
{
    dispatch_queue_t queue_0=dispatch_queue_create("queue_0", NULL);
    dispatch_async(queue_0, ^{
        
        LSRELEASE(_district)
        _district=[[NSString alloc] initWithString:district];
        
        [_selectMArray removeAllObjects];
        if(_cinemaStatus==LSCinemaStatusSeat)
        {
            if(district==nil)
            {
                [_selectMArray addObjectsFromArray:[_cinemaMArray objectAtIndex:LSCinemaArrayIndexSeat]];
                [_selectMArray addObjectsFromArray:[_cinemaMArray objectAtIndex:LSCinemaArrayIndexSeatGroup]];
            }
            else
            {
                for (LSCinema* cinema in [_cinemaMArray objectAtIndex:LSCinemaArrayIndexSeat])
                {
                    if([cinema.districtName isEqualToString:district])
                    {
                        [_selectMArray addObject:cinema];
                    }
                }
                for (LSCinema* cinema in [_cinemaMArray objectAtIndex:LSCinemaArrayIndexSeatGroup])
                {
                    if([cinema.districtName isEqualToString:district])
                    {
                        [_selectMArray addObject:cinema];
                    }
                }
            }
        }
        else if(_cinemaStatus==LSCinemaStatusGroup)
        {
            if(district==nil)
            {
                [_selectMArray addObjectsFromArray:[_cinemaMArray objectAtIndex:LSCinemaArrayIndexGroup]];
                [_selectMArray addObjectsFromArray:[_cinemaMArray objectAtIndex:LSCinemaArrayIndexSeatGroup]];
            }
            else
            {
                for (LSCinema* cinema in [_cinemaMArray objectAtIndex:LSCinemaArrayIndexGroup])
                {
                    if([cinema.districtName isEqualToString:district])
                    {
                        [_selectMArray addObject:cinema];
                    }
                }
                for (LSCinema* cinema in [_cinemaMArray objectAtIndex:LSCinemaArrayIndexSeatGroup])
                {
                    if([cinema.districtName isEqualToString:district])
                    {
                        [_selectMArray addObject:cinema];
                    }
                }
            }
        }
        else if(_cinemaStatus==LSCinemaStatusAll)
        {
            if(district==nil)
            {
                for (int i=1;i<_cinemaMArray.count;i++)
                {
                    [_selectMArray addObjectsFromArray:[_cinemaMArray objectAtIndex:i]];
                }
            }
            else
            {
                for (int i=1;i<_cinemaMArray.count;i++)
                {
                    for (LSCinema* cinema in [_cinemaMArray objectAtIndex:i])
                    {
                        if([cinema.districtName isEqualToString:district])
                        {
                            [_selectMArray addObject:cinema];
                        }
                    }
                }
            }
        }
        
        //如果没有影院，添加字符串占位
        if(_selectMArray.count>1)
        {
            [_selectMArray sortUsingSelector:@selector(distanceSort:)];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_tableView reloadData];
        });
    });
    dispatch_release(queue_0);
}


#pragma mark- UITableView委托方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(_cinemaMArray.count>0)
    {
        int sections=0;
        //如果有常去影院
        if(((NSArray*)[_cinemaMArray objectAtIndex:LSCinemaArrayIndexMy]).count)
        {
            sections++;
        }
        sections++;
        return sections;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    LSPositionSectionHeader* positionSectionHeader = [[[LSPositionSectionHeader alloc] initWithFrame:CGRectZero] autorelease];
    if (section == 0)
    {
        if(((NSArray*)[_cinemaMArray objectAtIndex:LSCinemaArrayIndexMy]).count)
        {
            positionSectionHeader.positionSectionHeaderType=LSPositionSectionHeaderTypeUsual;
            positionSectionHeader.title=@"常去影院";
        }
        else
        {
            positionSectionHeader.delegate=self;
            positionSectionHeader.positionSectionHeaderType=LSPositionSectionHeaderTypeNear;
            positionSectionHeader.title=_district;
        }
    }
    else
    {
        positionSectionHeader.delegate=self;
        positionSectionHeader.positionSectionHeaderType=LSPositionSectionHeaderTypeNear;
        positionSectionHeader.title=_district;
    }
    
    return positionSectionHeader;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count=0;
    if(section==0)
    {
        if(((NSArray*)[_cinemaMArray objectAtIndex:LSCinemaArrayIndexMy]).count)
        {
            count=((NSArray*)[_cinemaMArray objectAtIndex:LSCinemaArrayIndexMy]).count;
        }
        else
        {
            count=_selectMArray.count;
        }
    }
    else
    {
        count=_selectMArray.count;
    }
    return count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[_selectMArray objectAtIndex:0] isKindOfClass:[NSString class]])
    {
        return 44.f;
    }
    else
    {
        return 60.f;
    }
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSCinemaCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSCinemaCell"];
    if(cell==nil)
    {
        cell=[[[LSCinemaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSCinemaCell"] autorelease];
    }
    
    LSCinema* cinema=nil;
    if(indexPath.section==0)
    {
        if(((NSArray*)[_cinemaMArray objectAtIndex:LSCinemaArrayIndexMy]).count)
        {
            cinema=[[_cinemaMArray objectAtIndex:LSCinemaArrayIndexMy] objectAtIndex:indexPath.row];
        }
        else
        {
            cinema=[_selectMArray objectAtIndex:indexPath.row];
        }
    }
    else
    {
        cinema=[_selectMArray objectAtIndex:indexPath.row];
    }
    
    cell.cinema=cinema;
    [cell setNeedsDisplay];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[LSNothingCell class]])
    {
        return;
    }
    
    LSFilmsSchedulesByCinemaViewController* filmsSchedulesByCinemaViewController=[[LSFilmsSchedulesByCinemaViewController alloc] init];
    LSCinema* cinema=nil;
    if(indexPath.section==0)
    {
        if(((NSArray*)[_cinemaMArray objectAtIndex:LSCinemaArrayIndexMy]).count)
        {
            cinema=[[_cinemaMArray objectAtIndex:LSCinemaArrayIndexMy] objectAtIndex:indexPath.row];
        }
        else
        {
            cinema=[_selectMArray objectAtIndex:indexPath.row];
        }
    }
    else
    {
        cinema=[_selectMArray objectAtIndex:indexPath.row];
    }
    filmsSchedulesByCinemaViewController.cinema=cinema;
    filmsSchedulesByCinemaViewController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:filmsSchedulesByCinemaViewController animated:YES];
    [filmsSchedulesByCinemaViewController release];
}

#pragma mark- LSAdView的委托方法
- (void)LSAdViewDidSelect
{
    //第一项应该不会出现，因为在初期应该已经将此项pass掉了
    if(_advertisment.adType==LSAdvertismentTypeNotNeedShow)
    {
        
    }
    else if(_advertisment.adType==LSAdvertismentTypeShowImage)
    {
        
    }
    else if(_advertisment.adType==LSAdvertismentTypeToFilmView)
    {
        LSFilmInfoViewController* filmInfoViewController=[[LSFilmInfoViewController alloc] init];
        filmInfoViewController.film=_advertisment.data;
        filmInfoViewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:filmInfoViewController animated:YES];
        [filmInfoViewController release];
    }
    else if(_advertisment.adType==LSAdvertismentTypeToCinemaView)
    {
        LSFilmsSchedulesByCinemaViewController* filmsSchedulesByCinemaViewController=[[LSFilmsSchedulesByCinemaViewController alloc] init];
        filmsSchedulesByCinemaViewController.cinema=_advertisment.data;
        filmsSchedulesByCinemaViewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:filmsSchedulesByCinemaViewController animated:YES];
        [filmsSchedulesByCinemaViewController release];
    }
    else if(_advertisment.adType==LSAdvertismentTypeToWapView)
    {
        
    }
    else if(_advertisment.adType==LSAdvertismentTypeToActivity)
    {
        LSADWebViewController* adWebViewController=[[LSADWebViewController alloc] init];
        adWebViewController.activity=_advertisment.data;
        adWebViewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:adWebViewController animated:YES];
        [adWebViewController release];
    }
}
- (void)LSAdViewDidClose
{
    LSRELEASE(_advertisment);
    [_adView removeFromSuperview];
    
    _tableView.frame=CGRectMake(0.f, _tableView.top-50.f, _tableView.width, _tableView.height+50.f);
}

#pragma mark- LSCitiesViewController的委托方法
- (void)LSCitiesViewControllerDidSelect
{
    [self dismissViewControllerAnimated:YES completion:^{
        LSRELEASE(_advertisment);
        
        [self setBarButtonItemWithTitle:user.cityName imageName:@"" isRight:NO];
        
        [hud show:YES];
        [messageCenter LSMCCinemas];
    }];
}

@end
