//
//  LSFilmsViewController.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-8-29.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSFilmsViewController.h"
#import "LSFilm.h"
#import "LSFilmInfoViewController.h"
#import "LSFilmsSchedulesByCinemaViewController.h"
#import "LSCinemasByFilmViewController.h"
#import "LSADWebViewController.h"

@interface LSFilmsViewController ()

@end

@implementation LSFilmsViewController

- (void)dealloc
{
    LSRELEASE(_advertisment)
    LSRELEASE(_showingFilmMArray)
    LSRELEASE(_willShowFilmMArray)
    
    LSRELEASE(_showingFilmListCellMArray)
    LSRELEASE(_willFilmListCellMArray)
    LSRELEASE(_showingFilmPosterCellMArray)
    LSRELEASE(_willFilmPosterCellMArray)
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
    _displayType=LSFilmDisplayTypeList;
    _filmShowStatus=LSFilmShowStatusShowing;
    
    //初始化数据数组
    _showingFilmMArray=[[NSMutableArray alloc] initWithCapacity:0];
    _willShowFilmMArray=[[NSMutableArray alloc] initWithCapacity:0];
    _showingFilmListCellMArray=[[NSMutableArray alloc] initWithCapacity:0];
    _willFilmListCellMArray=[[NSMutableArray alloc] initWithCapacity:0];
    _showingFilmPosterCellMArray=[[NSMutableArray alloc] initWithCapacity:0];
    _willFilmPosterCellMArray=[[NSMutableArray alloc] initWithCapacity:0];
    
    [self setBarButtonItemWithTitle:user.cityName imageName:@"icon_arrow_down.png" isRight:NO];
    [self setBarButtonItemWithImageName:@"btn_pic_nor.png" selectImageName:@"btn_pic_sel.png" isRight:YES];
    
    //添加通知
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeFilmsByStatus object:nil];
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeAdvertisements object:nil];
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:LSNotificationCityChanged object:nil];
    
    _segmentedControl=[[LSSegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"正在热映", @"即将上映", nil]];
    _segmentedControl.bounds=CGRectMake(0.f, 0.f, 100.f, 30.f);
    _segmentedControl.delegate=self;
    self.navigationItem.titleView=_segmentedControl;
    [_segmentedControl release];
    
    [self initRefreshControl];

    [hud show:YES];
    [messageCenter LSMCFilmsWithStatus:_filmShowStatus];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if(_showingFilmMArray!=_filmArray)
    {
        [_showingFilmMArray removeAllObjects];
    }
    if(_willShowFilmMArray!=_filmArray)
    {
        [_willShowFilmMArray removeAllObjects];
    }
    
    if(_showingFilmListCellMArray!=_filmCellArray)
    {
        [_showingFilmListCellMArray removeAllObjects];
    }
    if(_willFilmListCellMArray!=_filmCellArray)
    {
        [_willFilmListCellMArray removeAllObjects];
    }
    if(_showingFilmPosterCellMArray!=_filmCellArray)
    {
        [_showingFilmPosterCellMArray removeAllObjects];
    }
    if(_willFilmPosterCellMArray!=_filmCellArray)
    {
        [_willFilmPosterCellMArray removeAllObjects];
    }
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
    _displayType=!_displayType;
    if(_displayType==LSFilmDisplayTypeList)
    {
        self.tableView.pagingEnabled=NO;
        [self setBarButtonItemWithImageName:@"btn_list_nor.png" selectImageName:@"btn_list_sel.png" isRight:YES];
    }
    else
    {
        self.tableView.pagingEnabled=YES;
        [self setBarButtonItemWithImageName:@"btn_pic_nor.png" selectImageName:@"btn_pic_sel.png" isRight:YES];
    }
    
    [self refreshTableView];
}
- (void)refreshTableView
{
    if(_displayType==LSFilmDisplayTypeList)
    {
        if(_filmShowStatus==LSFilmShowStatusShowing)
        {
            _filmCellArray=_showingFilmListCellMArray;
            if(_filmCellArray.count>0)
            {
                [self.tableView reloadData];
            }
            else
            {
                dispatch_queue_t queue_0 = dispatch_queue_create("queue_0", NULL);
                dispatch_async(queue_0, ^{
                    
                    if(_filmArray.count>7)
                    {
                        for(int i=0;i<7;i++)
                        {
                            LSFilmListShowCell* cell=[[LSFilmListShowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSFilmListShowCell"];
                            cell.film=[_filmArray objectAtIndex:i];
                            cell.delegate=self;
                            [_filmCellArray addObject:cell];
                            [cell release];
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [self.tableView reloadData];
                            
                            for(int i=0;i<7;i++)
                            {
                                LSFilmListShowCell* cell=[_filmCellArray objectAtIndex:i];
                                //cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                                [cell.filmImageView setImageWithURL:[NSURL URLWithString:cell.film.imageURL]];
                            }
                        });
                    }
                    else
                    {
                        for(LSFilm* film in _filmArray)
                        {
                            LSFilmListShowCell* cell=[[LSFilmListShowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"LSFilmListShowCell"]];
                            cell.film=film;
                            [_filmCellArray addObject:cell];
                            [cell release];
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [self.tableView reloadData];
                            
                            for(LSFilmListShowCell* cell in _filmCellArray)
                            {
                                //cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                                [cell.filmImageView setImageWithURL:[NSURL URLWithString:cell.film.imageURL]];
                            }
                        });
                    }
                });
                dispatch_async(queue_0, ^{
                    
                    if(_filmArray.count>7)
                    {
                        for(int i=7;i<_filmArray.count;i++)
                        {
                            LSFilmListShowCell* cell=[[LSFilmListShowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"LSFilmListShowCell"]];
                            cell.film=[_filmArray objectAtIndex:i];
                            cell.delegate=self;
                            [_filmCellArray addObject:cell];
                            [cell release];
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            for(int i=7;i<_filmCellArray.count;i++)
                            {
                                LSFilmListShowCell* cell=[_filmCellArray objectAtIndex:i];
                                //cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                                [cell.filmImageView setImageWithURL:[NSURL URLWithString:cell.film.imageURL]];
                            }
                        });
                    }
                });
                dispatch_release(queue_0);
            }
        }
        else
        {
            _filmCellArray=_willFilmListCellMArray;
            if(_filmCellArray.count>0)
            {
                [self.tableView reloadData];
            }
            else
            {
                dispatch_queue_t queue_0 = dispatch_queue_create("queue_0", NULL);
                dispatch_async(queue_0, ^{
                    
                    if(_filmArray.count>7)
                    {
                        for(int i=0;i<7;i++)
                        {
                            LSFilmListWillCell* cell=[[LSFilmListWillCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSFilmListWillCell"];
                            cell.film=[_filmArray objectAtIndex:i];
                            [_filmCellArray addObject:cell];
                            [cell release];
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [self.tableView reloadData];
                            
                            for(int i=0;i<7;i++)
                            {
                                LSFilmListWillCell* cell=[_filmCellArray objectAtIndex:i];
                                [cell.filmImageView setImageWithURL:[NSURL URLWithString:cell.film.imageURL]];
                            }
                        });
                    }
                    else
                    {
                        for(LSFilm* film in _filmArray)
                        {
                            LSFilmListWillCell* cell=[[LSFilmListWillCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"LSFilmListWillCell"]];
                            cell.film=film;
                            [_filmCellArray addObject:cell];
                            [cell release];
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [self.tableView reloadData];
                            
                            for(LSFilmListWillCell* cell in _filmCellArray)
                            {
                                [cell.filmImageView setImageWithURL:[NSURL URLWithString:cell.film.imageURL]];
                            }
                        });
                    }
                });
                dispatch_async(queue_0, ^{
                    
                    if(_filmArray.count>7)
                    {
                        for(int i=7;i<_filmArray.count;i++)
                        {
                            LSFilmListWillCell* cell=[[LSFilmListWillCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"LSFilmListWillCell"]];
                            cell.film=[_filmArray objectAtIndex:i];
                            [_filmCellArray addObject:cell];
                            [cell release];
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            for(int i=7;i<_filmCellArray.count;i++)
                            {
                                LSFilmListWillCell* cell=[_filmCellArray objectAtIndex:i];
                                [cell.filmImageView setImageWithURL:[NSURL URLWithString:cell.film.imageURL]];
                            }
                        });
                    }
                });
                dispatch_release(queue_0);
            }
        }
    }
    else
    {
        if(_filmShowStatus==LSFilmShowStatusShowing)
        {
            _filmCellArray=_showingFilmPosterCellMArray;
            if(_filmCellArray.count>0)
            {
                [self.tableView reloadData];
            }
            else
            {
                dispatch_queue_t queue_0 = dispatch_queue_create("queue_0", NULL);
                dispatch_async(queue_0, ^{
                    
                    if(_filmArray.count>3)
                    {
                        for(int i=0;i<3;i++)
                        {
                            LSFilmPosterShowCell* cell=[[LSFilmPosterShowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSFilmPosterShowCell"];
                            cell.film=[_filmArray objectAtIndex:i];
                            [_filmCellArray addObject:cell];
                            [cell release];
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [self.tableView reloadData];
                            
                            for(int i=0;i<3;i++)
                            {
                                LSFilmPosterShowCell* cell=[_filmCellArray objectAtIndex:i];
                                [cell.filmImageView setImageWithURL:[NSURL URLWithString:cell.film.imageURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                    [cell.filmImageView setImageWithURL:[NSURL URLWithString:cell.film.posterURL]  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                        [cell setNeedsDisplay];
                                    }];
                                }];
                            }
                        });
                    }
                    else
                    {
                        for(LSFilm* film in _filmArray)
                        {
                            LSFilmPosterShowCell* cell=[[LSFilmPosterShowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"LSFilmPosterShowCell"]];
                            cell.film=film;
                            [_filmCellArray addObject:cell];
                            [cell release];
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [self.tableView reloadData];
                            
                            for(LSFilmPosterShowCell* cell in _filmCellArray)
                            {
                                [cell.filmImageView setImageWithURL:[NSURL URLWithString:cell.film.imageURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                    [cell.filmImageView setImageWithURL:[NSURL URLWithString:cell.film.posterURL]  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                        [cell setNeedsDisplay];
                                    }];
                                }];
                            }
                        });
                    }
                });
                dispatch_async(queue_0, ^{
                    
                    if(_filmArray.count>3)
                    {
                        for(int i=3;i<_filmArray.count;i++)
                        {
                            LSFilmPosterShowCell* cell=[[LSFilmPosterShowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"LSFilmPosterShowCell"]];
                            cell.film=[_filmArray objectAtIndex:i];
                            [_filmCellArray addObject:cell];
                            [cell release];
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            for(int i=3;i<_filmCellArray.count;i++)
                            {
                                LSFilmPosterShowCell* cell=[_filmCellArray objectAtIndex:i];
                                [cell.filmImageView setImageWithURL:[NSURL URLWithString:cell.film.posterURL]  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                    [cell setNeedsDisplay];
                                }];
                            }
                        });
                    }
                });
                dispatch_release(queue_0);
            }
        }
        else
        {
            _filmCellArray=_willFilmPosterCellMArray;
            if(_filmCellArray.count>0)
            {
                [self.tableView reloadData];
            }
            else
            {
                dispatch_queue_t queue_0 = dispatch_queue_create("queue_0", NULL);
                dispatch_async(queue_0, ^{
                    
                    if(_filmArray.count>3)
                    {
                        for(int i=0;i<3;i++)
                        {
                            LSFilmPosterWillCell* cell=[[LSFilmPosterWillCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSFilmPosterWillCell"];
                            cell.film=[_filmArray objectAtIndex:i];
                            [_filmCellArray addObject:cell];
                            [cell release];
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [self.tableView reloadData];
                            
                            for(int i=0;i<3;i++)
                            {
                                LSFilmPosterWillCell* cell=[_filmCellArray objectAtIndex:i];
                                [cell.filmImageView setImageWithURL:[NSURL URLWithString:cell.film.imageURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                    [cell.filmImageView setImageWithURL:[NSURL URLWithString:cell.film.posterURL]  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                        [cell setNeedsDisplay];
                                    }];
                                }];
                            }
                        });
                    }
                    else
                    {
                        for(LSFilm* film in _filmArray)
                        {
                            LSFilmPosterWillCell* cell=[[LSFilmPosterWillCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"LSFilmPosterWillCell"]];
                            cell.film=film;
                            [_filmCellArray addObject:cell];
                            [cell release];
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [self.tableView reloadData];
                            
                            for(LSFilmPosterWillCell* cell in _filmCellArray)
                            {
                                [cell.filmImageView setImageWithURL:[NSURL URLWithString:cell.film.imageURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                    [cell.filmImageView setImageWithURL:[NSURL URLWithString:cell.film.posterURL]  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                        [cell setNeedsDisplay];
                                    }];
                                }];
                            }
                        });
                    }
                });
                dispatch_async(queue_0, ^{
                    
                    if(_filmArray.count>3)
                    {
                        for(int i=3;i<_filmArray.count;i++)
                        {
                            LSFilmPosterWillCell* cell=[[LSFilmPosterWillCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"LSFilmPosterWillCell"]];
                            cell.film=[_filmArray objectAtIndex:i];
                            [_filmCellArray addObject:cell];
                            [cell release];
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            for(int i=3;i<_filmCellArray.count;i++)
                            {
                                LSFilmPosterWillCell* cell=[_filmCellArray objectAtIndex:i];
                                [cell.filmImageView setImageWithURL:[NSURL URLWithString:cell.film.posterURL]  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                    [cell setNeedsDisplay];
                                }];
                            }
                        });
                    }
                });
                dispatch_release(queue_0);
            }
        }
    }
}
- (void)refreshControlEventValueChanged
{
    [hud show:YES];
    [messageCenter LSMCFilmsWithStatus:_filmShowStatus];
}
- (void)refreshBecauseInternet
{
    [hud show:YES];
    [messageCenter LSMCFilmsWithStatus:_filmShowStatus];
}


