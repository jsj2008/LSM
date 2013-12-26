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
    
    LSSwitchScheduleView* switchScheduleView = [[LSSwitchScheduleView alloc] initWithFrame:CGRectMake(0.f, 20.f+44.f, self.view.width, 44.f)];
    switchScheduleView.scheduleArray=_scheduleArray;
    switchScheduleView.selectIndex=[_scheduleArray indexOfObject:_schedule];
    switchScheduleView.delegate=self;
    [self.view addSubview:switchScheduleView];
    [switchScheduleView release];
    
    LSSeatCategoryView* seatCategoryView=[[LSSeatCategoryView alloc] initWithFrame:CGRectMake(0.f, 20.f+44.f+44.f, self.view.width, 25.f)];
    [self.view addSubview:seatCategoryView];
    [seatCategoryView release];

    _seatPlaceView = [[LSSeatPlaceView alloc] initWithFrame:CGRectMake(0.f, 20.f+44.f+44.f+25.f, self.view.width, HeightOfiPhoneX(480.f-(20.f+44.f+44.f+25.f)-50.f))];
    _seatPlaceView.order=_order;
    _seatPlaceView.delegate=self;
    [self.view addSubview:_seatPlaceView];
    [_seatPlaceView release];
    
    _seatsInfoView=[[LSSeatsInfoView alloc] initWithFrame:CGRectMake(0.f, 480.f-50.f, self.view.width, 50.f)];
    _seatsInfoView.order=_order;
    _seatsInfoView.delegate=self;
    [self.view addSubview:_seatsInfoView];
    [_seatsInfoView release];
    
    [hud show:YES];
    [messageCenter LSMCSeatsWithDate:_schedule.startDate cinemaID:_cinema.cinemaID hallID:_schedule.hall.hallID];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- 私有方法
