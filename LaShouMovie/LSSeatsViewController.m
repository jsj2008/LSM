//
//  LSSeatsViewController.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-8-29.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSSeatsViewController.h"
#import "LSNavigationController.h"

@interface LSSeatsViewController ()

@end

@implementation LSSeatsViewController

@synthesize cinema=_cinema;
@synthesize film=_film;
@synthesize schedule=_schedule;
@synthesize scheduleArray=_scheduleArray;

#pragma mark- 生命周期

- (void)dealloc
{
    self.cinema=nil;
    self.film=nil;
    self.schedule=nil;
    self.scheduleArray=nil;
    LSRELEASE(_order)
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
    self.title=@"选座";
    
    _order=[[LSOrder alloc] init];
    _order.cinema=_cinema;
    _order.film=_film;
    _order.schedule=_schedule;
    
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeSeatsByDate_CinemaID_HallID object:nil];
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeSeatSelectSeatsByApiSource_ScheduleID_SectionID object:nil];
    
    _seatsInfoView=[[LSSeatsInfoView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 106)];
    _seatsInfoView.order=_order;
    _seatsInfoView.delegate=self;
    [self.view addSubview:_seatsInfoView];
    [_seatsInfoView release];
    
    _seatPlaceView = [[LSSeatPlaceView alloc] initWithFrame:CGRectMake(0, 106, self.view.width, HeightOfiPhoneX(480-20-44-106-44))];
    //_seatPlaceView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _seatPlaceView.order=_order;
    _seatPlaceView.delegate=self;
    [self.view addSubview:_seatPlaceView];
    [_seatPlaceView release];
    
    _switchScheduleView = [[LSSwitchScheduleView alloc] initWithFrame:CGRectMake(0, HeightOfiPhoneX(480-20-44-44), self.view.width, _scheduleArray.count*44+44>HeightOfiPhoneX(480-20-44)?HeightOfiPhoneX(480-20-44):_scheduleArray.count*44+44)];
    _switchScheduleView.scheduleArray=_scheduleArray;
    _switchScheduleView.selectIndex=[_scheduleArray indexOfObject:_schedule];
    _switchScheduleView.delegate=self;
    [self.view addSubview:_switchScheduleView];
    [_switchScheduleView release];
    
    [hud show:YES];
    [messageCenter LSMCSeatsWithDate:_schedule.startDate cinemaID:_cinema.cinemaID hallID:_schedule.hall.hallID mark:[_scheduleArray indexOfObject:_schedule]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- 私有方法
//判断座位是否合格
- (BOOL)checkSeatArrayByRules:(NSArray*)seatArray
{
    //判断是否在同一行
    int currentRow=((LSSeat*)[seatArray objectAtIndex:0]).rowID;
    for (LSSeat* seat in seatArray)
    {
        if(currentRow!=seat.rowID)
        {
            [LSAlertView showWithTag:0 title:nil message:@"请选择同一行座位" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            return NO;
        }
    }
    
    //检查两边是否留有单个空位
    {
        BOOL isLeftLegal=YES;//假设左侧合法
        LSSeat* firstSeat=[seatArray objectAtIndex:0];
        id object=[[_order.section.seatDictionary objectForKey:[NSNumber numberWithInt:firstSeat.rowID]] objectForKey:[NSNumber numberWithFloat:firstSeat.columnID-1]];
        if(object!=NULL)//如果左边确实有座位
        {
            LSSeat* leftSeat=object;
            if(leftSeat.seatStatus!=LSSeatStatusSold && leftSeat.seatStatus!=LSSeatStatusUnable)//如果左边座位没有卖出、没有损坏
            {
                object=[[_order.section.seatDictionary objectForKey:[NSNumber numberWithInt:leftSeat.rowID]] objectForKey:[NSNumber numberWithFloat:leftSeat.columnID-1]];
                if(object!=NULL)//如果左边的左边确实有座位
                {
                    LSSeat* leftleftSeat=object;
                    if(leftleftSeat.seatStatus==LSSeatStatusSold || leftleftSeat.seatStatus==LSSeatStatusUnable)//如果左左边座位被卖出、损坏
                    {
                        isLeftLegal=NO;
                    }
                }
                else
                {
                    isLeftLegal=NO;
                }
            }
        }
        
        if(!isLeftLegal)
        {
            [LSAlertView showWithTag:0 title:nil message:@"请不要留左边单个座位" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            return NO;
        }
    }
    {
        BOOL isrightLegal=YES;//假设右边合法
        LSSeat* lastSeat=[seatArray lastObject];
        id object=[[_order.section.seatDictionary objectForKey:[NSNumber numberWithInt:lastSeat.rowID]] objectForKey:[NSNumber numberWithFloat:lastSeat.columnID+1]];
        if(object!=NULL)//如果右边确实有座位
        {
            LSSeat* rightSeat=object;
            if(rightSeat.seatStatus!=LSSeatStatusSold && rightSeat.seatStatus!=LSSeatStatusUnable)//如果右边座位没有卖出、没有损坏
            {
                object=[[_order.section.seatDictionary objectForKey:[NSNumber numberWithInt:rightSeat.rowID]] objectForKey:[NSNumber numberWithFloat:rightSeat.columnID+1]];
                if(object!=NULL)//如果左边的左边确实有座位
                {
                    LSSeat* rightrightSeat=object;
                    if(rightrightSeat.seatStatus==LSSeatStatusSold || rightrightSeat.seatStatus==LSSeatStatusUnable)//如果右右边座位被卖出、损坏
                    {
                        isrightLegal=NO;
                    }
                }
                else
                {
                    isrightLegal=NO;
                }
            }
        }
        
        if(!isrightLegal)
        {
            [LSAlertView showWithTag:0 title:nil message:@"请不要留右边单个座位" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            return NO;
        }
    }
    
    //检查是否留有单个间隔座位
    int currentColumn=((LSSeat*)[seatArray objectAtIndex:0]).columnID;
    for (int i=0;i<seatArray.count;i++)
    {
        LSSeat* seat=[seatArray objectAtIndex:i];
        if(currentColumn!=seat.columnID)//不是连续的行号，需要判断间隔位置的状态
        {
            BOOL isCanNotSelect=YES;//假设中间的间隔是合法
            id object=[[_order.section.seatDictionary objectForKey:[NSNumber numberWithInt:currentRow]] objectForKey:[NSNumber numberWithFloat:currentColumn]];
            if(object!=NULL && object!=nil)//如果中间确实有座位
            {
                LSSeat* currentSeat=object;
                if(currentSeat.originSeatStatus!=LSSeatStatusSold && currentSeat.originSeatStatus!=LSSeatStatusUnable)//如果这个座位没有卖出、没有损坏
                {
                    //
                    //以下判断以中间间隔至少两个座位为基础
                    //
                    object=[[_order.section.seatDictionary objectForKey:[NSNumber numberWithInt:currentRow]] objectForKey:[NSNumber numberWithFloat:currentColumn-1]];
                    if(object!=NULL && object!=nil)//如果左边确实有座位
                    {
                        LSSeat* leftSeat=object;
                        if(leftSeat.seatStatus==LSSeatStatusSelect || leftSeat.seatStatus==LSSeatStatusSold || leftSeat.seatStatus==LSSeatStatusUnable)//如果左边座位被选择、被卖出、被损坏
                        {
                            object=[[_order.section.seatDictionary objectForKey:[NSNumber numberWithInt:currentRow]] objectForKey:[NSNumber numberWithFloat:currentColumn+1]];
                            if(object!=NULL && object!=nil)//如果右边确实有座位
                            {
                                LSSeat* rightSeat=object;
                                if(rightSeat.seatStatus==LSSeatStatusSelect || rightSeat.seatStatus==LSSeatStatusSold || rightSeat.seatStatus==LSSeatStatusUnable)//如果右边座位被选择、被卖出、被损坏
                                {
                                    isCanNotSelect=NO;
                                }
                            }
                            else//如果右边没有座位，说明右边是走廊
                            {
                                isCanNotSelect=NO;
                            }
                        }
                    }
                    else//如果左边没有座位，说明左边是走廊
                    {
                        object=[[_order.section.seatDictionary objectForKey:[NSNumber numberWithInt:currentRow]] objectForKey:[NSNumber numberWithFloat:currentColumn+1]];
                        if(object!=NULL && object!=nil)//如果右边确实有座位
                        {
                            LSSeat* rightSeat=object;
                            if(rightSeat.seatStatus==LSSeatStatusSelect || rightSeat.seatStatus==LSSeatStatusSold || rightSeat.seatStatus==LSSeatStatusUnable)//如果右边座位被选择、被卖出、被损坏
                            {
                                isCanNotSelect=NO;
                            }
                        }
                        else//如果右边没有座位，说明右边是走廊
                        {
                            isCanNotSelect=NO;
                        }
                    }
                }
            }
            
            if(!isCanNotSelect)
            {
                [LSAlertView showWithTag:0 title:nil message:@"请不要留中间单个座位" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                return NO;
            }
            
            i--;
        }
        
        currentColumn++;
    }
    
    return YES;
}

- (void)makeBookViewController
{
    LSCreateOrderViewController* createOrderViewController=[[LSCreateOrderViewController alloc] init];
    createOrderViewController.order=_order;
    createOrderViewController.delegate=self;
    [self.navigationController pushViewController:createOrderViewController animated:YES];
    [createOrderViewController release];
}

#pragma mark- 通知中心消息
- (void)lsHttpRequestNotification:(NSNotification*)notification
{
    if([self checkIsNotEmpty:notification])
    {
        if([notification.object isEqual:lsRequestFailed])
        {
            [hud hide:YES];
            //超时
            return;
        }
        
        if([notification.object isKindOfClass:[LSStatus class]])
        {
            [hud hide:YES];
            if([notification.name isEqualToString:lsRequestTypeSeatsByDate_CinemaID_HallID] || [notification.name isEqualToString:lsRequestTypeSeatSelectSeatsByApiSource_ScheduleID_SectionID])
            {
                LSStatus* status=notification.object;
                [LSAlertView showWithTag:-1 title:nil message:status.message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            }
            //状态
            return;
        }
        
        if([notification.object isKindOfClass:[LSError class]])
        {
            [hud hide:YES];
            //错误
            return;
        }
        
        if([notification.name isEqualToString:lsRequestTypeSeatsByDate_CinemaID_HallID])
        {
            //数据格式
            //(
            //    {
            //        "api_source" = 8;
            //        maxTicketNum = 4;
            //        seats = ();
            //        sectionId = 01;
            //        sectionName = "10\U53f7\U5385";
            //    }
            //)
            
            dispatch_queue_t queue_0=dispatch_queue_create("queue_0", NULL);
            dispatch_async(queue_0, ^{
                
                int mark=[[notification.object objectForKey:lsRequestMark] intValue];
                if(mark==[_scheduleArray indexOfObject:_schedule])//确实是当前请求
                {
                    NSArray* tmpArray=[notification.object objectForKey:lsRequestResult];
                    
                    if(tmpArray.count>0)
                    {
                        NSMutableArray* sectionMArray=[NSMutableArray arrayWithCapacity:0];
                        for(NSDictionary* dic in tmpArray)
                        {
                            LSSection* section=[[LSSection alloc] initWithDictionary:dic];
                            [sectionMArray addObject:section];
                            [section release];
                        }
                        _order.sectionArray=sectionMArray;
                        _selectSectionIndex=0;
                        _order.section=[_order.sectionArray objectAtIndex:_selectSectionIndex];
                        
                        [messageCenter LSMCSeatSelectSeatsWithApiSource:_order.section.apiSource scheduleID:_schedule.scheduleID sectionID:_order.section.sectionID mark:mark mark2:_selectSectionIndex];
                    }
                }
            });
            dispatch_release(queue_0);
        }
        else if([notification.name isEqualToString:lsRequestTypeSeatSelectSeatsByApiSource_ScheduleID_SectionID])
        {
            //(
            //   {
            //      columnId = 10;
            //      rowId = 10;
            //   }
            //)

            dispatch_queue_t queue_0=dispatch_queue_create("queue_0", NULL);
            dispatch_async(queue_0, ^{
                
                int mark=[[notification.object objectForKey:lsRequestMark] intValue];//标识排期
                int mark2=[[notification.object objectForKey:lsRequestMark2] intValue];//标识区域
                
                if(mark==[_scheduleArray indexOfObject:_schedule])//确实是当前请求
                {
                    if(mark2==_selectSectionIndex)
                    {
                        [_order.section makeSeatDictionary];//生成座位字典
                        
                        NSArray* tmpArray=[notification.object objectForKey:lsRequestResult];
                        for(NSDictionary* dic in tmpArray)
                        {
                            LSSeat* _seat=[[LSSeat alloc] initWithDictionary:dic];
                            
                            LSSeat* seat=[[_order.section.seatDictionary objectForKey:[NSNumber numberWithInt:_seat.rowID]] objectForKey:[NSNumber numberWithFloat:_seat.columnID]];
                            seat.isSold=YES;
                            
                            [_seat release];
                        }
                        
                        dispatch_async(dispatch_get_main_queue(),^{
                            
                            [_seatPlaceView setNeedsLayout];
                            [_seatsInfoView setNeedsDisplay];
                            
                            [hud hide:YES];
                        });
                    }
                }
            });
            dispatch_release(queue_0);
        }
    }
}

#pragma mark- LSSwitchScheduleView的委托方法
- (void)LSSwitchScheduleView:(LSSwitchScheduleView *)switchScheduleView didSelectRowAtIndexPath:(NSInteger)indexPath
{
    if(![self.schedule isEqual:[_scheduleArray objectAtIndex:indexPath]])
    {
        self.schedule=[_scheduleArray objectAtIndex:indexPath];
        
        _order.schedule=_schedule;
        [_seatsInfoView setNeedsDisplay];
        
        _order.schedule=_schedule;
        _order.selectSeatArray=nil;
        
    }
    
    
    
    
    
    [hud show:YES];
    [messageCenter LSMCSeatsWithDate:_schedule.startDate cinemaID:_cinema.cinemaID hallID:_schedule.hall.hallID mark:[_scheduleArray indexOfObject:_schedule]];
}


#pragma mark- LSSeatPlaceView的委托方法
- (void)LSSeatPlaceView:(LSSeatPlaceView *)seatPlaceView didChangeSelectSeatArray:(NSArray *)selectSeatArray
{
    if(selectSeatArray!=nil)
    {
        _order.selectSeatArray=selectSeatArray;
        
        dispatch_async(dispatch_get_main_queue(),^{
            
            [_seatsInfoView setNeedsDisplay];
        });
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(),^{
            
            [LSAlertView showWithView:self.view message:@"当前已经选择最多座位" time:2.f];
        });
    }
}

#pragma mark- LSSeatsInfoView的委托方法
- (void)LSSeatsInfoView:(LSSeatsInfoView *)seatsInfoView didClickConfirmButtonView:(LSConfirmButtonView *)confirmButtonView
{
    if(_order.selectSeatArray.count>0)
    {
        //座位规则的验证
        if(![self checkSeatArrayByRules:_order.selectSeatArray])
        {
            return;
        }
        
        if(user.userID!=nil)
        {
            [self makeBookViewController];
        }
        else
        {
            //在确定按钮的时候首先保证用户是已经登陆的
            LSLoginViewController* loginViewController=[[LSLoginViewController alloc] init];
            loginViewController.internetStatusRemindType=LSInternetStatusRemindTypeAlert;
            loginViewController.delegate=self;
            
            LSNavigationController* navigationController=[[LSNavigationController alloc] initWithRootViewController:loginViewController];
            [self presentViewController:navigationController animated:YES completion:^{}];
            
            [loginViewController release];
            [navigationController release];
        }
    }
    else
    {
        [LSAlertView showWithTag:0 title:nil message:@"还没有选择座位" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    }
}

#pragma mark- LSLoginViewController的委托方法
- (void)LSLoginViewControllerDidLoginByType:(LSLoginType)loginType
{
    [self dismissModalViewControllerAnimated:YES];
    if(loginType!=LSLoginTypeNon)
    {
        [self makeBookViewController];
    }
}

#pragma mark- LSCreateOrderViewController的委托方法
- (void)LSCreateOrderViewControllerDidCreateOrder
{
    [self.navigationController popToViewController:self animated:YES];
    [hud show:YES];
    
    dispatch_queue_t queue_0=dispatch_queue_create("queue_0", NULL);
    dispatch_async(queue_0, ^{
        
        _order.originTotalPrice=nil;
        _order.totalPrice=nil;
        _order.selectSeatArray=nil;
        _order.section=[_order.sectionArray objectAtIndex:_selectSectionIndex];
        
        _order.couponArray=nil;
        _order.isUseCoupon=nil;
        
        [messageCenter LSMCSeatSelectSeatsWithApiSource:_order.section.apiSource scheduleID:_schedule.scheduleID sectionID:_order.section.sectionID mark:[_scheduleArray indexOfObject:_schedule] mark2:_selectSectionIndex];
    });
    dispatch_release(queue_0);
}

@end
