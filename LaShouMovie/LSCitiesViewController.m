//
//  LSCitiesViewController.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-6.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSCitiesViewController.h"
#import "LSCity.h"
#import "LSCityCell.h"

@interface LSCitiesViewController ()

@end

@implementation LSCitiesViewController

@synthesize delegate=_delegate;

#pragma mark- 生命周期
- (void)dealloc
{
    LSRELEASE(_indexPath)
    
    LSRELEASE(_cityMArray)
    LSRELEASE(_titleMArray)
    LSRELEASE(_numberMArray)
    [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"切换城市";
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    
    self.leftBarButtonSystemItem=UIBarButtonSystemItemStop;

    _cityMArray=[[NSMutableArray alloc] initWithCapacity:0];
    _titleMArray=[[NSMutableArray alloc] initWithCapacity:0];
    _numberMArray=[[NSMutableArray alloc] initWithCapacity:0];
    
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeCities object:nil];

    [self initRefreshControl];
    [self refreshControlEventValueChanged];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    //设置导航字体颜色
    for (UIView* subview in [self.tableView subviews])
    {
        if ([subview isKindOfClass:NSClassFromString(@"UITableViewIndex")])
        {
            if([subview respondsToSelector:@selector(setIndexColor:)])
            {
                [subview performSelector:@selector(setIndexColor:) withObject:LSColorTextRed];
            }
        }
    }
}

#pragma mark- 重载方法
- (void)leftBarButtonItemClick:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)refreshControlEventValueChanged
{
    [hud show:YES];
    [messageCenter LSMCCities];
}

#pragma mark- 消息中心通知
- (void)lsHttpRequestNotification:(NSNotification*)notification
{
    [hud hide:YES];
    if(LSiOS6 && self.refreshControl.isRefreshing)
    {
        [self.refreshControl endRefreshing];
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
            //状态
            return;
        }
        
        if([notification.object isKindOfClass:[LSError class]])
        {
            //错误
            return;
        }
        
        if([notification.name isEqualToString:lsRequestTypeCities])
        {
            [_cityMArray removeAllObjects];
            [_titleMArray removeAllObjects];
            [_numberMArray removeAllObjects];
            
            if(user.locationCityID!=nil && user.locationCityName!=nil)
            {
                NSMutableArray* locationMArray=[[NSMutableArray alloc] initWithCapacity:0];
                
                LSCity* city=[[LSCity alloc] init];
                city.cityID=user.locationCityID;
                city.cityName=user.locationCityName;
                [locationMArray addObject:city];
                [city release];
                
                [_cityMArray addObject:locationMArray];
                [locationMArray release];
                
                //记录定位城市信息
                [_titleMArray addObject:@"定位"];
                [_numberMArray addObject:[NSNumber numberWithInt:locationMArray.count]];
            }
            
            NSArray* hotArray=[notification.object objectForKey:@"hots"];
            NSMutableArray* hotMArray=[[NSMutableArray alloc] initWithCapacity:0];
            for(NSDictionary* dic in hotArray)
            {
                LSCity* city=[[LSCity alloc] initWithDictionary:dic];
                [hotMArray addObject:city];
                [city release];
            }
            [_cityMArray addObject:hotMArray];
            [hotMArray release];
            
            //记录热门城市信息
            [_titleMArray addObject:@"热门"];
            [_numberMArray addObject:[NSNumber numberWithInt:hotMArray.count]];
            
            
            //因为返回的城市是无序的，因此需要首先生成数组，然后排序
            //排序之后再按照拼音首字母分成a~z的若干组
            NSArray* cityArray=[notification.object objectForKey:@"cities"];
            NSMutableArray* tmpCityMArray=[[[NSMutableArray alloc] initWithCapacity:0] autorelease];
            for(int i=0;i<cityArray.count;i++)
            {
                LSCity* city=[[LSCity alloc] initWithDictionary:[cityArray objectAtIndex:i]];
                [tmpCityMArray addObject:city];
                [city release];
            }
            [tmpCityMArray sortUsingSelector:@selector(cityNameSort:)];
            
            NSMutableArray* cityMArray=[[NSMutableArray alloc] initWithCapacity:0];
            NSString* curTitle=nil;
            int curNumber=0;
            for(LSCity* city in tmpCityMArray)
            {
                if(curTitle!=nil)
                {
                    //如果是同一组
                    if([[city.pinyin substringToIndex:1] isEqualToString:curTitle])
                    {
                        [cityMArray addObject:city];
                        curNumber++;//同组计数+1
                    }
                    else//如果不同一组
                    {
                        [_cityMArray addObject:cityMArray];
                        [cityMArray release];
                        [_numberMArray addObject:[NSNumber numberWithInt:curNumber]];
                        
                        
                        cityMArray=[[NSMutableArray alloc] initWithCapacity:0];
                        curTitle=[city.pinyin substringToIndex:1];
                        
                        
                        [cityMArray addObject:city];
                        [_titleMArray addObject:curTitle];
                        curNumber=1;
                    }
                }
                else
                {
                    cityMArray=[[NSMutableArray alloc] initWithCapacity:0];
                    curTitle=[city.pinyin substringToIndex:1];
                    
                    [cityMArray addObject:city];
                    [_titleMArray addObject:curTitle];
                    curNumber++;
                }
            }
            [_cityMArray addObject:cityMArray];
            [cityMArray release];
            [_numberMArray addObject:[NSNumber numberWithInt:curNumber]];
            

            [self.tableView reloadData];
        }
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _titleMArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel* headerLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    headerLabel.backgroundColor=LSColorBackgroundGray;
    headerLabel.textColor = LSColorTextGray;
    headerLabel.font = LSFontSectionHeader;
    if([[_titleMArray objectAtIndex:section] isEqualToString:@"定位"])
    {
        headerLabel.text = @"   定位城市";
    }
    else if([[_titleMArray objectAtIndex:section] isEqualToString:@"热门"])
    {
        headerLabel.text = @"   热门城市";
    }
//    else if([[_titleMArray objectAtIndex:section] isEqualToString:@"其他"])
//    {
//        headerLabel.text = @"   其他";
//    }
    else
    {
        headerLabel.text = [NSString stringWithFormat:@"   %@",[_titleMArray objectAtIndex:section]];
    }
    
    return headerLabel;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_numberMArray objectAtIndex:section] intValue];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSCityCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSCityCell"];
    if(cell==nil)
    {
        cell=[[[LSCityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSCityCell"] autorelease];
    }
    
    LSCity* city=[[_cityMArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if(_indexPath!=nil)
    {
        if(_indexPath.section==indexPath.section && _indexPath.row==indexPath.row)
        {
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
    }
    else
    {
        if([city.cityID isEqual:user.cityID])
        {
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
    }
    
    cell.textLabel.text=city.cityName;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //重复的点击需要首先取消之前的操作
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    //
    _indexPath=[indexPath retain];

    for(UITableViewCell* cell in tableView.visibleCells)
    {
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    
    UITableViewCell* cell=[tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType=UITableViewCellAccessoryCheckmark;
    
    LSCity* city=[[_cityMArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    user.cityID=city.cityID;
    user.cityName=city.cityName;
    
    if([LSSave saveUser])
    {
        LSLOG(@"已经保存了User信息");
    }
    
    [_delegate LSCitiesViewControllerDidSelect];
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _titleMArray;
}

@end
