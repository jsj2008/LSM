//
//  LSMessageCenter.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-8-22.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LSStatus.h"
#import "LSError.h"


#pragma mark- 全局的通知名，非网络通知
#define LSNotificationAlipaySuccess             @"LSNotificationAlipaySuccess"
#define LSNotificationAlipayUserInfo            @"LSNotificationAlipayUserInfo"

#define LSNotificationNetworkStatusChanged      @"LSNotificationNetworkStatusChanged"
#define LSNotificationLocationChanged           @"LSNotificationLocationChanged"
#define LSNotificationCityChanged               @"LSNotificationCityChanged"
#define LSNotificationOrderTimeChanged          @"LSNotificationOrderTimeChanged"

#pragma mark- 联合登陆的第三方应用授权ID
#define LSQQAppID                   @"218908"//@"100367640"//
#define LSQQAppKey                  @"21c8b7466c553c29074f923d6f048267"//@"e5cf54420053cc8d33a9d7a8ec755093"//

#define LSQQWBConsumerKey           @"b5269a602928480f83d3dc98a1fe3e54"//@"801306401"//
#define LSQQWBConsumerSecret        @"bfc03eea29a5e81ea3735f3c47ef92ca"//@"f9264b0af5c892691b39a57988e3a399"//

#define LSSinaWBConsumerKey			@"54350967"//@"1573238093"//
#define LSSinaWBConsumerSecret	    @"6182161ee19104fd4c80573561fdd67a"//@"d14e2dbd930cc73f08c1b3a52091bdef"//


#pragma mark- 请求的状态参数
#define lsRequestSuccess        @"Success"
#define lsRequestFailed         @"Failed"
#define lsRequestTimeout        @"Timeout"
#define lsRequestResult         @"Result"
#define lsRequestMark           @"Mark"
#define lsRequestMark2          @"Mark2"
#define lsRequestStatus         @"Status"
#define lsRequestError          @"Error"

#pragma mark- 请求类型

#pragma mark 影片相关
#define lsRequestTypeFilmsByStatus                      @"lsRequestTypeFilmsByStatus"
#define lsRequestTypeFilmInfoByFilmID                   @"lsRequestTypeFilmInfoByFilmID"
#define lsRequestTypeFilmCinemasByFilmID                @"lsRequestTypeFilmCinemasByFilmID"

#pragma mark 影院相关
#define lsRequestTypeCinemas                            @"lsRequestTypeCinemas"
#define lsRequestTypeCinemaFilmsByCinemaID              @"lsRequestTypeCinemaFilmsByCinemaID"

#pragma mark 排期相关
#define lsRequestTypeSchedulesByCinemaID_FilmID         @"lsRequestTypeSchedulesByCinemaID_FilmID"

#pragma mark 座位相关
#define lsRequestTypeSeatsByDate_CinemaID_HallID                          @"lsRequestTypeSeatsByDate_CinemaID_HallID"
#define lsRequestTypeSeatSelectSeatsByApiSource_ScheduleID_SectionID      @"lsRequestTypeSeatSelectSeatsByApiSource_ScheduleID_SectionID"

#pragma mark- 订单相关
#define lsRequestTypeOrdersByType_Offset_PageSize                                    @"lsRequestTypeOrdersByType_Offset_PageSize"
#define lsRequestTypeOrderCount                                                      @"lsRequestTypeOrderCount"
#define lsRequestTypeOrderCreateOrderByScheduleID_SectionID_Seats_Mobile_OnSale      @"lsRequestTypeOrderCreateOrderByScheduleID_SectionID_Seats_Mobile_OnSale"
#define lsRequestTypeOrderCancelByOrderID                                            @"lsRequestTypeOrderCancelByOrderID"
#define lsRequestTypeOrderOtherPayInfoByOrderID_PayWay_IsCoupon                                      @"lsRequestTypeOrderOtherPayInfoByOrderID_PayWay_IsCoupon"

#pragma mark- 团购相关
#define lsRequestTypeGroupsByType_Offset_PageSize                   @"lsRequestTypeGroupsByType_Offset_PageSize"
#define lsRequestTypeGroupInfoByGroupID                             @"lsRequestTypeGroupInfoByGroupID"
#define lsRequestTypeGroupCreateByGroupID_Amount                    @"lsRequestTypeGroupCreateByGroupID_Amount"
#define lsRequestTypeGroupInfoByOrderID                             @"lsRequestTypeGroupInfoByOrderID"
#define lsRequestTypeGroupCancelByOrderID                           @"lsRequestTypeGroupCancelByOrderID"

#pragma mark- 拉手券相关
#define lsRequestTypeTicketsByType_Offset_PageSize                  @"lsRequestTypeTicketsByType_Offset_PageSize"
#define lsRequestTypeTicketPasswordByTicketID                       @"lsRequestTypeTicketPasswordByTicketID"

#pragma mark- 支付相关
#define lsRequestTypePayBalancePayByOrderID_IsCoupon_SecurityCode            @"lsRequestTypePayBalancePayByOrderID_IsCoupon_SecurityCode"