//判断座位是否合格
- (BOOL)checkSeatArrayByRules:(NSDictionary*)seatArrayDic
{
    for(NSString* key in [seatArrayDic allKeys])
    {
        //分别取得每一个区域和其对应的选座
        NSArray* seatArray=[seatArrayDic objectForKey:key];
        LSSection* section=nil;
        for(LSSection* _section in _order.sectionArray)
        {
            if([_section.sectionID isEqualToString:key])
            {
                section=_section;
                break;
            }
        }
        
        if(!section)
        {
            return NO;
        }
        
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
            id object=[[section.seatDictionary objectForKey:[NSNumber numberWithInt:firstSeat.rowID]] objectForKey:[NSNumber numberWithFloat:firstSeat.columnID-1]];
            if(object!=NULL)//如果左边确实有座位
            {
                LSSeat* leftSeat=object;
                if(leftSeat.seatStatus!=LSSeatStatusSold && leftSeat.seatStatus!=LSSeatStatusUnable)//如果左边座位没有卖出、没有损坏
                {
                    object=[[section.seatDictionary objectForKey:[NSNumber numberWithInt:leftSeat.rowID]] objectForKey:[NSNumber numberWithFloat:leftSeat.columnID-1]];
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
            id object=[[section.seatDictionary objectForKey:[NSNumber numberWithInt:lastSeat.rowID]] objectForKey:[NSNumber numberWithFloat:lastSeat.columnID+1]];
            if(object!=NULL)//如果右边确实有座位
            {
                LSSeat* rightSeat=object;
                if(rightSeat.seatStatus!=LSSeatStatusSold && rightSeat.seatStatus!=LSSeatStatusUnable)//如果右边座位没有卖出、没有损坏
                {
                    object=[[section.seatDictionary objectForKey:[NSNumber numberWithInt:rightSeat.rowID]] objectForKey:[NSNumber numberWithFloat:rightSeat.columnID+1]];
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
                id object=[[section.seatDictionary objectForKey:[NSNumber numberWithInt:currentRow]] objectForKey:[NSNumber numberWithFloat:currentColumn]];
                if(object!=NULL && object!=nil)//如果中间确实有座位
                {
                    LSSeat* currentSeat=object;
                    if(currentSeat.originSeatStatus!=LSSeatStatusSold && currentSeat.originSeatStatus!=LSSeatStatusUnable)//如果这个座位没有卖出、没有损坏
                    {
                        //
                        //以下判断以中间间隔至少两个座位为基础
                        //
                        object=[[section.seatDictionary objectForKey:[NSNumber numberWithInt:currentRow]] objectForKey:[NSNumber numberWithFloat:currentColumn-1]];
                        if(object!=NULL && object!=nil)//如果左边确实有座位
                        {
                            LSSeat* leftSeat=object;
                            if(leftSeat.seatStatus==LSSeatStatusSelect || leftSeat.seatStatus==LSSeatStatusSold || leftSeat.seatStatus==LSSeatStatusUnable)//如果左边座位被选择、被卖出、被损坏
                            {
                                object=[[section.seatDictionary objectForKey:[NSNumber numberWithInt:currentRow]] objectForKey:[NSNumber numberWithFloat:currentColumn+1]];
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
                            object=[[section.seatDictionary objectForKey:[NSNumber numberWithInt:currentRow]] objectForKey:[NSNumber numberWithFloat:currentColumn+1]];
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
    }
    
    return YES;
}

//一切条件均符合以后，进入提交订单界面
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
                
                NSMutableArray* sectionMArray=[NSMutableArray arrayWithCapacity:0];
                for(NSDictionary* dic in notification.object)
                {
                    LSSection* section=[[LSSection alloc] initWithDictionary:dic];
                    [sectionMArray addObject:section];
                    [section release];
                }
                _order.sectionArray=sectionMArray;
                LSSection* section0=[_order.sectionArray objectAtIndex:0];
                [messageCenter LSMCSeatSelectSeatsWithApiSource:section0.apiSource scheduleID:_schedule.scheduleID];
                
                for(LSSection* section in _order.sectionArray)
                {
                    [section makeSeatDictionary];
                }
            });
            dispatch_release(queue_0);
        }
        else if([notification.name isEqualToString:lsRequestTypeSeatSelectSeatsByApiSource_ScheduleID_SectionID])
        {
            //(
            //   {
            //       sectionID=102;
            //       seats=(
            //                {
            //                    columnId = 10;
            //                    rowId = 10;
            //                }
            //             )
            //   }
            //
            //)

            dispatch_queue_t queue_0=dispatch_queue_create("queue_0", NULL);
            dispatch_async(queue_0, ^{

                for(NSDictionary* dic in notification.object)
                {
                    for(LSSection* section in _order.sectionArray)
                    {
                        if([section.sectionID isEqualToString:[dic objectForKey:@"sectionID"]])
                        {
                            for(NSDictionary* subDic in [dic objectForKey:@"seats"])
                            {
                                LSSeat* _seat=[[LSSeat alloc] initWithDictionary:subDic];
                                
                                LSSeat* seat=[[section.seatDictionary objectForKey:[NSNumber numberWithInt:_seat.rowID]] objectForKey:[NSNumber numberWithFloat:_seat.columnID]];
                                seat.isSold=YES;
                                
                                [_seat release];
                            }
                            break;
                        }
                    }
                    
                }
                
                dispatch_async(dispatch_get_main_queue(),^{
                    
                    [_seatPlaceView setNeedsLayout];
                    [hud hide:YES];
                });
            });
            dispatch_release(queue_0);
        }
    }
}

#pragma mark- LSSwitchScheduleView的委托方法
- (void)LSSwitchScheduleView:(LSSwitchScheduleView *)switchScheduleView didSelectRowAtIndexPath:(NSInteger)indexPath
{
    //如果切换了排期，那么应该从下载影院座位开始
    if(![self.schedule isEqual:[_scheduleArray objectAtIndex:indexPath]])
    {
        self.schedule=[_scheduleArray objectAtIndex:indexPath];
        
        _order.schedule=_schedule;
        _order.selectSeatArrayDic=nil;
        [_seatsInfoView setNeedsDisplay];
        
        [hud show:YES];
        [messageCenter LSMCSeatsWithDate:_schedule.startDate cinemaID:_cinema.cinemaID hallID:_schedule.hall.hallID];
    }
}


#pragma mark- LSSeatPlaceView的委托方法
- (void)LSSeatPlaceView:(LSSeatPlaceView *)seatPlaceView didChangeSelectSeatArrayDic:(NSDictionary *)selectSeatArrayDic
{
    if(selectSeatArrayDic!=nil)
    {
        _order.selectSeatArrayDic=selectSeatArrayDic;
        [_seatsInfoView setNeedsDisplay];
    }
    else
    {
        [LSAlertView showWithView:self.view message:@"当前已经选择最多座位" time:2.f];
    }
}

#pragma mark- LSSeatsInfoView的委托方法
- (void)LSSeatsInfoView:(LSSeatsInfoView *)seatsInfoView didClickConfirmButtonView:(LSConfirmButtonView *)confirmButtonView
{
    if([_order.totalPrice floatValue]>0.f)
    {
        //座位规则的验证
        if(![self checkSeatArrayByRules:_order.selectSeatArrayDic])
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
            loginViewController.delegate=self;
            
            LSNavigationController* navigationController=[[LSNavigationController alloc] initWithRootViewController:loginViewController];
            [self presentViewController:navigationController animated:YES completion:^{}];
            
            [loginViewController release];
            [navigationController release];
        }
    }
    else
    {
        [LSAlertView showWithView:self.view message:@"未选择座位" time:2.f];
    }
}

#pragma mark- LSLoginViewController的委托方法
- (void)LSLoginViewControllerDidLoginByType:(LSLoginType)loginType
{
    [self dismissViewControllerAnimated:YES completion:^{}];
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
        _order.selectSeatArrayDic=nil;
        
        _order.couponArray=nil;
        _order.isUseCoupon=nil;
        
        LSSection* section=[_order.sectionArray objectAtIndex:0];
        [messageCenter LSMCSeatSelectSeatsWithApiSource:section.apiSource scheduleID:_schedule.scheduleID];
    });
    dispatch_release(queue_0);
}

@end