#pragma mark- 通知中心消息
- (void)lsHttpRequestNotification:(NSNotification*)notification
{
    [hud hide:YES];//任何的通知都会导致隐藏
    
    if(LSiOS6)
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
            if([notification.name isEqualToString:lsRequestTypeFilmsByStatus])
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
        
        if([notification.name isEqualToString:lsRequestTypeFilmsByStatus])
        {
            dispatch_queue_t queue_0=dispatch_queue_create("queue_0", NULL);
            dispatch_async(queue_0, ^{
                
                id result=[notification.object objectForKey:lsRequestResult];
                int mark=[[notification.object objectForKey:lsRequestMark] intValue];
                NSArray* tmpArray=result;
                
                if(mark==LSFilmShowStatusShowing)
                {
                    [_showingFilmMArray removeAllObjects];
                    for(NSDictionary* dic in tmpArray)
                    {
                        LSFilm* film=[[LSFilm alloc] initWithDictionary:dic];
                        [_showingFilmMArray addObject:film];
                        [film release];
                    }
                }
                else if(mark==LSFilmShowStatusWillShow)
                {
                    [_willShowFilmMArray removeAllObjects];
                    for(NSDictionary* dic in tmpArray)
                    {
                        LSFilm* film=[[LSFilm alloc] initWithDictionary:dic];
                        [_willShowFilmMArray addObject:film];
                        [film release];
                    }
                }
                
                if(_filmShowStatus==LSFilmShowStatusShowing)
                {
                    _filmArray=_showingFilmMArray;
                }
                else if(_filmShowStatus==LSFilmShowStatusWillShow)
                {
                    _filmArray=_willShowFilmMArray;
                }
                
                if(mark==_filmShowStatus)
                {
                    dispatch_async(dispatch_get_main_queue(),^{
                        
                        [self refreshTableView];
                    });
                }

                if(_advertisment==nil)
                {
                    [messageCenter LSMCAdvertisements];
                }
            });
            dispatch_release(queue_0);
        }
        else if([notification.name isEqualToString:lsRequestTypeAdvertisements])
        {
            _advertisment=[[LSAdvertisment alloc] initWithDictionary:notification.object];
            [self.tableView reloadData];
        }
    }
}