#pragma mark- 优惠券相关
#define lsRequestTypeCouponUseByOrderID_CinemaID_CouponID           @"lsRequestTypeCouponUseByOrderID_CinemaID_CouponID"
#define lsRequestTypeCouponCancelByOrderID_CinemaID_CouponID        @"lsRequestTypeCouponCancelByOrderID_CinemaID_CouponID"

#pragma mark- 卡券相关
#define lsRequestTypeAlipayCreateCardByOrderID                      @"lsRequestTypeAlipayCreateCardByOrderID"

#pragma mark- 登陆相关
#define lsRequestTypeRegisterByUserName_Password_Email              @"lsRequestTypeRegisterByUserName_Password_Email"
#define lsRequestTypeLoginNormalLoginByUserName_Password            @"lsRequestTypeLoginNormalLoginByUserName_Password"
#define lsRequestTypeLoginUnionLoginByUserID_UserName_Type          @"lsRequestTypeLoginUnionLoginByUserID_UserName_Type"

#define lsRequestTypeLoginQQOpenIDByAccessToken                     @"lsRequestTypeLoginQQOpenIDByAccessToken"
#define lsRequestTypeLoginQQUserInfoByAppID_AccessToken_OpenID      @"lsRequestTypeLoginQQUserInfoByAppID_AccessToken_OpenID"

#define lsRequestTypeLoginQQWBUserInfoByCode                        @"lsRequestTypeLoginQQWBUserInfoByCode"

#define lsRequestTypeLoginSinaWBAccessTokenByCode                   @"lsRequestTypeLoginSinaWBAccessTokenByCode"
#define lsRequestTypeLoginSinaWBUserInfoByAccessToken_UserID        @"lsRequestTypeLoginSinaWBUserInfoByAccessToken_UserID"

#define lsRequestTypeLoginAlipayUserInfoByAppID_AuthCode            @"lsRequestTypeLoginAlipayUserInfoByAppID_AuthCode"

#pragma mark- 分享相关
#define lsRequestTypeShareSinaWBShareByMessage_Img                  @"lsRequestTypeShareSinaWBShareByMessage_Img"
#define lsRequestTypeShareQQWBShareByMessage_Img                    @"lsRequestTypeShareQQWBShareByMessage_Img"

#pragma mark- 用户信息相关
#define lsRequestTypeUserProfile                                    @"lsRequestTypeUserProfile"

#pragma mark- 手机号相关
#define lsRequestTypeMobileSecurityCodeByOldPhone_NewPhone          @"lsRequestTypeMobileSecurityCodeByOldPhone_NewPhone"
#define lsRequestTypeMobileBindByOldPhone_NewPhone_SecurityCode     @"lsRequestTypeMobileBindByOldPhone_NewPhone_SecurityCode"

#pragma mark- 广告栏相关
#define lsRequestTypeAdvertisements                @"lsRequestTypeAdvertisements"
#define lsRequestTypeADCinemaDetailByCinemaID      @"lsRequestTypeADCinemaDetailByCinemaID"
#define lsRequestTypeADFilmDetailByFilmID          @"lsRequestTypeADFilmDetailByFilmID"

#pragma mark- 城市相关
#define lsRequestTypeCities                        @"lsRequestTypeCities"
#define lsRequestTypeCityCityIDByName              @"lsRequestTypeCityCityIDByName"

#pragma mark- 其他
#define lsRequestTypeUpdateAction                  @"lsRequestTypeUpdateAction"
#define lsRequestTypeUpdateInfo                    @"lsRequestTypeUpdateInfo"
#define lsRequestTypeFeedbackByContent_Contact     @"lsRequestTypeFeedbackByContent_Contact"
#define lsRequestTypeAPNSByByDeviceToken           @"lsRequestTypeAPNSByByDeviceToken"

@interface LSMessageCenter : NSObject<NSXMLParserDelegate>
{
    NSMutableString* _currentContentOfElement;
    LSStatus* _fuckFeedBackStatus;
}

#pragma mark- 类方法
+ (LSMessageCenter *)defaultCenter;

#pragma mark- 覆载方法
//自定义通知相关函数
- (void)postNotificationName:(NSString *)aName object:(id)anObject;
- (void)addObserver:(id)observer selector:(SEL)aSelector name:(NSString *)aName object:(id)anObject;
- (void)removeObserver:(id)observer;
- (void)removeObserver:(id)observer name:(NSString *)aName object:(id)anObject;

#pragma mark/ 请求方法
#pragma mark- 影片相关
- (void)LSMCFilmsWithStatus:(LSFilmShowStatus)status;
- (void)LSMCFilmInfoWithFilmID:(NSString*)filmID;
- (void)LSMCFilmCinemasWithFilmID:(NSString*)filmID;

#pragma mark- 影院相关
- (void)LSMCCinemas;
- (void)LSMCCinemaFilmsWithCinemaID:(NSString*)cinemaID;

