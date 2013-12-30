//
//  LSMessageCenter.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-8-22.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSMessageCenter.h"

#import "LSRequestURLs.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"

#import "SBJsonParser.h"

@implementation LSMessageCenter

static LSMessageCenter *defaultCenter=nil;
static ASINetworkQueue* networkQueue=nil;
static NSNotificationCenter* notificationCenter=nil;
static LSUser* user=nil;

#pragma mark - 消息中心,单例模式
+ (LSMessageCenter *)defaultCenter
{
    @synchronized(self)
    {
        if (defaultCenter==nil)
        {
            defaultCenter=[[super allocWithZone:NULL] init];

            user=[LSUser currentUser];
            notificationCenter=[NSNotificationCenter defaultCenter];
            networkQueue=[[ASINetworkQueue alloc] init];
            
            networkQueue.delegate=defaultCenter;
            networkQueue.shouldCancelAllRequestsOnFailure=NO;
            networkQueue.showAccurateProgress=YES;
            networkQueue.maxConcurrentOperationCount=6;
            
            networkQueue.requestDidStartSelector=@selector(requestDidStart:);
            networkQueue.requestDidReceiveResponseHeadersSelector=@selector(requestDidReceiveResponseHeaders:);
            networkQueue.requestWillRedirectSelector=@selector(requestWillRedirect:);
            networkQueue.requestDidFinishSelector=@selector(requestDidFinish:);
            networkQueue.requestDidFailSelector=@selector(requestDidFail:);
            
            networkQueue.queueDidFinishSelector=@selector(queueDidFinish:);
            
            [networkQueue go];
        }
    }
    return defaultCenter;
}

+ (id)alloc
{
    return [[self defaultCenter] retain];
}
+ (id)allocWithZone:(NSZone *)zone
{
    return [[self defaultCenter] retain];
}
- (id)copyWithZone:(NSZone *)zone;
{
    return self; //确保copy对象也是唯一
}
- (id)retain
{
    return self; //确保计数唯一
}
- (NSUInteger)retainCount
{
    return NSUIntegerMax;  //这样打印出来的计数永远为-1
}
- (oneway void)release
{
    //do nothing
}
+ (void)release
{
    //do nothing
}
- (id)autorelease
{
    return self;//确保计数唯一
}



#pragma mark - 自定义通知相关函数
- (void)postNotificationName:(NSString *)aName object:(id)anObject
{
    [notificationCenter postNotificationName:aName object:anObject];
}
- (void)addObserver:(id)observer selector:(SEL)aSelector name:(NSString *)aName object:(id)anObject
{
    [notificationCenter addObserver:observer selector:aSelector name:aName object:anObject];
}
- (void)removeObserver:(id)observer
{
    [notificationCenter removeObserver:observer];
}
- (void)removeObserver:(id)observer name:(NSString *)aName object:(id)anObject
{
    [notificationCenter removeObserver:observer name:aName object:anObject];
}


#pragma mark- 私有方法
- (void)requestWithURL:(NSURL *)URL requestType:(NSString *)requestType params:(NSDictionary *)params
{
    [self requestWithURL:URL requestType:requestType requestMark:-1 params:params];
}
- (void)requestWithURL:(NSURL *)URL requestType:(NSString *)requestType requestMark:(int)requestMark params:(NSDictionary *)params
{
    [self requestWithURL:(NSURL *)URL requestType:(NSString *)requestType requestMark:requestMark requestMark2:-1 params:(NSDictionary *)params];
}
- (void)requestWithURL:(NSURL *)URL requestType:(NSString *)requestType requestMark:(int)requestMark requestMark2:(int)requestMark2 params:(NSDictionary *)params
{
    ASIFormDataRequest* request = [[ASIFormDataRequest alloc]initWithURL:URL];
    request.requestType=requestType;//设置请求类型
    request.requestMark=requestMark;//设置标记 -1没有意义
    request.requestMark2=requestMark2;//设置标记 -1没有意义

    for (NSString* key in [params allKeys])
    {
        [request setPostValue:[params objectForKey:key] forKey:key];
    }
    [request setUseCookiePersistence:NO];
    [request setValidatesSecureCertificate:NO];
    [request setTimeOutSeconds:20];
    [request setShouldAttemptPersistentConnection:NO];//关闭连接重用
    [request setNumberOfTimesToRetryOnTimeout:2];//设置请求超时重试次数
    [networkQueue addOperation:request];
    [request release];
    
    LSLOG(@"[%@] 发起第 %d 次请求",requestType,request.requestTimes);
}



#pragma mark/ 暴露方法
#pragma mark- 影片相关
#pragma mark 获取某城市影片列表
- (void)LSMCFilmsWithStatus:(LSFilmShowStatus)status
{
    NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       [NSString stringWithFormat:@"%u", status],@"type",
                       user.cityID,@"cityId",
                       lsURLSource,@"source",
                       [[NSString stringWithFormat:@"%@|%@|%@",lsURLSource,user.cityID,lsURLSign] SHA256],@"signValue",
                       nil];
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", API_VERSION_HEADER, lsURLFilmsByStatus, lsURLSTID]];
    [self requestWithURL:url requestType:lsRequestTypeFilmsByStatus requestMark:status params:dic];
}
#pragma mark 获取某影片信息
- (void)LSMCFilmInfoWithFilmID:(NSString*)filmID
{
    NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       filmID, @"filmId",
                       @"0", @"comment",
                       lsURLSource, @"source",
                       [[NSString stringWithFormat:@"%@|%@|%@",lsURLSource,filmID,lsURLSign] SHA256],@"signValue",
                       nil];
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", API_VERSION_HEADER, lsURLFilmInfoByFilmID, lsURLSTID]];
    [self requestWithURL:url requestType:lsRequestTypeFilmInfoByFilmID params:dic];
}
#pragma mark 获取某影片影院列表
- (void)LSMCFilmCinemasWithFilmID:(NSString*)filmID
{
    NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       user.cityID, @"cityId",
                       filmID, @"filmId",
                       lsURLSource, @"source",
                       [[NSString stringWithFormat:@"%@|%@|%@|%@",lsURLSource,filmID,user.cityID,lsURLSign] SHA256],@"signValue",
                       nil];
    NSMutableDictionary* mDic=[NSMutableDictionary dictionaryWithDictionary:dic];
    if(user.location!=nil)
    {
        [mDic setObject:[NSNumber numberWithFloat:user.location.coordinate.latitude] forKey:@"nlat"];
        [mDic setObject:[NSNumber numberWithFloat:user.location.coordinate.longitude] forKey:@"nlng"];
    }
    else
    {
        [mDic setObject:[NSNumber numberWithFloat:0] forKey:@"nlat"];
        [mDic setObject:[NSNumber numberWithFloat:0] forKey:@"nlng"];
    }
    
    if(user.userID!=nil)
    {
        [mDic setObject:user.userID forKey:@"userId"];
    }
    
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", API_VERSION_HEADER, lsURLFilmCinemasByFilmID, lsURLSTID]];
    [self requestWithURL:url requestType:lsRequestTypeFilmCinemasByFilmID params:mDic];
}


