//
//  LSEnum.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-12.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LSSeatRowSpace @"space"

#pragma mark- 支付方式
typedef enum
{
    LSPayWayTypeNon     = 0,//未选择
    LSPayWayTypeBalance = 1,//余额
    LSPayWayTypeAlipay  = 2,//支付宝
    LSPayWayTypeTenpay  = 3,//财付通
    LSPayWayTypeUPOMP   = 4,//银联
    LSPayWayTypeBank    = 5 //银行卡
    
} LSPayWayType;

#pragma mark- 提醒出现位置
typedef enum
{
    LSAlertViewFromTop    = 0,//上方
    LSAlertViewFromLeft   = 1,//左方
    LSAlertViewFromBottom = 2,//下方
    LSAlertViewFromRight  = 3 //右方
    
} LSAlertViewFrom;

#pragma mark- 登陆方式
typedef enum
{
    //失败
    LSLoginTypeNon    = 0,//不登陆
    
    //以下三项为联合登陆
    LSLoginTypeSinaWB = 1,//
    LSLoginTypeQQWB   = 2,//
    LSLoginTypeQQ     = 3,//
    
    LSLoginTypeNormal = 4,//普通登陆
    
    //以下一项为支付宝跳转启动
    LSLoginTypeAlipay = 5,//支付宝跳转
    LSLoginTypeAlipayNotActive = 6//支付宝失活状态

} LSLoginType;

#pragma mark- 影片列表样式
typedef enum
{
    LSFilmDisplayTypeList = 0,//海报样式
    LSFilmDisplayTypePoster = 1//列表样式
    
} LSFilmDisplayType;

#pragma mark- 影院数组index
typedef enum
{
    LSCinemaArrayIndexMy=0,
    LSCinemaArrayIndexSeat=1,
    LSCinemaArrayIndexGroup=2,
    LSCinemaArrayIndexSeatGroup=3,
    LSCinemaArrayIndexNon=4
    
}LSCinemaArrayIndex;

#pragma mark- 分享类型
typedef enum
{
    LSShareTypeSinaWB = 0,
    LSShareTypeQQWB   = 1
    
}LSShareType;

#pragma mark- 广告类型
typedef enum
{
    LSAdvertismentTypeNotNeedShow  =-1,//不显示
    LSAdvertismentTypeShowImage    = 0,//显示图片
    LSAdvertismentTypeToFilmView   = 1,//可跳转
    LSAdvertismentTypeToCinemaView = 2,//可跳转
    LSAdvertismentTypeToWapView    = 3,//可跳转
    LSAdvertismentTypeToActivity   = 4 //可跳转
    
}LSAdvertismentType;


#pragma mark- 影片状态
typedef enum
{
    LSFilmShowStatusShowing  = 0,//正在上映
    LSFilmShowStatusWillShow = 1,//即将上映
    
} LSFilmShowStatus;


#pragma mark- 影院状态
typedef enum
{
    LSCinemaStatusSeat  = 0,//可订座
    LSCinemaStatusGroup = 1,//可团购
    LSCinemaStatusAll   = 2 //全部
    
} LSCinemaStatus;

#pragma mark- 影院可买类型
typedef enum
{
    LSCinemaBuyTypeOnlySeat  = 0,//只能订座
    LSCinemaBuyTypeOnlyGroup = 1,//只能团购
    LSCinemaBuyTypeSeatGroup = 2,//团购订座
    LSCinemaBuyTypeNon       = 3 //不可操作
    
} LSCinemaBuyType;

#pragma mark- 影片视觉类型
typedef enum
{
    LSFilmDimensional2D = 0,
    LSFilmDimensional3D = 1
    
} LSFilmDimensional;

#pragma mark- 排期日期
typedef enum
{
    LSScheduleDateToday               = 0,//今天
    LSScheduleDateTomorrow            = 1,//明天
    LSScheduleDateTheDayAfterTomorrow = 2,//后天
    
} LSScheduleDate;

#pragma mark- 座位数据来源
typedef enum
{
    LSApiSourceHuoFengHuang = 0,//火凤凰
    LSApiSourceManTianXing  = 4,//满天星
    LSApiSourceHuoLieNiao   = 6,//火烈鸟
    LSApiSourceJinYi        = 7,//金逸
    LSApiSourceHiMovie      = 8 //HiMovie
}LSApiSource;

#pragma mark- 座位类型
typedef enum
{
    LSSeatTypeNormal=0,   //普通座位
    LSSeatTypeLoveFirst=1,//情侣座首座位
    LSSeatTypeLoveSecond=2//情侣座第二座位
    
}LSSeatType;

#pragma mark- 座位状态
typedef enum
{
    LSSeatStatusNormal = 0,//未选
    LSSeatStatusLove   = 1,//情侣座
    LSSeatStatusSelect = 2,//已选
    LSSeatStatusSold   = 3,//已售
    LSSeatStatusUnable = 4 //不可选
    
} LSSeatStatus;

#pragma mark- 券类型
typedef enum
{
    LSCouponTypeMoney  = 0,//代金券
    LSCouponTypeCommon = 1 //通兑券
    
} LSCouponType;

#pragma mark- 券有效性
typedef enum
{
    LSCouponValidInvalid = 0,//无效
    LSCouponValidValid   = 1,//有效
    
} LSCouponValid;

#pragma mark- 券状态
typedef enum
{
    LSCouponStatusUnuse = 0,//未使用
    LSCouponStatusUsed  = 1,//已使用
    
} LSCouponStatus;

#pragma mark- 是否使用卡券
#define LSOrderUseCouponYes @"T"
#define LSOrderUseCouponNo  @"F"

#pragma mark- 订单状态
typedef enum
{
    LSOrderStatusPaid  = 0,//已付款
    LSOrderStatusUnpay = 1 //未付款
    
} LSOrderStatus;

#pragma mark- 出票状态
typedef enum
{
    LSConfirmStatusDone  = 0,//已经出票
    LSConfirmStatusDoing = 1,//正在出票
    LSConfirmStatusWrong = 2 //错误
    
} LSConfirmStatus;

#pragma mark- 团购状态
typedef enum
{
    LSGroupStatusUnpay = 1,//未付款
    LSGroupStatusPaid  = 2 //已付款
    
} LSGroupStatus;

#pragma mark- 拉手券状态
typedef enum
{
    LSTicketStatusUnuse     = 1,//未使用
    LSTicketStatusUsed      = 2,//已使用
    LSTicketStatusTimeout   = 3,//已过期
    LSTicketStatusRefund    = 4,//已退款
    LSTicketStatusRefunding = 5 //退款中
    
} LSTicketStatus;

#pragma mark- 团购订单状态
typedef enum
{
    LSGroupOrderStatusUnpay   = 0,//未付款
    LSGroupOrderStatusPartpay = 1,//付款进行中
    LSGroupOrderStatusPaid    = 2 //已付款
} LSGroupOrderStatus;

@interface LSEnum : NSObject

@end