#pragma mark- 排期相关
- (void)LSMCSchedulesWithCinemaID:(NSString*)cinemaID filmID:(NSString*)filmID mark:(int)mark;

#pragma mark- 座位相关
- (void)LSMCSeatsWithDate:(NSString*)date cinemaID:(NSString*)cinemaID hallID:(NSString*)hallID;
- (void)LSMCSeatSelectSeatsWithApiSource:(LSApiSource)apiSource scheduleID:(NSString*)scheduleID;

#pragma mark- 订单相关
- (void)LSMCOrdersWithStatus:(LSOrderStatus)status offset:(int)offset pageSize:(int)pageSize;
- (void)LSMCOrderCount;
- (void)LSMCOrderCreateWithScheduleID:(NSString*)scheduleID sectionID:(NSString*)sectionID seats:(NSString*)seats mobile:(NSString*)mobile isOnSale:(BOOL)isOnSale;
- (void)LSMCOrderOtherPayInfoWithOrderID:(NSString*)orderID payWay:(LSPayWayType)payWay isUseCoupon:(NSString*)isUseCoupon;

#pragma mark- 团购相关
- (void)LSMCGroupsWithStatus:(LSGroupStatus)status offset:(int)offset pageSize:(int)pageSize;
- (void)LSMCGroupInfoWithGroupID:(NSString*)groupID;
- (void)LSMCGroupCreateWithGroupID:(NSString*)groupID amount:(int)amount;
- (void)LSMCGroupInfoWithOrderID:(NSString*)orderID;
- (void)LSMCGroupCancelWithOrderID:(NSString*)orderID;

#pragma mark- 拉手券相关
- (void)LSMCTicketsWithStatus:(LSTicketStatus)status offset:(int)offset pageSize:(int)pageSize;
- (void)LSMCTicketPasswordWithTicketID:(NSString*)ticketID;

#pragma mark- 支付相关
- (void)LSMCPayBalancePayWithOrderID:(NSString*)orderID isUseCoupon:(NSString*)isUseCoupon securityCode:(NSString*)securityCode;

#pragma mark- 优惠券相关
- (void)LSMCCouponUseWithOrderID:(NSString*)orderID cinemaID:(NSString*)cinemaID couponID:(NSString*)couponID;
- (void)LSMCCouponCancelWithOrderID:(NSString*)orderID cinemaID:(NSString*)cinemaID couponID:(NSString*)couponID;

#pragma mark- 卡券相关
- (void)LSMCAlipayCreateCardWithOrderID:(NSString*)orderID;

#pragma mark- 登陆相关
- (void)LSMCRegisterWithUserName:(NSString*)userName password:(NSString*)password email:(NSString*)email;
- (void)LSMCLoginWithUserName:(NSString*)userName password:(NSString*)password;
- (void)LSMCLoginWithUserID:(NSString*)userID userName:(NSString*)userName type:(LSLoginType)type;

- (void)LSMCLoginQQOpenIDWithAccessToken:(NSString*)accessToken;
- (void)LSMCLoginQQUserInfoWithAppID:(NSString*)appID accessToken:(NSString*)accessToken openID:(NSString*)openID;

- (void)LSMCLoginQQWBUserInfoWithCode:(NSString*)code;

- (void)LSMCLoginSinaWBAccessTokenWithCode:(NSString*)code;
- (void)LSMCLoginSinaWBUserInfoWithAccessToken:(NSString*)accessToken userID:(NSString*)userID;

- (void)LSMCLoginAlipayUserInfoWithAppID:(NSString*)appID authCode:(NSString*)authCode;

#pragma mark- 分享相关
- (void)LSMCShareSinaWBShareWithMessage:(NSString*)message img:(NSString*)imgURL;
- (void)LSMCShareQQWBShareWithMessage:(NSString*)message img:(NSString*)imgURL;

#pragma mark- 用户信息相关
- (void)LSMCUserProfile;

#pragma mark- 手机号相关
- (void)LSMCMobileSecurityCodeWithOldPhone:(NSString*)oldPhone newPhone:(NSString*)newPhone;
- (void)LSMCMobileBindWithOldPhone:(NSString*)oldPhone newPhone:(NSString*)newPhone securityCode:(NSString*)securityCode;

#pragma mark- 广告相关
- (void)LSMCAdvertisements;
- (void)LSMCADCinemaDetailWithCinemaID:(NSString*)cinemaID;
- (void)LSMCADFilmDetailWithFilmID:(NSString*)filmID;
- (NSURLRequest*)LSMCActivityWapWithActivityID:(NSString*)activityID;

#pragma mark- 城市相关
- (void)LSMCCities;
- (void)LSMCCityCityIDWithName:(NSString*)cityName;

#pragma mark- 其他
- (void)LSMCUpdateAction;
- (void)LSMCUpdateInfo;
- (void)LSMCFeedbackWithContent:(NSString*)content contact:(NSString*)contact;
- (void)LSMCAPNSWithDeviceToken:(NSString*)deviceToken;

@end