#pragma mark- 影院相关
#pragma mark 获取某城市影院列表
- (void)LSMCCinemas
{
    NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       user.cityID,@"cityId",
                       lsURLSource,@"source",
                       [[NSString stringWithFormat:@"%@|%@|%@",lsURLSource,user.cityID,lsURLSign] SHA256],@"signValue",
                       nil];
    NSMutableDictionary* mDic=[NSMutableDictionary dictionaryWithDictionary:dic];
    
    if(user.location!=nil)
    {
        [mDic setObject:[NSNumber numberWithFloat:user.location.coordinate.latitude] forKey:@"nlat"];
        [mDic setObject:[NSNumber numberWithFloat:user.location.coordinate.longitude] forKey:@"nlng"];
    }
    else
    {
        [mDic setObject:[NSNumber numberWithFloat:0] forKey:@"nlat"];
        [mDic setObject:[NSNumber numberWithFloat:0] forKey:@"nlng"];
    }
    
    if(user.userID!=nil)
    {
        [mDic setObject:user.userID forKey:@"userId"];
    }
    
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", API_VERSION_HEADER, lsURLCinemas, lsURLSTID]];
    [self requestWithURL:url requestType:lsRequestTypeCinemas params:mDic];
}
#pragma mark 获取某影院影片列表
- (void)LSMCCinemaFilmsWithCinemaID:(NSString*)cinemaID
{
    NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       cinemaID, @"cinemaId",
                       lsURLSource, @"source",
                       [[NSString stringWithFormat:@"%@|%@|%@",lsURLSource,cinemaID,lsURLSign] SHA256],@"signValue",
                       nil];
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", API_VERSION_HEADER, lsURLCinemaFilmsByCinemaID, lsURLSTID]];
    [self requestWithURL:url requestType:lsRequestTypeCinemaFilmsByCinemaID params:dic];
}

#pragma mark- 排期相关
#pragma mark 获取某影院某影片排期
- (void)LSMCSchedulesWithCinemaID:(NSString*)cinemaID filmID:(NSString*)filmID mark:(int)mark
{
    NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       cinemaID, @"cinemaId",
                       filmID,@"filmId",
                       lsURLSource, @"source",
                       [[NSString stringWithFormat:@"%@|%@|%@|%@",lsURLSource,filmID,cinemaID,lsURLSign] SHA256],@"signValue",
                       nil];
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", API_VERSION_HEADER, lsURLSchedulesByCinemaID_FilmID, lsURLSTID]];
    [self requestWithURL:url requestType:lsRequestTypeSchedulesByCinemaID_FilmID requestMark:mark params:dic];
}

#pragma mark- 座位相关
#pragma mark 获取某影院某厅座位列表(包含座位状态信息,不包含已售信息)
- (void)LSMCSeatsWithDate:(NSString*)date cinemaID:(NSString*)cinemaID hallID:(NSString*)hallID
{
    NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       cinemaID, @"cinemaId",
                       hallID,@"hallId",
                       date,@"date",
                       lsURLSource, @"source",
                       [[NSString stringWithFormat:@"%@|%@|%@|%@",lsURLSource,hallID,cinemaID,lsURLSign] SHA256],@"signValue",
                       nil];    
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", API_VERSION_HEADER, lsURLSeatsByDate_CinemaID_HallID, lsURLSTID]];
    [self requestWithURL:url requestType:lsRequestTypeSeatsByDate_CinemaID_HallID params:dic];
}
#pragma mark 获取某影院已售座位列表
- (void)LSMCSeatSelectSeatsWithApiSource:(LSApiSource)apiSource scheduleID:(NSString*)scheduleID
{
    NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       [NSNumber numberWithInt:apiSource], @"api_source",
                       scheduleID,@"seqNo",
                       lsURLSource, @"source",
                       [[NSString stringWithFormat:@"%@|%@|%@|%@",lsURLSource,scheduleID,[NSNumber numberWithInt:apiSource],lsURLSign] SHA256],@"signValue",
                       nil];
    
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", API_VERSION_HEADER, lsURLSeatSelectSeatsByApiSource_ScheduleID_SectionID, lsURLSTID]];
    [self requestWithURL:url requestType:lsRequestTypeSeatSelectSeatsByApiSource_ScheduleID_SectionID params:dic];
}