#pragma mark- UITableView的委托方法
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return _advertisment==nil?0.f:50.f;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(_advertisment!=nil)
    {
        if(_adView==nil)
        {
            _adView=[[[LSAdView alloc] initWithFrame:CGRectZero] autorelease];
            _adView.delegate=self;
        }
        _adView.advertisment=_advertisment;
        [_adView setNeedsLayout];
        return _adView;
    }
    else
    {
        return nil;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _filmArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_displayType==LSFilmDisplayTypeList)
    {
        return 90.f;
    }
    else
    {
        return 400.f;
    }
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_filmCellArray objectAtIndex:indexPath.row];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSFilmInfoViewController* filmInfoViewController=[[LSFilmInfoViewController alloc] init];
    filmInfoViewController.hidesBottomBarWhenPushed=YES;
    filmInfoViewController.film=[_filmArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:filmInfoViewController animated:YES];
    [filmInfoViewController release];
}

#pragma mark- LSFilmListShowCell的委托方法
- (void)LSFilmListShowCell:(LSFilmListShowCell *)filmListShowCell didClickQuickBuyView:(LSQuickBuyView *)quickBuyView
{
    LSCinemasByFilmViewController* cinemasByFilmViewController=[[LSCinemasByFilmViewController alloc] init];
    cinemasByFilmViewController.film=filmListShowCell.film;
    [self.navigationController pushViewController:cinemasByFilmViewController animated:YES];
    [cinemasByFilmViewController release];
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
    [self.tableView reloadData];
}

#pragma mark- LSSegmentedControl委托方法
- (void)LSSegmentedControl:(LSSegmentedControl *)segmentedControl didSelectSegmentIndex:(NSInteger)index
{
    _filmShowStatus=index;
    
    if(_filmShowStatus==LSFilmShowStatusShowing)
    {
        _filmArray=_showingFilmMArray;
    }
    else if(_filmShowStatus==LSFilmShowStatusWillShow)
    {
        _filmArray=_willShowFilmMArray;
    }
    
    if(_filmArray.count>0)
    {
        [self refreshTableView];
    }
    else
    {
        [hud show:YES];
        [messageCenter LSMCFilmsWithStatus:_filmShowStatus];
    }
}

#pragma mark- LSCitiesViewController的委托方法
- (void)LSCitiesViewControllerDidSelect
{
    [self dismissViewControllerAnimated:YES completion:^{
        LSRELEASE(_advertisment);
        
        [self setBarButtonItemWithTitle:user.cityName imageName:@"" isRight:NO];
        
        [hud show:YES];
        [messageCenter LSMCFilmsWithStatus:_filmShowStatus];
    }];
}

@end
