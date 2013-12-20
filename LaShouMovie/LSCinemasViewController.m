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
#import "LSAdvertisment.h"
#import "LSNothingCell.h"

typedef enum
{
    LSIndexMy=0,
    LSIndexSeat=1,
    LSIndexGroup=2,
    LSIndexSeatGroup=3,
    LSIndexNon=4
}LSIndex;


@interface LSCinemasViewController ()

@end

@implementation LSCinemasViewController

#pragma mark- 生命周期
- (void)dealloc
{
    LSRELEASE(_cinemaMArray)
    
    LSRELEASE(_seatPositionMArray)
    LSRELEASE(_groupPositionMArray)
    LSRELEASE(_allPositionMArray)

    LSRELEASE(_selectMArray)
    
    LSRELEASE(_advertisment)
    
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
    
    CGSize size=[@"影院" sizeWithFont:[UIFont systemFontOfSize:21.0]];
    UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    label.backgroundColor=[UIColor clearColor];
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:21.0];
    label.textColor=[UIColor whiteColor];
    label.text=@"影院";
    self.navigationItem.titleView=label;
    [label release];
    
    
    //实例化数组
    _cinemaMArray=[[NSMutableArray alloc] initWithCapacity:0];
    
    _seatPositionMArray=[[NSMutableArray alloc] initWithCapacity:0];
    _groupPositionMArray=[[NSMutableArray alloc] initWithCapacity:0];
    _allPositionMArray=[[NSMutableArray alloc] initWithCapacity:0];
    
    _selectMArray=[[NSMutableArray alloc] initWithCapacity:0];
    
    //添加通知
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeCinemas object:nil];

    [self setBarButtonItemWithImageName:@"nav_map.png" clickedImageName:@"nav_map_d.png" isRight:YES buttonType:LSOtherButtonTypeMap];
    
    [self setBarButtonItemWithImageName:@"nav_city.png" clickedImageName:@"nav_city_d.png" isRight:NO buttonType:LSOtherButtonTypeChangeCity];
    UIButton* button=(UIButton*)(self.navigationItem.leftBarButtonItem.customView);
    button.titleLabel.font = LSFontBold15;
    button.titleLabel.minimumFontSize = 13.f;
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    [button setTitle:user.cityName forState:UIControlStateNormal];
    
    _cinemaStatusView=[[LSCinemaStatusView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44.f)];
    _cinemaStatusView.delegate=self;
    [self.view addSubview:_cinemaStatusView];
    [_cinemaStatusView release];
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 44.f, self.view.width, HeightOfiPhoneX(480-20.f-44.f-44.f-50.f)) style:UITableViewStylePlain];
    //_tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.backgroundView=nil;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    [_tableView release];
    
    [hud show:YES];
    [messageCenter LSMCCinemas];
    #ifdef LSDEBUG
    NSLog(@"===========开始请求影院数据=============");
    #endif
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeAdvertisements object:nil];
    
    [self refreshCity];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    if(_advertisment==nil)
    {
        [messageCenter LSMCAdvertisements];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [messageCenter removeObserver:self name:lsRequestTypeAdvertisements object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- 重载方法
//按钮的目标方法
- (void)otherButtonClick:(UIButton *)sender
{
    [super otherButtonClick:sender];
    if(sender.tag==LSOtherButtonTypeChangeCity)
    {
        LSCitiesViewController* citiesViewController=[[[LSCitiesViewController alloc] init] autorelease];
        citiesViewController.delegate=self;
        
        UINavigationController* navigationController=[[UINavigationController alloc] initWithRootViewController:citiesViewController];
        [self presentModalViewController:navigationController animated:YES];
        [navigationController release];
    }
    else if(sender.tag==LSOtherButtonTypeMap)
    {
        LSCinemasMapViewController* cinemasMapViewController=[[LSCinemasMapViewController alloc] init];
        cinemasMapViewController.cinemaArray=_selectMArray;
        cinemasMapViewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:cinemasMapViewController animated:YES];
        [cinemasMapViewController release];
    }
}

//刷新方法
- (void)refreshBecauseInternet
{
    if(![self refreshCity])
    {
        [hud show:YES];
        [messageCenter LSMCCinemas];
    }
}

#pragma mark- 私有方法
//城市切换引起的按钮信息刷新
- (BOOL)refreshCity
{
    UIButton* button=(UIButton*)(self.navigationItem.leftBarButtonItem.customView);
    if(![button.titleLabel.text isEqualToString:user.cityName])
    {
        [button setTitle:user.cityName forState:UIControlStateNormal];
        [hud show:YES];
        [messageCenter LSMCCinemas];
        return YES;
    }
    else
    {
        return NO;
    }
}
//加载广告栏
- (void)showAdvertisment
{
    if(_advertisment!=nil && _adView==nil)
    {
        _adView=[[LSAdView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.width, 50.f)];
        _adView.advertisment=_advertisment;
        _adView.delegate=self;
        [self.view addSubview:_adView];
        [_adView release];
        
        if(_tableView!=nil)
        {
            _cinemaStatusView.frame=CGRectMake(0, 50.f, self.view.width, _cinemaStatusView.height);
            _tableView.frame=CGRectMake(0, 50.f+44.f, self.view.width, _tableView.height-50);
        }
    }
}


#pragma mark- 通知中心消息
- (void)lsHttpRequestNotification:(NSNotification*)notification
{
    if([notification.name isEqualToString:lsRequestTypeCinemas])
    {
        [hud hide:YES];
    }
    
    if([self checkIsNotEmpty:notification])
    {
        if([notification.object isEqual:lsRequestFailed])
        {
            //超时
            return;
        }
        
        if([notification.object isKindOfClass:[LSStatus class]])
        {
            if([notification.name isEqualToString:lsRequestTypeCinemas])
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
        
        if([notification.name isEqualToString:lsRequestTypeCinemas])
        {
            //myCinemas：常去的影院
            //cinemas:影院列表
            //数据结构
//            {
//                cinemas = ();
//                myCinemas = ();
//            }
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
                
                //如果没有影院，添加字符串占位
                if(_selectMArray.count==0)
                {
                    [_selectMArray addObject:@"没有影院"];
                }
                else
                {
                    [_selectMArray sortUsingSelector:@selector(distanceSort:)];
                }
                
                //可订座影院位置数组
                [_seatPositionMArray addObject:@"附近的影院"];
                for (LSCinema* cinema in seatCinemaMArray)
                {
                    if(![_seatPositionMArray containsObject:cinema.districtName])
                    {
                        [_seatPositionMArray addObject:cinema.districtName];
                    }
                }
                for (LSCinema* cinema in seatgroupCinemaMArray)
                {
                    if(![_seatPositionMArray containsObject:cinema.districtName])
                    {
                        [_seatPositionMArray addObject:cinema.districtName];
                    }
                }
                
                //可团购影院位置数组
                [_groupPositionMArray addObject:@"附近的影院"];
                for (LSCinema* cinema in groupCinemaMArray)
                {
                    if(![_groupPositionMArray containsObject:cinema.districtName])
                    {
                        [_groupPositionMArray addObject:cinema.districtName];
                    }
                }
                for (LSCinema* cinema in seatgroupCinemaMArray)
                {
                    if(![_groupPositionMArray containsObject:cinema.districtName])
                    {
                        [_groupPositionMArray addObject:cinema.districtName];
                    }
                }
                
                //全部影院位置数组,需要包含四个数组
                [_allPositionMArray addObject:@"附近的影院"];
                for(int i=1;i<_cinemaMArray.count;i++)
                {
                    for (LSCinema* cinema in [_cinemaMArray objectAtIndex:i])
                    {
                        if(![_allPositionMArray containsObject:cinema.districtName])
                        {
                            [_allPositionMArray addObject:cinema.districtName];
                        }
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(),^{
                    
                    [_tableView reloadData];
                });
            });
            dispatch_release(queue_0);
        }
        else if([notification.name isEqualToString:lsRequestTypeAdvertisements])
        {
            _advertisment=[[LSAdvertisment alloc] initWithDictionary:notification.object];
            [self showAdvertisment];
        }
    }
}


#pragma mark- LSAdView的委托方法
- (void)LSAdViewDidClose
{
    if(_adView!=nil)
    {
        [_adView removeFromSuperview];
        _adView=nil;
        _cinemaStatusView.frame=CGRectMake(0, 0.f, self.view.width, _cinemaStatusView.height);
        _tableView.frame=CGRectMake(0, 44.f, self.view.width, _tableView.height+50.f);
    }
}
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


#pragma mark- LSCitiesViewController的委托方法
- (void)LSCitiesViewControllerDidSelect
{
    [_cinemaMArray removeAllObjects];
    
    [_seatPositionMArray removeAllObjects];
    [_groupPositionMArray removeAllObjects];
    [_allPositionMArray removeAllObjects];
    
    [_selectMArray removeAllObjects];
    
    _selectPositionIndex=0;
    _cinemaStatus=LSCinemaStatusSeat;
    _cinemaStatusView.cinemaStatus=_cinemaStatus;
    
    [_tableView reloadData];
    
    [self LSAdViewDidClose];
    LSRELEASE(_advertisment);
    
    UIButton* button=(UIButton*)(self.navigationItem.leftBarButtonItem.customView);
    [button setTitle:user.cityName forState:UIControlStateNormal];
    
    [hud show:YES];
    [messageCenter LSMCCinemas];
    
#ifdef LSDEBUG
    NSLog(@"===========开始请求影院数据=============");
#endif
    
    [messageCenter LSMCAdvertisements];
    
    [self performSelector:@selector(dismissModalViewController) withObject:nil afterDelay:1.f];
}
- (void)dismissModalViewController
{
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark- LSCinemaStatusView委托方法
- (void)LSCinemaStatusView:(LSCinemaStatusView *)cinemaStatusView didSelectRowAtIndexPath:(LSCinemaStatus)cinemaStatus
{
    [_selectMArray removeAllObjects];
    _selectPositionIndex=0;
    _cinemaStatus=cinemaStatus;
    
    if(_cinemaMArray.count==0)
        return;
    
    if(_cinemaStatus==LSCinemaStatusSeat)
    {
        [_selectMArray addObjectsFromArray:[_cinemaMArray objectAtIndex:LSIndexSeat]];
        [_selectMArray addObjectsFromArray:[_cinemaMArray objectAtIndex:LSIndexSeatGroup]];
    }
    else if(_cinemaStatus==LSCinemaStatusGroup)
    {
        [_selectMArray addObjectsFromArray:[_cinemaMArray objectAtIndex:LSIndexGroup]];
        [_selectMArray addObjectsFromArray:[_cinemaMArray objectAtIndex:LSIndexSeatGroup]];
    }
    else if(_cinemaStatus==LSCinemaStatusAll)
    {
        [_selectMArray addObjectsFromArray:[_cinemaMArray objectAtIndex:LSIndexSeat]];
        [_selectMArray addObjectsFromArray:[_cinemaMArray objectAtIndex:LSIndexGroup]];
        [_selectMArray addObjectsFromArray:[_cinemaMArray objectAtIndex:LSIndexSeatGroup]];
        [_selectMArray addObjectsFromArray:[_cinemaMArray objectAtIndex:LSIndexNon]];
    }
    
    //如果没有影院，添加字符串占位
    if(_selectMArray.count==0)
    {
        [_selectMArray addObject:@"没有影院"];
    }
    else
    {
        [_selectMArray sortUsingSelector:@selector(distanceSort:)];
    }
    
    [_tableView reloadData];
}



#pragma mark- LSPositionSectionHeader的委托方法
- (void)LSPositionSectionHeader:(LSPositionSectionHeader *)positionSectionHeader didClickPositionButton:(UIButton *)positionButton
{
    LSSelectorView* selectorView=[[LSSelectorView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, HeightOfiPhoneX(480.0f))];
    
    CGFloat height = 0.f;
    NSArray* positionArray=nil;
    if(_cinemaStatus==LSCinemaStatusSeat)
    {
        height=(30*_seatPositionMArray.count > 160 ? 160 : 30*_seatPositionMArray.count);
        positionArray=_seatPositionMArray;
    }
    else if(_cinemaStatus==LSCinemaStatusGroup)
    {
        height=(30*_groupPositionMArray.count > 160 ? 160 : 30*_groupPositionMArray.count);
        positionArray=_groupPositionMArray;
    }
    else if(_cinemaStatus==LSCinemaStatusAll)
    {
        height=(30*_allPositionMArray.count > 160 ? 160 : 30*_allPositionMArray.count);
        positionArray=_allPositionMArray;
    }
    
    selectorView.contentFrame=CGRectMake((self.view.width-164)/2, 95, 160, height);
    selectorView.delegate=self;
    selectorView.selectIndex=_selectPositionIndex;
    selectorView.positionArray=positionArray;
    [self.navigationController.tabBarController.view addSubview:selectorView];
    [self.navigationController.tabBarController.view  bringSubviewToFront:selectorView];
    [selectorView release];
}


#pragma mark- LSSelectorView的委托方法
- (void)LSSelectorView:(LSSelectorView *)selectorView didSelectRowAtIndexPath:(NSInteger)indexPath
{
    _selectPositionIndex=indexPath;
    [_selectMArray removeAllObjects];
    
    NSString* position=[selectorView.positionArray objectAtIndex:_selectPositionIndex];
    if(_cinemaStatus==LSCinemaStatusSeat)
    {
        if(_selectPositionIndex==0)
        {
            [_selectMArray addObjectsFromArray:[_cinemaMArray objectAtIndex:LSIndexSeat]];
            [_selectMArray addObjectsFromArray:[_cinemaMArray objectAtIndex:LSIndexSeatGroup]];
        }
        else
        {
            for (LSCinema* cinema in [_cinemaMArray objectAtIndex:LSIndexSeat])
            {
                if([cinema.districtName isEqualToString:position])
                {
                    [_selectMArray addObject:cinema];
                }
            }
            for (LSCinema* cinema in [_cinemaMArray objectAtIndex:LSIndexSeatGroup])
            {
                if([cinema.districtName isEqualToString:position])
                {
                    [_selectMArray addObject:cinema];
                }
            }
        }
    }
    else if(_cinemaStatus==LSCinemaStatusGroup)
    {
        if(_selectPositionIndex==0)
        {
            [_selectMArray addObjectsFromArray:[_cinemaMArray objectAtIndex:LSIndexGroup]];
            [_selectMArray addObjectsFromArray:[_cinemaMArray objectAtIndex:LSIndexSeatGroup]];
        }
        else
        {
            for (LSCinema* cinema in [_cinemaMArray objectAtIndex:LSIndexGroup])
            {
                if([cinema.districtName isEqualToString:position])
                {
                    [_selectMArray addObject:cinema];
                }
            }
            for (LSCinema* cinema in [_cinemaMArray objectAtIndex:LSIndexSeatGroup])
            {
                if([cinema.districtName isEqualToString:position])
                {
                    [_selectMArray addObject:cinema];
                }
            }
        }
    }
    else if(_cinemaStatus==LSCinemaStatusAll)
    {
        if(_selectPositionIndex==0)
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
                    if([cinema.districtName isEqualToString:position])
                    {
                        [_selectMArray addObject:cinema];
                    }
                }
            }
        }
    }
    
    //如果没有影院，添加字符串占位
    if(_selectMArray.count==0)
    {
        [_selectMArray addObject:@"没有影院"];
    }
    else
    {
        [_selectMArray sortUsingSelector:@selector(distanceSort:)];
    }
    
    [_tableView reloadData];
}