#pragma mark- 订单相关
#pragma mark 获取订单列表
- (void)LSMCOrdersWithStatus:(LSOrderStatus)status offset:(int)offset pageSize:(int)pageSize
{
    NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       user.userName, @"username",
                       user.password,@"password",
                       [NSString stringWithFormat:@"%d", status],@"type",
                       [NSString stringWithFormat:@"%d", offset],@"offset",
                       [NSString stringWithFormat:@"%d", pageSize],@"pageSize",
                       [[NSString stringWithFormat:@"%@|%@|%d|%@",user.userName,user.password,status,lsURLSign] SHA256],@"signValue",
                       nil];
    
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", API_VERSION_HEADER, lsURLOrdersByType_Offset_PageSize, lsURLSTID]];
    [self requestWithURL:url requestType:lsRequestTypeOrdersByType_Offset_PageSize params:dic];
}
#pragma mark 获取订单数
- (void)LSMCOrderCount
{
    NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       user.userName, @"username",
                       user.password,@"password",
                       [[NSString stringWithFormat:@"%@|%@|%@",user.userName,user.password,lsURLSign] SHA256],@"signValue",
                       nil];
    
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", API_VERSION_HEADER, lsURLOrderCount, lsURLSTID]];
    [self requestWithURL:url requestType:lsRequestTypeOrderCount params:dic];
}
#pragma mark 生成订单
- (void)LSMCOrderCreateWithScheduleID:(NSString*)scheduleID sectionID:(NSString*)sectionID seats:(NSString*)seats mobile:(NSString*)mobile isOnSale:(BOOL)isOnSale
{
    NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       user.userName, @"username",
                       user.password,@"password",
                       scheduleID,@"seqNo",
                       sectionID,@"sectionId",
                       seats,@"seats",
                       mobile,@"mobile",
                       (isOnSale?@"1":@"0"),@"campaignSign",
                       lsURLSource, @"source",
                       [[NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@|%@",user.userName,user.password,scheduleID,sectionID,seats,mobile,lsURLSign] SHA256],@"signValue",
                       nil];
    
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", API_VERSION_HEADER, lsURLOrderCreateByScheduleID_SectionID_Seats_Mobile_OnSale, lsURLSTID]];
    [self requestWithURL:url requestType:lsRequestTypeOrderCreateOrderByScheduleID_SectionID_Seats_Mobile_OnSale params:dic];
}
#pragma mark 获取支付宝支付信息
- (void)LSMCOrderOtherPayInfoWithOrderID:(NSString*)orderID payWay:(LSPayWayType)payWay isUseCoupon:(NSString*)isUseCoupon
{
    LSAlipay* alipay=[LSAlipay currentAlipay];
    NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       user.userID, @"uid",
                       orderID,@"trade_no",
                       lsURLSource, @"source",
                       isUseCoupon,@"isUsed",
                       [[NSString stringWithFormat:@"%@|%@|%@|%@|%@",lsURLSource,orderID,user.userID,alipay.accessToken!=nil?alipay.accessToken:@"",lsURLSign] SHA256],@"signValue",
                       nil];

    NSMutableDictionary* mDic=[NSMutableDictionary dictionaryWithDictionary:dic];
//    LSPayWayTypeNon     = 0,//未选择
//    LSPayWayTypeBalance = 1,//余额
//    LSPayWayTypeAlipay  = 2,//支付宝
//    LSPayWayTypeTenpay  = 3,//财付通
//    LSPayWayTypeUPOMP   = 4,//银联
//    LSPayWayTypeBank    = 5 //银行卡
    [mDic setObject:[NSNumber numberWithInt:payWay] forKey:@""];
    if(payWay==LSPayWayTypeAlipay)
    {
        [mDic setObject:(alipay.accessToken!=nil?alipay.accessToken:@"") forKey:@"access_token"];
    }
    
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", API_VERSION_HEADER, lsURLOrderOtherPayInfoByOrderID_PayWay_IsCoupon, lsURLSTID]];
    [self requestWithURL:url requestType:lsRequestTypeOrderOtherPayInfoByOrderID_PayWay_IsCoupon params:mDic];
}


#pragma mark- 团购相关
#pragma mark 获取团购列表
- (void)LSMCGroupsWithStatus:(LSGroupStatus)status offset:(int)offset pageSize:(int)pageSize
{
    NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       user.userName, @"username",
                       user.password,@"password",
                       lsURLSource, @"source",
                       [NSString stringWithFormat:@"%d", status],@"orderType",
                       [NSString stringWithFormat:@"%d", offset],@"offset",
                       [NSString stringWithFormat:@"%d", pageSize],@"pageSize",
                       [[NSString stringWithFormat:@"%@|%d|%@|%@|%@",lsURLSource,status,user.userName,user.password,lsURLSign] SHA256],@"signValue",
                       nil];
    
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", API_VERSION_HEADER, lsURLGroupsByType_Offset_PageSize, lsURLSTID]];
    [self requestWithURL:url requestType:lsRequestTypeGroupsByType_Offset_PageSize requestMark:status params:dic];
}
#pragma mark 获取团购说明
- (void)LSMCGroupInfoWithGroupID:(NSString*)groupID
{
    NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       groupID, @"goods_id",
                       lsURLSource, @"source",
                       [[NSString stringWithFormat:@"%@|%@|%@",lsURLSource,groupID,lsURLSign] SHA256],@"signValue",
                       nil];
    
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", API_VERSION_HEADER, lsURLGroupInfoByGroupID, lsURLSTID]];
    [self requestWithURL:url requestType:lsRequestTypeGroupInfoByGroupID params:dic];
}
#pragma mark 生成团购订单
- (void)LSMCGroupCreateWithGroupID:(NSString*)groupID amount:(int)amount
{
    NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       user.userName,@"username",
                       user.password,@"password",
                       user.cityID,@"cityId",
                       [NSString stringWithFormat:@"%d", amount],@"amount",
                       @"iPhone",@"client_name",
                       lsSoftwareVersion,@"app_edition",
                       lsChannelID,@"channe_id",
                       groupID, @"goods_id",
                       lsURLSource, @"source",
                       [[NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@",lsURLSource,groupID,[NSString stringWithFormat:@"%d", amount],user.userName,user.password, lsURLSign] SHA256],@"signValue",
                       nil];
    
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", API_VERSION_HEADER, lsURLGroupCreateByGroupID_Amount, lsURLSTID]];
    [self requestWithURL:url requestType:lsRequestTypeGroupCreateByGroupID_Amount params:dic];
}
#pragma mark 获取团购订单信息
- (void)LSMCGroupInfoWithOrderID:(NSString*)orderID
{
    NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       user.userName, @"username",
                       user.password,@"password",
                       lsURLSource, @"source",
                       orderID,@"trade_no",
                       [[NSString stringWithFormat:@"%@|%@|%@|%@|%@",lsURLSource,orderID,user.userName,user.password,lsURLSign] SHA256],@"signValue",
                       nil];
    
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", API_VERSION_HEADER, lsURLGroupInfoByOrderID, lsURLSTID]];
    [self requestWithURL:url requestType:lsRequestTypeGroupInfoByOrderID params:dic];
}
#pragma mark 取消团购订单
- (void)LSMCGroupCancelWithOrderID:(NSString*)orderID
{
    NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       user.userName, @"username",
                       user.password,@"password",
                       lsURLSource, @"source",
                       orderID,@"trade_no",
                       @"iPhone",@"client_name",
                       lsSoftwareVersion,@"app_edition",
                       lsChannelID,@"channe_id",
                       [[NSString stringWithFormat:@"%@|%@|%@|%@|%@",lsURLSource,orderID,user.userName,user.password,lsURLSign] SHA256],@"signValue",
                       nil];
    
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", API_VERSION_HEADER, lsURLGroupCancelByOrderID, lsURLSTID]];
    [self requestWithURL:url requestType:lsRequestTypeGroupCancelByOrderID params:dic];
}


#pragma mark- 拉手券相关
#pragma mark 获取拉手券列表
- (void)LSMCTicketsWithOffset:(int)offset pageSize:(int)pageSize
{
    NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       user.userName, @"username",
                       user.password,@"password",
                       lsURLSource, @"source",
                       [NSString stringWithFormat:@"%d", offset],@"offset",
                       [NSString stringWithFormat:@"%d", pageSize],@"pageSize",
                       [[NSString stringWithFormat:@"%@|%@|%@|%@",lsURLSource,user.userName,user.password,lsURLSign] SHA256],@"signValue",
                       nil];
    
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", API_VERSION_HEADER, lsURLTicketsByOffset_PageSize, lsURLSTID]];
    [self requestWithURL:url requestType:lsRequestTypeTicketsByOffset_PageSize params:dic];
}
- (void)LSMCTicketPasswordWithTicketID:(NSString*)ticketID
{
    NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       user.userName, @"username",
                       user.password,@"password",
                       lsURLSource, @"source",
                       ticketID,@"code_id",
                       [[NSString stringWithFormat:@"%@|%@|%@|%@|%@",lsURLSource,ticketID,user.userName,user.password,lsURLSign] SHA256],@"signValue",
                       nil];
    
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", API_VERSION_HEADER, lsURLTicketPasswordByTicketID, lsURLSTID]];
    [self requestWithURL:url requestType:lsRequestTypeTicketPasswordByTicketID params:dic];
}


