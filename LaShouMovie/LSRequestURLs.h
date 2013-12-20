//
//  LSRequestURLs.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-8-22.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define lsURLSource             @"100"
#define lsURLSign               @"SJFJS12JK3HJ23GF213GGH2H23@#LLOO"
#define lsURLSTID               [LSTools stid]

#pragma mark- 影片相关
#define lsURLFilmsByStatus                      @"/Film/filmListA"
#define lsURLFilmInfoByFilmID                   @"/Film/filmDetail"
#define lsURLFilmCinemasByFilmID                @"/Film/getClientScheduleByFilmIdA"

#pragma mark- 影院相关
#define lsURLCinemas                            @"/Cinema/getClientCinemaList"
#define lsURLCinemaFilmsByCinemaID              @"/Cinema/showInfo"

#pragma mark- 排期相关
#define lsURLSchedulesByCinemaID_FilmID         @"/Cinema/getClientScheduleA"

#pragma mark- 座位相关
#define lsURLSeatsByDate_CinemaID_HallID                                    @"/Seat/seatList"
#define lsURLSeatSelectSeatsByApiSource_ScheduleID_SectionID                @"/Seat/selectedSeats"

#pragma mark- 订单相关
#define lsURLOrdersByType_Offset_PageSize                                   @"/MyList/orderList"
#define lsURLOrderCount                                                     @"/MyList/orderListCount"
#define lsURLOrderCreateByScheduleID_SectionID_Seats_Mobile_OnSale          @"/Order/createOrder"
#define lsURLOrderCancelByOrderID                                           @"/Order/cancelOrder"
#define lsURLOrderAlipayInfoByOrderID                                       @"/AlipayInfo/getTheAlipaySdkUrl"

#pragma mark- 团购相关
#define lsURLGroupsByType_Offset_PageSize                                   @"/GroupOrder/orderList"
#define lsURLGroupInfoByGroupID                                             @"/Cinema/getGoodsDetail"
//#define lsURLGroupCreateByGroupID_Amount                                    @"/GroupOrder/createOrder"
#define lsURLGroupCreateByGroupID_Amount                                    @"/GroupOrder/createOrderApi"
#define lsURLGroupInfoByOrderID                                             @"/GroupOrder/getOrderDetail"
//#define lsURLGroupCancelByOrderID                                           @"/GroupOrder/cancelOrder"                                                                          
#define lsURLGroupCancelByOrderID                                           @"/GroupOrder/cancelOrderByApi"

#pragma mark- 拉手券相关
#define lsURLTicketsByType_Offset_PageSize                                  @"/GroupOrder/lashouCodeList"
#define lsURLTicketPasswordByTicketID                                       @"/GroupOrder/sendLashouCodePwd"


#pragma mark- 支付相关
#define lsURLPayBalancePayByOrderID_SecurityCode                @"/Pay/goPay"

#pragma mark- 优惠券相关
#define lsURLCouponUseByOrderID_CinemaID_CouponID               @"/Voucher/getVouchersFromClients"
#define lsURLCouponCancelByOrderID_CinemaID_CouponID            @"/Voucher/unOutfLockVoucher"

#pragma mark- 卡券相关
#define lsURLAlipayCreateCardByOrderID                          @"/Alipass/getTheOpenSwitch"

#pragma mark- 登陆相关
#define lsURLRegisterByUserName_Password_Email                  @"/Profile/register"
#define lsURLLoginNormalLoginByUserName_Password                @"/Profile/login"
#define lsURLLoginUnionLoginByUserID_UserName_Type              @"/Joinlogin/login"

#define lsURLLoginQQOpenIDByAccessToken                         @"https://graph.qq.com/oauth2.0/me"
#define lsURLLoginQQUserInfoByAppID_AccessToken_OpenID          @"https://graph.qq.com/user/get_user_info"

#define lsURLLoginQQWBUserInfoByCode                            @"https://open.t.qq.com/cgi-bin/oauth2/access_token"

#define lsURLLoginSinaWBAccessTokenByCode                       @"https://api.weibo.com/oauth2/access_token"
#define lsURLLoginSinaWBUserInfoByAccessToken_UserID            @"https://api.weibo.com/2/users/show.json?"

#define lsURLLoginAlipayUserInfoByAppID_AuthCode                @"/alipay-sdk/AopSdk.php"

#pragma mark- 分享相关
#define lsURLShareSinaWBShareByMessage_Img                      @"https://api.weibo.com/2/statuses/update.json"
#define lsURLShareQQWBShareByMessage_Img                        @"https://open.t.qq.com/api/t/add_pic_url"

#pragma mark- 用户信息相关
#define lsURLUserProfile                                        @"/Profile/index"

#pragma mark- 手机号相关
#define lsURLMobileSecurityCodeByOldPhone_NewPhone              @"/Mobile/sendCode"
#define lsURLMobileBindByOldPhone_NewPhone_SecurityCode         @"/Mobile/bind"

#pragma mark- 广告栏相关
#define lsURLAdvertisements                     @"/Banner/getOneBanner"
#define lsURLADCinemaDetailByCinemaID           @"/Banner/getCinemaDetailByCid"
#define lsURLADFilmDetailByFilmID               @"/Banner/getFilmDetailByFilmId"
#define lsURLADActivityWapByActivityID          @"/Banner/showMactivityWap"//此接口将会在wap照片那个直接load

#pragma mark- 城市相关
#define lsURLCities                             @"/City/cityList"
#define lsURLCityCityIDByName                   @"/City/getTheCityId"

#pragma mark- 其他
#define lsURLUpdateAction                       @"/Update/updateVersion"
#define lsURLUpdateInfo                         @"/index.php/version/utfversion"
#define lsURLFeedbackByContent_Contact          @"/index.php/feedback/index/"
#define lsURLAPNSByDeviceToken                  @"/Apns/collectAllDeviceToken"



@interface LSRequestURLs : NSObject

//路径拼装规则
//1; lsRequestFilms  @"/Film/filmListA" 前有‘/’后无‘/’
//2; [LSTools stid]直接使用

@end