#pragma mark- UITableView委托方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(_cinemaMArray.count==0)
        return 0;
    
    int sections=0;
    //如果有常去影院
    if(((NSArray*)[_cinemaMArray objectAtIndex:LSIndexMy]).count>0)
    {
        sections++;
    }
    sections++;
    return sections;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    LSPositionSectionHeader* positionSectionHeader = [[[LSPositionSectionHeader alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44.f)] autorelease];
    positionSectionHeader.delegate=self;
    if (section == 0)
    {
        if(((NSArray*)[_cinemaMArray objectAtIndex:LSIndexMy]).count)
        {
            positionSectionHeader.positionSectionHeaderType=LSPositionSectionHeaderTypeUsual;
            positionSectionHeader.title=@"常去的影院";
        }
        else
        {
            if(_cinemaStatus==LSCinemaStatusSeat)
            {
                positionSectionHeader.positionSectionHeaderType=LSPositionSectionHeaderTypeNear;
                positionSectionHeader.title=[_seatPositionMArray objectAtIndex:_selectPositionIndex];
            }
            else if(_cinemaStatus==LSCinemaStatusGroup)
            {
                positionSectionHeader.positionSectionHeaderType=LSPositionSectionHeaderTypeNear;
                positionSectionHeader.title=[_groupPositionMArray objectAtIndex:_selectPositionIndex];
            }
            else if(_cinemaStatus==LSCinemaStatusAll)
            {
                positionSectionHeader.positionSectionHeaderType=LSPositionSectionHeaderTypeNear;
                positionSectionHeader.title=[_allPositionMArray objectAtIndex:_selectPositionIndex];
            }
        }
    }
    else if (section == 1)
    {
        if(_cinemaStatus==LSCinemaStatusSeat)
        {
            positionSectionHeader.positionSectionHeaderType=LSPositionSectionHeaderTypeNear;
            positionSectionHeader.title=[_seatPositionMArray objectAtIndex:_selectPositionIndex];
        }
        else if(_cinemaStatus==LSCinemaStatusGroup)
        {
            positionSectionHeader.positionSectionHeaderType=LSPositionSectionHeaderTypeNear;
            positionSectionHeader.title=[_groupPositionMArray objectAtIndex:_selectPositionIndex];
        }
        else if(_cinemaStatus==LSCinemaStatusAll)
        {
            positionSectionHeader.positionSectionHeaderType=LSPositionSectionHeaderTypeNear;
            positionSectionHeader.title=[_allPositionMArray objectAtIndex:_selectPositionIndex];
        }
    }
    
    return positionSectionHeader;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count=0;
    if(section==0)
    {
        if(((NSArray*)[_cinemaMArray objectAtIndex:LSIndexMy]).count>0)
        {
            count=((NSArray*)[_cinemaMArray objectAtIndex:LSIndexMy]).count;
        }
        else
        {
            count=_selectMArray.count;
        }
    }
    else if(section==1)
    {
        count=_selectMArray.count;
    }
    return count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSCinema* cinema=nil;
    if(indexPath.section==0)
    {
        NSArray* myArray=[_cinemaMArray objectAtIndex:LSIndexMy];
        if(myArray.count>0)
        {
            cinema=[myArray objectAtIndex:indexPath.row];
        }
        else
        {
            if([[_selectMArray objectAtIndex:0] isKindOfClass:[NSString class]])
            {
                return 44.f;
            }
            else
            {
                cinema=[_selectMArray objectAtIndex:indexPath.row];
            }
        }
    }
    else if(indexPath.section==1)
    {
        if([[_selectMArray objectAtIndex:0] isKindOfClass:[NSString class]])
        {
            return 44.f;
        }
        else
        {
            cinema=[_selectMArray objectAtIndex:indexPath.row];
        }
    }
    return [LSCinemaCell heightForCinema:cinema];
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
        if(((NSArray*)[_cinemaMArray objectAtIndex:LSIndexMy]).count)
        {
            cinema=[[_cinemaMArray objectAtIndex:LSIndexMy] objectAtIndex:indexPath.row];
        }
        else
        {
            if([[_selectMArray objectAtIndex:0] isKindOfClass:[NSString class]])
            {
                LSNothingCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSNothingCell"];
                if(cell==nil)
                {
                    cell=[[[LSNothingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSNothingCell"] autorelease];
                    cell.title=[_selectMArray objectAtIndex:0];
                }
                return cell;
            }
            else
            {
                cinema=[_selectMArray objectAtIndex:indexPath.row];
            }
        }
    }
    else
    {
        if([[_selectMArray objectAtIndex:0] isKindOfClass:[NSString class]])
        {
            LSNothingCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSNothingCell"];
            if(cell==nil)
            {
                cell=[[[LSNothingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSNothingCell"] autorelease];
                cell.title=[_selectMArray objectAtIndex:0];
            }
            return cell;
        }
        else
        {
            cinema=[_selectMArray objectAtIndex:indexPath.row];
        }
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
        if(((NSArray*)[_cinemaMArray objectAtIndex:LSIndexMy]).count)
        {
            cinema=[[_cinemaMArray objectAtIndex:LSIndexMy] objectAtIndex:indexPath.row];
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
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    if(!decelerate)//是否有减速,没有减速说明是匀速拖动
//    {
//        [self soapSmooth];
//    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    [self soapSmooth];
}


#pragma mark 肥皂滑代码实现
- (void)soapSmooth
{
    NSArray* cellArray=[_tableView visibleCells];
    for(LSCinemaCell* cell in cellArray)
    {
//        NSIndexPath* indexPath=[_tableView indexPathForCell:cell];
//        LSCinema* cinema=nil;
//        if(_cinemaStatus==LSCinemaStatusOnline)
//        {
//            cinema=[_onlineCinemaMArray objectAtIndex:indexPath.row];
//        }
//        else if(_cinemaStatus==LSCinemaStatusAll)
//        {
//            cinema=[_allCinemaMArray objectAtIndex:indexPath.row];
//        }
    }
}

@end