#pragma mark- 支付相关
- (void)LSMCPayBalancePayWithOrderID:(NSString*)orderID isUseCoupon:(NSString*)isUseCoupon securityCode:(NSString*)securityCode
{
    NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       user.userName, @"username",
                       user.password,@"password",
                       orderID,@"trade_no",
                       isUseCoupon,@"isUsed",
                       [[NSString stringWithFormat:@"%@|%@|%@|%@",user.userName,user.password,orderID,lsURLSign] SHA256],@"signValue",
                       nil];
    
    NSMutableDictionary* mDic=[NSMutableDictionary dictionaryWithDictionary:dic];
    if(securityCode!=nil)
    {
      [mDic setObject:securityCode forKey:@"payCode"];
    }
    
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", API_VERSION_HEADER, lsURLPayBalancePayByOrderID_IsCoupon_SecurityCode, lsURLSTID]];
    [self requestWithURL:url requestType:lsRequestTypePayBalancePayByOrderID_IsCoupon_SecurityCode params:mDic];
}


#pragma mark- 优惠券相关
- (void)LSMCCouponUseWithOrderID:(NSString*)orderID cinemaID:(NSString*)cinemaID couponID:(NSString*)couponID
{
    NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       couponID, @"vouchers",
                       cinemaID,@"cid",
                       orderID,@"trade_no",
                       user.userID,@"user_id",
                       lsURLSource,@"source",
                       [[NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@",cinemaID,couponID,orderID,user.userID,lsURLSource,lsURLSign] SHA256],@"signValue",
                       nil];
    
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", API_VERSION_HEADER, lsURLCouponUseByOrderID_CinemaID_CouponID, lsURLSTID]];
    [self requestWithURL:url requestType:lsRequestTypeCouponUseByOrderID_CinemaID_CouponID params:dic];
}
- (void)LSMCCouponCancelWithOrderID:(NSString*)orderID cinemaID:(NSString*)cinemaID couponID:(NSString*)couponID
{
    NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       couponID, @"vouchers",
                       cinemaID,@"cid",
                       orderID,@"trade_no",
                       user.userID,@"user_id",
                       lsURLSource,@"source",
                       [[NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@",cinemaID,couponID,orderID,user.userID,lsURLSource,lsURLSign] SHA256],@"signValue",
                       nil];
    
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", API_VERSION_HEADER, lsURLCouponCancelByOrderID_CinemaID_CouponID, lsURLSTID]];
    [self requestWithURL:url requestType:lsRequestTypeCouponCancelByOrderID_CinemaID_CouponID params:dic];
}

#pragma mark- 卡券相关
- (void)LSMCAlipayCreateCardWithOrderID:(NSString*)orderID
{
    NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       (user.isCreateCard?@"1":@"0"),@"is_open",
                       orderID,@"out_trade_no",
                       lsURLSource, @"source",
                       [[NSString stringWithFormat:@"%@|%@|%@|%@",lsURLSource,orderID,(user.isCreateCard?@"1":@"0"),lsURLSign] SHA256],@"signValue",
                       nil];
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", API_VERSION_HEADER, lsURLAlipayCreateCardByOrderID, lsURLSTID]];
    [self requestWithURL:url requestType:lsRequestTypeAlipayCreateCardByOrderID params:dic];
}


#pragma mark- 登陆相关
#pragma mark 注册
- (void)LSMCRegisterWithUserName:(NSString*)userName password:(NSString*)password email:(NSString*)email
{
    NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       userName, @"username",
                       password,@"password",
                       email,@"email",
                       [[NSString stringWithFormat:@"%@|%@|%@|%@",userName,email,password,lsURLSign] SHA256],@"signValue",
                       nil];
    
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", API_VERSION_HEADER, lsURLRegisterByUserName_Password_Email, lsURLSTID]];
    [self requestWithURL:url requestType:lsRequestTypeRegisterByUserName_Password_Email params:dic];
}
#pragma mark 普通登陆
- (void)LSMCLoginWithUserName:(NSString*)userName password:(NSString*)password
{
    NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       userName, @"username",
                       password,@"password",
                       [[NSString stringWithFormat:@"%@|%@|%@",userName,password,lsURLSign] SHA256],@"signValue",
                       nil];
    
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", API_VERSION_HEADER, lsURLLoginNormalLoginByUserName_Password, lsURLSTID]];
    [self requestWithURL:url requestType:lsRequestTypeLoginNormalLoginByUserName_Password params:dic];
}
#pragma mark 联合登陆
- (void)LSMCLoginWithUserID:(NSString*)userID userName:(NSString*)userName type:(LSLoginType)type
{
    NSMutableDictionary* mDic=[NSMutableDictionary dictionaryWithCapacity:0];
    [mDic setObject:[NSString stringWithFormat:@"%u", type] forKey:@"type"];

    if (type == LSLoginTypeSinaWB)
    {
        [mDic setObject:userID forKey:@"sina_uid"];
        [mDic setObject:userName forKey:@"sina_name"];
    }
    else if (type == LSLoginTypeQQWB)
    {
        [mDic setObject:userID forKey:@"qqW_openid"];
        [mDic setObject:userName forKey:@"qqnick"];
    }
    else if(type == LSLoginTypeQQ)
    {
        [mDic setObject:userID forKey:@"qq_openid"];
        [mDic setObject:userName forKey:@"qqnick"];
    }
    
    [mDic setObject:[[NSString stringWithFormat:@"%@|%@|%@", userID, userName,lsURLSign] SHA256] forKey:@"signValue"];
    
    
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", API_VERSION_HEADER, lsURLLoginUnionLoginByUserID_UserName_Type, lsURLSTID]];
    [self requestWithURL:url requestType:lsRequestTypeLoginUnionLoginByUserID_UserName_Type params:mDic];
}
#pragma mark 获取QQ开放ID
- (void)LSMCLoginQQOpenIDWithAccessToken:(NSString*)accessToken
{
    NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       [accessToken encodingURL], @"access_token",
                       nil];
    
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@", lsURLLoginQQOpenIDByAccessToken]];
    [self requestWithURL:url requestType:lsRequestTypeLoginQQOpenIDByAccessToken params:dic];
}
#pragma mark 获取QQ用户共享信息
- (void)LSMCLoginQQUserInfoWithAppID:(NSString*)appID accessToken:(NSString*)accessToken openID:(NSString*)openID
{
    NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       [accessToken encodingURL], @"access_token",
                       [appID encodingURL], @"oauth_consumer_key",
                       [openID encodingURL], @"openid",
                       nil];
    
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@", lsURLLoginQQUserInfoByAppID_AccessToken_OpenID]];
    [self requestWithURL:url requestType:lsRequestTypeLoginQQUserInfoByAppID_AccessToken_OpenID params:dic];
}
#pragma mark 获取腾讯微博用户共享信息
- (void)LSMCLoginQQWBUserInfoWithCode:(NSString*)code
{
    NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       [LSQQWBConsumerKey encodingURL], @"client_id",
                       [LSQQWBConsumerSecret encodingURL], @"client_secret",
                       [@"http://mobile.lashou.com" encodingURL], @"redirect_uri",
                       [@"authorization_code" encodingURL], @"grant_type",
                       [code encodingURL], @"code",
                       nil];

    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@", lsURLLoginQQWBUserInfoByCode]];
    [self requestWithURL:url requestType:lsRequestTypeLoginQQWBUserInfoByCode params:dic];
}
#pragma mark 获取新浪微博AccessToken
- (void)LSMCLoginSinaWBAccessTokenWithCode:(NSString*)code
{
    NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       [LSSinaWBConsumerKey encodingURL], @"client_id",
                       [LSSinaWBConsumerSecret encodingURL], @"client_secret",
                       [@"authorization_code" encodingURL], @"grant_type",
                       [@"http://mobile.lashou.com" encodingURL], @"redirect_uri",
                       [code encodingURL], @"code",
                       nil];
    
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@", lsURLLoginSinaWBAccessTokenByCode]];
    [self requestWithURL:url requestType:lsRequestTypeLoginSinaWBAccessTokenByCode params:dic];
}
#pragma mark 获取新浪微博用户共享信息
- (void)LSMCLoginSinaWBUserInfoWithAccessToken:(NSString*)accessToken userID:(NSString*)userID
{
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@access_token=%@&uid=%@",lsURLLoginSinaWBUserInfoByAccessToken_UserID, accessToken, userID]];
    ASIHTTPRequest* request=[[ASIHTTPRequest alloc] initWithURL:url];
    request.requestType=lsRequestTypeLoginSinaWBUserInfoByAccessToken_UserID;//设置请求类型
    request.requestMark=-1;//设置标记 -1没有意义
    [request setUseCookiePersistence:NO];
    [request setValidatesSecureCertificate:NO];
    [request setTimeOutSeconds:10];
    [request setShouldAttemptPersistentConnection:NO];//关闭连接重用
    [request setNumberOfTimesToRetryOnTimeout:2];//设置请求超时重试次数
    [networkQueue addOperation:request];
    [request release];
    
    LSLOG(@"[%@] 发起第 %d 次请求",request.requestType,request.requestTimes);
}
#pragma mark 获取支付宝用户共享信息
- (void)LSMCLoginAlipayUserInfoWithAppID:(NSString*)appID authCode:(NSString*)authCode
{
    NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       authCode, @"auth_code",
                       appID, @"app_id",
                       nil];
    
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", API_NOT_VERSION_HEADER,lsURLLoginAlipayUserInfoByAppID_AuthCode]];
    [self requestWithURL:url requestType:lsRequestTypeLoginAlipayUserInfoByAppID_AuthCode params:dic];
}

