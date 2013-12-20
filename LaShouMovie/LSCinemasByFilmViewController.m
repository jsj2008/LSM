//
//  LSCinemasByFilmViewController.m
//  LaShouMovie
//
//  Created by Li XiangYu on 13-9-14.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSCinemasByFilmViewController.h"

#import "LSCinema.h"
#import "LSCinemaCell.h"
#import "LSSchedulesByFilmCinemaViewController.h"
#import "LSNothingCell.h"

typedef enum
{
    LSIndexMy=0,
    LSIndexSeat=1,
    LSIndexGroup=2,
    LSIndexSeatGroup=3,
    LSIndexNon=4
}LSIndex;

@interface LSCinemasByFilmViewController ()

@end

@implementation LSCinemasByFilmViewController

@synthesize film=_film;

- (void)dealloc
{
    self.film=nil;
    LSRELEASE(_cinemaMArray)
    
    LSRELEASE(_districtMArray)
    LSRELEASE(_areaMArray)
    
    LSRELEASE(_selectMArray)
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
    self.title=_film.filmName;
    
    //实例化数组
    _cinemaMArray=[[NSMutableArray alloc] initWithCapacity:0];
    
    _districtMArray=[[NSMutableArray alloc] initWithCapacity:0];
    _areaMArray=[[NSMutableArray alloc] initWithCapacity:0];

    _selectMArray=[[NSMutableArray alloc] initWithCapacity:0];
    
    //添加通知
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeFilmCinemasByFilmID object:nil];
    
    _cinemaStatusView=[[LSCinemaStatusView alloc] initWithFrame:CGRectMake(0, 44.f, self.view.width, 44.f)];
    _cinemaStatusView.delegate=self;
    [self.view addSubview:_cinemaStatusView];
    [_cinemaStatusView release];
    
    [hud show:YES];
    [messageCenter LSMCFilmCinemasWithFilmID:_film.filmID];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                
                //如果没有影院，添加字符串占位
                if(_selectMArray.count==0)
                {
                    [_selectMArray addObject:@"暂无影院"];
                }
                else
                {
                    [_selectMArray sortUsingSelector:@selector(distanceSort:)];
                }

                //可以首先刷新视图
                dispatch_async(dispatch_get_main_queue(),^{
                    
                    [self.tableView reloadData];
                });
                
                
                NSMutableDictionary* seatDistrictMDic=[NSMutableDictionary dictionaryWithCapacity:0];
                //可订座影院位置数组
                for (LSCinema* cinema in [_cinemaMArray objectAtIndex:LSIndexSeat])
                {
                    [seatDistrictMDic setObject:[NSNumber numberWithInt:[[seatDistrictMDic objectForKey:cinema.districtName] intValue]+1] forKey:cinema.districtName];
                }
                for (LSCinema* cinema in [_cinemaMArray objectAtIndex:LSIndexSeatGroup])
                {
                    [seatDistrictMDic setObject:[NSNumber numberWithInt:[[seatDistrictMDic objectForKey:cinema.districtName] intValue]+1] forKey:cinema.districtName];
                }
                
                NSMutableDictionary* groupDistrictMDic=[NSMutableDictionary dictionaryWithCapacity:0];
                //可团购影院位置数组
                for (LSCinema* cinema in [_cinemaMArray objectAtIndex:LSIndexGroup])
                {
                    [groupDistrictMDic setObject:[NSNumber numberWithInt:[[groupDistrictMDic objectForKey:cinema.districtName] intValue]+1] forKey:cinema.districtName];
                }
                for (LSCinema* cinema in [_cinemaMArray objectAtIndex:LSIndexSeatGroup])
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
    }
}


#pragma mark- LSStatusView委托方法
- (void)LSCinemaStatusView:(LSCinemaStatusView *)cinemaStatusView didSelectCinemaStatus:(LSCinemaStatus)status
{
    [_selectMArray removeAllObjects];
    _selectPositionIndex=0;
    _cinemaStatus=status;
    
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
    else
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
    
    [self.tableView reloadData];
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
        positionArray=_districtMArray;
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
    if(((NSArray*)[_cinemaMArray objectAtIndex:LSIndexMy]).count)
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
    LSPositionSectionHeader* positionSectionHeader = [[LSPositionSectionHeader alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
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
    
    return [positionSectionHeader autorelease];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count=0;
    if(section==0)
    {
        if(((NSArray*)[_cinemaMArray objectAtIndex:LSIndexMy]).count)
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
    
    LSSchedulesByFilmCinemaViewController* schedulesByFilmCinemaViewController=[[LSSchedulesByFilmCinemaViewController alloc] init];
    schedulesByFilmCinemaViewController.film=_film;
    
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
    
    schedulesByFilmCinemaViewController.cinema=cinema;
    schedulesByFilmCinemaViewController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:schedulesByFilmCinemaViewController animated:YES];
    [schedulesByFilmCinemaViewController release];
}


@end