#pragma mark- 分享相关
#pragma mark 新浪微博分享
- (void)LSMCShareSinaWBShareWithMessage:(NSString*)message img:(NSString*)imgURL
{
    NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:                       
                       [LSSave obtainForKey:LSSinaWBAccessToken], @"access_token",
                       message, @"status",
                       /*imgURL, @"url",*/
                       nil];
    
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@",lsURLShareSinaWBShareByMessage_Img]];
    [self requestWithURL:url requestType:lsRequestTypeShareSinaWBShareByMessage_Img params:dic];
}
#pragma mark 腾讯微博分享
- (void)LSMCShareQQWBShareWithMessage:(NSString*)message img:(NSString*)imgURL
{
    NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       LSQQWBConsumerKey, @"oauth_consumer_key",
                       [LSSave obtainForKey:LSQQWBAccessToken], @"access_token",
                       [LSSave obtainForKey:LSQQWBUID], @"openid",
                       [@"219.234.141.49" encodingURL], @"clientip",
                       @"2.a", @"oauth_version",
                       @"json", @"format",
                       message, @"content",
                       imgURL, @"pic_url",
                       nil];
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@",lsURLShareQQWBShareByMessage_Img]];
    [self requestWithURL:url requestType:lsRequestTypeShareQQWBShareByMessage_Img params:dic];
}

#pragma mark- 获取用户相关信息
- (void)LSMCUserProfile
{ 
    NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       user.userName, @"username",
                       user.password, @"password",
                       [[NSString stringWithFormat:@"%@|%@|%@",user.userName,user.password,lsURLSign] SHA256],@"signValue",
                       nil];
    
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", API_VERSION_HEADER,lsURLUserProfile]];
    [self requestWithURL:url requestType:lsRequestTypeUserProfile params:dic];
}

#pragma mark- 手机号相关
#pragma mark 获取验证码
- (void)LSMCMobileSecurityCodeWithOldPhone:(NSString*)oldPhone newPhone:(NSString*)newPhone
{
    NSMutableDictionary* mDic=[NSMutableDictionary dictionaryWithCapacity:0];
    [mDic setObject:user.userName forKey:@"username"];
    [mDic setObject:user.password forKey:@"password"];
    if(oldPhone!=nil)
    {
        [mDic setObject:oldPhone forKey:@"old_mobile"];
    }
    [mDic setObject:newPhone forKey:@"new_mobile"];
    [mDic setObject:[[NSString stringWithFormat:@"%@|%@|%@|%@",
                      user.userName,
                      user.password,
                      newPhone,
                      lsURLSign] SHA256] forKey:@"signValue"];
    
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", API_VERSION_HEADER, lsURLMobileSecurityCodeByOldPhone_NewPhone, lsURLSTID]];
    [self requestWithURL:url requestType:lsRequestTypeMobileSecurityCodeByOldPhone_NewPhone params:mDic];
}
#pragma mark 绑定手机号
- (void)LSMCMobileBindWithOldPhone:(NSString*)oldPhone newPhone:(NSString*)newPhone securityCode:(NSString*)securityCode
{
    NSMutableDictionary* mDic=[NSMutableDictionary dictionaryWithCapacity:0];
    [mDic setObject:user.userName forKey:@"username"];
    [mDic setObject:user.password forKey:@"password"];
    if(oldPhone!=nil)
    {
        [mDic setObject:oldPhone forKey:@"old_mobile"];
    }
    [mDic setObject:newPhone forKey:@"new_mobile"];
    [mDic setObject:securityCode forKey:@"mobileCode"];
    [mDic setObject:[[NSString stringWithFormat:@"%@|%@|%@|%@|%@",
                      user.userName,
                      user.password,
                      newPhone,
                      securityCode,
                      lsURLSign] SHA256] forKey:@"signValue"];
    
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", API_VERSION_HEADER, lsURLMobileBindByOldPhone_NewPhone_SecurityCode, lsURLSTID]];
    [self requestWithURL:url requestType:lsRequestTypeMobileBindByOldPhone_NewPhone_SecurityCode params:mDic];
}


#pragma mark- 广告相关
#pragma mark 获取广告列表
- (void)LSMCAdvertisements
{
    NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       lsURLSource, @"source",
                       user.cityID, @"cityId",
                       [[NSString stringWithFormat:@"%@|%@|%@",lsURLSource,user.cityID,lsURLSign] SHA256],@"signValue",
                       nil];
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", API_VERSION_HEADER, lsURLAdvertisements, lsURLSTID]];
    [self requestWithURL:url requestType:lsRequestTypeAdvertisements params:dic];
}
#pragma mark 获取影院详情(用于跳转)
- (void)LSMCADCinemaDetailWithCinemaID:(NSString*)cinemaID
{
    NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       lsURLSource, @"source",
                       user.cityID, @"cityId",
                       cinemaID, @"cinemaId",
                       [[NSString stringWithFormat:@"%@|%@|%@|%@",lsURLSource,user.cityID,cinemaID,lsURLSign] SHA256],@"signValue",
                       nil];
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", API_VERSION_HEADER, lsURLADCinemaDetailByCinemaID, lsURLSTID]];
    [self requestWithURL:url requestType:lsRequestTypeADCinemaDetailByCinemaID params:dic];
}
#pragma mark 获取影片详情(用于跳转)
- (void)LSMCADFilmDetailWithFilmID:(NSString*)filmID
{
    NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       lsURLSource, @"source",
                       user.cityID, @"cityId",
                       filmID, @"filmId",
                       [[NSString stringWithFormat:@"%@|%@|%@|%@",lsURLSource,user.cityID,filmID,lsURLSign] SHA256],@"signValue",
                       nil];
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", API_VERSION_HEADER, lsURLADFilmDetailByFilmID, lsURLSTID]];
    [self requestWithURL:url requestType:lsRequestTypeADFilmDetailByFilmID params:dic];
}
#pragma mark 生成活动链接(用于跳转)
- (NSURLRequest*)LSMCActivityWapWithActivityID:(NSString*)activityID
{
    NSMutableURLRequest* mRequest=[[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", API_VERSION_HEADER, lsURLADActivityWapByActivityID, lsURLSTID]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.f] autorelease];
    [mRequest setHTTPMethod:@"POST"];
    NSString* paramString = [NSString stringWithFormat:@"source=%@&mactivityId=%@&signValue=%@",lsURLSource,activityID,[[NSString stringWithFormat:@"%@|%@|%@",lsURLSource,activityID,lsURLSign] SHA256]];
    [mRequest setHTTPBody:[paramString dataUsingEncoding:NSUTF8StringEncoding]];
    return mRequest;
}

#pragma mark- 城市相关
#pragma mark 获取城市列表
- (void)LSMCCities
{
    NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       lsURLSource, @"source",
                       [[NSString stringWithFormat:@"%@|%@",lsURLSource,lsURLSign] SHA256],@"signValue",
                       nil];
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", API_VERSION_HEADER, lsURLCities, lsURLSTID]];
    [self requestWithURL:url requestType:lsRequestTypeCities params:dic];
}
#pragma mark 获取城市ID
- (void)LSMCCityCityIDWithName:(NSString*)cityName
{
    NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       cityName, @"cityName",
                       lsURLSource, @"source",
                       [[NSString stringWithFormat:@"%@|%@|%@",cityName,lsURLSource,lsURLSign] SHA256],@"signValue",
                       nil];
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", API_VERSION_HEADER, lsURLCityCityIDByName, lsURLSTID]];
    [self requestWithURL:url requestType:lsRequestTypeCityCityIDByName params:dic];
}

#pragma mark- 其他
#pragma mark 更新动作
- (void)LSMCUpdateAction
{
    NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       lsURLSource, @"source",
                       [[NSString stringWithFormat:@"%@|%@",lsURLSource,lsURLSign] SHA256],@"signValue",
                       nil];
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", API_VERSION_HEADER, lsURLUpdateAction,lsURLSTID]];
    [self requestWithURL:url requestType:lsRequestTypeUpdateAction params:dic];
}
#pragma mark 更新信息
- (void)LSMCUpdateInfo
{
    NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       @"拉手电影iphone版", @"softname",
                       nil];
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", API_NOT_VERSION_HEADER, lsURLUpdateInfo]];
    [self requestWithURL:url requestType:lsRequestTypeUpdateInfo params:dic];
}
#pragma mark 意见反馈
- (void)LSMCFeedbackWithContent:(NSString*)content contact:(NSString*)contact
{
    NSMutableDictionary* mDic=[NSMutableDictionary dictionaryWithCapacity:0];
    [mDic setObject:[NSString stringWithFormat:@"iphone%@",lsSoftwareVersion] forKey:@"version"];
    [mDic setObject:[NSString stringWithFormat:@"%@-ios%@-设备类型:%@",content,LSiOSVersion,[LSTools deviceType]] forKey:@"feedback"];
    if(contact!=nil)
    {
        [mDic setObject:contact forKey:@"contact"];
    }
    [mDic setObject:lsSoftwareName forKey:@"source"];
    
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", API_NOT_VERSION_HEADER, lsURLFeedbackByContent_Contact]];
    [self requestWithURL:url requestType:lsRequestTypeFeedbackByContent_Contact params:mDic];
}
#pragma mark 提交设备ID
- (void)LSMCAPNSWithDeviceToken:(NSString*)deviceToken
{
    NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       deviceToken, @"token",
                       lsURLSource, @"source",
                       [[NSString stringWithFormat:@"%@|%@|%@",lsURLSource,deviceToken,lsURLSign] SHA256],@"signValue",
                       nil];
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", API_VERSION_HEADER, lsURLAPNSByDeviceToken]];
    [self requestWithURL:url requestType:lsRequestTypeAPNSByByDeviceToken params:dic];
}



#pragma mark- 私有方法,打印相关信息
- (void)requestInfo:(ASIHTTPRequest*)request
{
    LSLOG(@"请求信息:%@",request);
    [self queueInfo];
}
- (void)queueInfo
{
    LSLOG(@"请求队列信息:%@",networkQueue);
}
#pragma mark- 某一请求开始
- (void)requestDidStart:(ASIHTTPRequest *)request
{
    LSLOG(@"请求类型:[%@]\n状态:请求开始",request.requestType);
    [self requestInfo:request];
}
#pragma mark- 某一请求接收到数据头
- (void)requestDidReceiveResponseHeaders:(ASIHTTPRequest *)request
{
    LSLOG(@"请求类型:[%@]\n状态:接收请求头",request.requestType);
    [self requestInfo:request];
}
#pragma mark- 某一请求***
- (void)requestWillRedirect:(ASIHTTPRequest *)request
{
    LSLOG(@"请求类型:[%@]\n状态:请求***",request.requestType);
    [self requestInfo:request];
}
#pragma mark- 某一请求完成
- (void)requestDidFinish:(ASIHTTPRequest *)request
{
#ifdef LSDEBUG
    if([request.requestType isEqualToString:lsRequestTypeCinemas])
    {
        NSLog(@"===========完成请求影院数据=============");
    }
#endif

    LSLOG(@"请求类型:[%@]\n状态:请求成功",request.requestType);
    [self requestInfo:request];

    id object=nil;//将服务器数据返回信息进行适当处理
    SBJsonParser* parser=[[SBJsonParser alloc] init];
    object=[parser objectWithString:request.responseString];
    [parser release];
    
    id safeObject=nil;
    if(object!=nil)
    {
        //解析成功
        LSLOG(@"\n\n非安全数据\n%@\n\n",object);
        
        Class objectClass=[object class];
        if([objectClass isSubclassOfClass:[NSDictionary class]])
        {
            LSLOG(@"返回数据类型为字典\n");
            
            //说明服务器返回了错误信息
            //服务器返回的状态信息一定是一个字典
            if([object objectForKey:@"status"]!=NULL && [object objectForKey:@"status"]!=[NSNull null] && [[object objectForKey:@"status"] isKindOfClass:[NSDictionary class]] && [[object objectForKey:@"status"] objectForKey:@"code"]!=NULL && [[object objectForKey:@"status"] objectForKey:@"code"]!=[NSNull null])
            {
                LSLOG(@"返回数据类型为异常\n");
                //数据结构
                //{
                //   status = {
                //               code = "-2";
                //               message = "\U7528\U6237\U540d\U6216\U8005\U5bc6\U7801\U6709\U8bef\Uff01";
                //            };
                //}
                
                id statusDic=[object objectForKey:@"status"];
                LSStatus* status=[[[LSStatus alloc] initWithDictionary:statusDic] autorelease];
                safeObject=status;
            }
            else
            {
                safeObject=[NSMutableDictionary dictionaryWithDictionary:object];
                [safeObject makeSafe];
            }
        }
        else if([objectClass isSubclassOfClass:[NSArray class]])
        {
            LSLOG(@"返回数据类型为数组\n");
            
            safeObject=[NSMutableArray arrayWithArray:object];
            [safeObject makeSafe];
        }
        else if([objectClass isSubclassOfClass:[NSString class]])
        {
            LSLOG(@"返回数据类型为字符串\n");
            
            LSError* error=[[[LSError alloc] init] autorelease];
            error.code=LSErrorCodeParseWrong;
            safeObject=error;
        }
    }
    else
    {
        LSLOG(@"返回数据类型为空\n");
        
        LSError* error=[[[LSError alloc] init] autorelease];
        error.code=LSErrorCodeResponseEmpty;
        safeObject=error;
    }
    LSLOG(@"\n\n安全数据\n%@\n\n",safeObject);
    
    
    #pragma mark 根据请求的类型发出通知
    if(request.requestMark!=-1)
    {
        if(![safeObject isKindOfClass:[LSStatus class]] && ![safeObject isKindOfClass:[LSError class]])
        {
            safeObject=[NSDictionary dictionaryWithObjectsAndKeys:safeObject,lsRequestResult,[NSNumber numberWithInt:request.requestMark],lsRequestMark,[NSNumber numberWithInt:request.requestMark2],lsRequestMark2, nil];
        }
    }
    else
    {
        if([request.requestType isEqualToString:lsRequestTypeLoginQQOpenIDByAccessToken])
        {
//            callback( {"client_id":"100218908","openid":"6DB95229E5648DB79098BF4163814AFB"} );
            NSInteger start=[request.responseString rangeOfString:@"{"].location!=NSNotFound?[request.responseString rangeOfString:@"{"].location:0;
            NSInteger end=[request.responseString rangeOfString:@"}"].location!=NSNotFound?[request.responseString rangeOfString:@"}"].location:0;
            if(start<end && start+end<NSNotFound)
            {
                NSString* objectString=[request.responseString substringWithRange:NSMakeRange(start,end-start+1)];
                
                SBJsonParser* parser=[[SBJsonParser alloc] init];
                object=[parser objectWithString:objectString];
                [parser release];
                
                if(object!=nil)
                {
                    //解析成功
                    LSLOG(@"\n\n非安全数据\n%@\n\n",object);
                    
                    Class objectClass=[object class];
                    if([objectClass isSubclassOfClass:[NSDictionary class]])
                    {
                        LSLOG(@"返回数据类型为字典\n");

                        if([object objectForKey:@"status"]!=NULL && [object objectForKey:@"status"]!=[NSNull null] && [[object objectForKey:@"status"] objectForKey:@"code"]!=NULL && [[object objectForKey:@"status"] objectForKey:@"code"]!=[NSNull null])
                        {
                            LSLOG(@"返回数据类型为异常\n");

                            LSStatus* status=[[[LSStatus alloc] init] autorelease];
                            status.code=-INT64_MAX;
                            status.message=[NSString stringWithFormat:@"抱歉，QQ服务器返回了不可识别的信息"];
                            safeObject=status;
                        }
                        else
                        {
                            safeObject=[NSMutableDictionary dictionaryWithDictionary:object];
                            [safeObject makeSafe];
                        }
                    }
                    else if([objectClass isSubclassOfClass:[NSString class]])
                    {
                        LSLOG(@"返回数据类型为字符串\n");
                        
                        LSError* error=[[[LSError alloc] init] autorelease];
                        error.code=LSErrorCodeParseWrong;
                        safeObject=error;
                    }
                }
                else
                {
                    LSLOG(@"返回数据类型为空\n");
                    
                    LSError* error=[[[LSError alloc] init] autorelease];
                    error.code=LSErrorCodeResponseEmpty;
                    safeObject=error;
                }
            }
            else
            {
                LSLOG(@"返回数据类型为空\n");
                
                LSError* error=[[[LSError alloc] init] autorelease];
                error.code=LSErrorCodeResponseEmpty;
                safeObject=error;
            }
            LSLOG(@"\n\n安全数据\n%@\n\n",safeObject);
        }
        else if([request.requestType isEqualToString:lsRequestTypeLoginQQWBUserInfoByCode])
        {
//            access_token=2b587aab1173002e5d1804038ef51fcc&expires_in=8035200&refresh_token=21b2bfc51bf8192a380b9e6ed143f13d&openid=5606cafab48e6916058c553dd2a44db4&name=jiazhoulvguanke&nick=å¿½ç¶ä¹é´&state=
            object=[[[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding] autorelease];
            if(object!=nil)
            {
                LSLOG(@"\n\n非安全数据\n%@\n\n",object);
                safeObject=object;
            }
            
            LSLOG(@"\n\n安全数据\n%@\n\n",safeObject);
        }
        else if([request.requestType isEqualToString:lsRequestTypeLoginSinaWBAccessTokenByCode])
        {
            
        }
        else if([request.requestType isEqualToString:lsRequestTypeOrderOtherPayInfoByOrderID_PayWay_IsCoupon])
        {
            if([safeObject isKindOfClass:[LSStatus class]] || [safeObject isKindOfClass:[LSError class]])
            {
                
            }
            else
            {
#warning 这里需要处理所有的支付类型
                
                if([safeObject objectForKey:@"AlipayInfo"]!=NULL && [[safeObject objectForKey:@"AlipayInfo"] isKindOfClass:[NSDictionary class]])
                {
                    if(![[[safeObject objectForKey:@"AlipayInfo"] objectForKey:@"ALI_INFO"] isEqual:LSNULL])
                    {
                        safeObject=[[safeObject objectForKey:@"AlipayInfo"] objectForKey:@"ALI_INFO"];
                        LSLOG(@"支付宝加密数据\n%@",safeObject);
                    }
                    else
                    {
                        LSLOG(@"返回数据类型为空\n");
                        LSError* error=[[[LSError alloc] init] autorelease];
                        error.code=LSErrorCodeResponseEmpty;
                        safeObject=error;
                    }
                }
                else
                {
                    LSLOG(@"返回数据类型为空\n");
                    LSError* error=[[[LSError alloc] init] autorelease];
                    error.code=LSErrorCodeResponseEmpty;
                    safeObject=error;
                }
            }
        }
        else if([request.requestType isEqualToString:lsRequestTypeUpdateInfo] || [request.requestType isEqualToString:lsRequestTypeFeedbackByContent_Contact])
        {
            //<version>
            //   <android_version>1.1</android_version>
            //   <upgrade_version></upgrade_version>
            //   <android_download_url>
            //            <![CDATA[http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=599209062&mt=8]]>
            //   </android_download_url>
            //   <android_updata_description>
            //            <![CDATA[1.修改影院列表按照距离由近到远显示2.修改部分城市不能显示电影排期的bug]]>
            //   </android_updata_description>
            //</version>
            
            //<?xml version="1.0" encoding="UTF-8"?>
            //   <lashou_tuangou>
            //      <code>5</code>
            //      <message>æä½æå</message>
            //   </lashou_tuangou>
            
            NSXMLParser* parser = [[NSXMLParser alloc] initWithData:request.responseData];
            [parser setDelegate:self];
            [parser setShouldProcessNamespaces:NO];
            [parser setShouldReportNamespacePrefixes:NO];
            [parser setShouldResolveExternalEntities:NO];
            [parser parse];
            NSError* parserError = [parser parserError];
            [parser release];
            
            if(parserError)
            {
                LSError* error=[[[LSError alloc] init] autorelease];
                error.code=LSErrorCodeParseWrong;
                safeObject=error;
            }
            else
            {
                _currentContentOfElement=[[NSMutableString alloc] initWithCapacity:0];
                safeObject=nil;
            }
        }
    }
    
    if(safeObject!=nil)
    {
        //发出通知
        [self postNotificationName:request.requestType object:safeObject];
    }
}

#pragma mark- 某一请求失败
- (void)requestDidFail:(ASIFormDataRequest *)request
{
    LSLOG(@"请求类型:[%@]\n状态:请求失败",request.requestType);
#ifdef LSDEBUG
    if(user.networkStatus!=NotReachable)
    {
        [LSAlertView showWithTag:-1 title:@"请求失败了" message:request.responseString delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    }
#endif
    
    [self requestInfo:request];
#pragma mark 根据请求的类型发出失败通知
    [self postNotificationName:request.requestType object:lsRequestFailed];
}

#pragma mark- 队列请求完成
- (void)queueDidFinish:(ASINetworkQueue *)queue
{
    LSLOG(@"请求队列完成");
}


#pragma mark- NSXMLParser的委托方法
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
	[parser abortParsing];
    
    if(_fuckFeedBackStatus!=nil)
    {
        //发出通知
        [self postNotificationName:lsRequestTypeFeedbackByContent_Contact object:_fuckFeedBackStatus];
        LSRELEASE(_fuckFeedBackStatus)
    }
    else
    {
        //发出通知
        [self postNotificationName:lsRequestTypeUpdateInfo object:nil];
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
	[parser abortParsing];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
	if([elementName isEqualToString:@"code"])
    {
		_fuckFeedBackStatus = [[LSStatus alloc] init];
	}
    else if([elementName isEqualToString:@"version"])
    {
		
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if([elementName isEqualToString:@"code"])
    {
		_fuckFeedBackStatus.code = [_currentContentOfElement integerValue];
	}
    else if([elementName isEqualToString:@"message"])
    {
		_fuckFeedBackStatus.message = _currentContentOfElement;
	}
    else if([elementName isEqualToString:@"android_version"])
    {
		[LSVersion currentVersion].version = _currentContentOfElement;
	}
    else if([elementName isEqualToString:@"android_download_url"])
    {
		[LSVersion currentVersion].downloadURL = _currentContentOfElement;
	}
    else if([elementName isEqualToString:@"android_updata_description"])
    {
		[LSVersion currentVersion].message = _currentContentOfElement;
	}
    [_currentContentOfElement release];
    _currentContentOfElement=[[NSMutableString alloc] initWithCapacity:0];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if(string && ![string isEqualToString:@"\n"])
    {
		[_currentContentOfElement appendString:string];
	}
}

@end
