//
//  LSOrder.h
//  LaShouMovie
//
//  Created by Li XiangYu on 13-9-15.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LSCinema.h"
#import "LSFilm.h"
#import "LSSchedule.h"
#import "LSSection.h"

@interface LSOrder : NSObject<NSCoding>
{
    LSCinema* _cinema; //影院信息
    LSFilm* _film; //影片信息
    LSSchedule* _schedule;//排期信息
    
    //本地生成的字段
    NSArray* _sectionArray;//区信息(所有的区域)
    int _maxTicketNumber;//综合得出的可选最多座位数
    NSArray* _rowIDArray;//综合得出的全部座位行ID数组
    NSDictionary* _selectSeatArrayDic;//选择的座位
    NSString* _originTotalPrice;//因为增加了优惠券，所以需要一个标记来记录最原始的价格
    NSString* _totalPrice;//价格会随着选座变化。自动填充
    
    NSArray* _couponArray;//使用的优惠券
    NSString* _isUseCoupon;//是否使用优惠券
   
    /* 数据格式
     
//    生成订单的简易数据
//    {
//        trade = {
//            "expire_time" = 1380190174;
//            "buy_time" = 1381298687;//相对于1970
//            "service_time" = 1380189274;
//            "total_fee" = "60.00";
//            "trade_no" = C1339d8b9757e;
//            "trade_time" = 1380189274;
//            userBalance = "1092.00";
//        };
//    }
    
    //已付款订单列表
//    {
//        bookingId = "\U7a7a";
//        cinema =             {
//            address = "\U5317\U4eac\U5e02\U6d77\U6dc0\U533a\U590d\U5174\U8def51\U53f7\U51ef\U5fb7\U6676\U54c1\U8d2d\U7269\U4e2d\U5fc3
//            \n";
//            cinemaId = 3844;
//            cinemaName = "\U5317\U4eac\U535a\U7eb3\U5f71\U57ce(\U6676\U54c1\U5e97)";
//            latitude = "39.914174";
//            longitude = "116.303135";
//            phone = "010-88178889";
//        };
//        confirmationId = "";
//        film =             {
//            filmId = 2038;
//            filmName = "\U795e\U5947";
//        };
//        message = "\U53d6\U7968\U7801\U83b7\U53d6\U4e2d\Uff0c\U8bf7\U7a0d\U540e";
//        schedule =             {
//            dimensional = 1;
//            duration = 105;//影片时长怎么放在这里了
//            expectEndTime = "01:55";
//            hall =                 {
//                hallId = 2;
//                hallName = "2\U53f7\U5385";
//            };
//            imax = 0;
//            language = "\U56fd\U8bed";
//            seqNo = 55620130929022426;
//            startDate = "\U6682\U65e0\U4fe1\U606f";
//            startTime = "00:00";
//        };
//        section =             {
//            seats =                 (
//                                     {
//                                         columnId = 01;
//                                         rowId = 1;
//                                     },
//                                     {
//                                         columnId = 02;
//                                         rowId = 1;
//                                     }
//                                     );
//            sectionId = 01;
//            sectionName = "\U666e\U901a\U533a";
//        };
//        status = 2;
//        "total_fee" = "0.02";
//        "trade_no" = C134024d567ae;
//        "trade_time" = 1380683695;
//    }
    
    //未付款订单列表
//    {
//        cinema =          {
//            address = "\U5317\U4eac\U4e30\U53f0\U533a\U9a6c\U5bb6\U5821\U4e1c\U8def101\U53f7\U966210\U53f7\U5546\U4e1a\U697c\U94f6\U6cf0\U767e\U8d27F6";
//            cinemaId = 3864;
//            cinemaName = "\U534e\U8c0a\U5144\U5f1f\U5f71\U9662\U5317\U4eac\U6d0b\U6865\U5e97";
//            latitude = "39.897639";
//            longitude = "116.447729";
//            phone = "010-56530888";
//        };
//        "expire_time" = 1380807603;
//        film =            {
//            filmId = 2036;
//            filmName = "\U72c4\U4ec1\U6770\U4e4b\U795e\U90fd\U9f99\U738b";
//        };
//        schedule =             {
//            dimensional = 1;
//            duration = 120;
//            expectEndTime = "00:20";
//            hall =                 {
//                hallId = 4;
//                hallName = "4\U53f7\U5385";
//            };
//            imax = 0;
//            language = "\U56fd\U8bed";
//            seqNo = 64120130930051254;
//            startDate = "2013-10-03";
//            startTime = "22:05";
//        };
//        section =             {
//            seats =                 (
//                                     {
//                                         columnId = 08;
//                                         rowId = 7;
//                                     }
//                                     );
//            sectionId = 01;
//            sectionName = "\U666e\U901a\U533a";
//        };
//        "service_time" = 1380806942;
//        status = 0;
//        "total_fee" = "55.00";
//        "trade_no" = C13400decf1ba;
//        "trade_time" = 1380806703;
//    }
    
*/
    //服务器返回与计算
    NSString* _orderID; //订单编号
    NSTimeInterval _timeOffset;//服务器时间差与本地时间差
    NSDate* _serverTime; //服务器时间
    NSDate* _orderTime; //下单时间
    NSDate* _expireTime; //过期时间
    BOOL _isExpire; //是否已过期
    CGFloat _userBalance; //用户账户余额
    CGFloat _needPay;//需支付
    
    NSString* _confirmationID;//取票码(取票码需要考虑“”状态)
    NSString* _message;//服务器返回的关于账单的出票信息
}

@property (nonatomic, retain) LSCinema* cinema;//影院
@property (nonatomic, retain) LSFilm* film;//影片
@property (nonatomic, retain) LSSchedule* schedule;//排期

@property (nonatomic, retain) NSArray* sectionArray;//
@property (nonatomic, assign) int maxTicketNumber;
@property (nonatomic, retain) NSArray* rowIDArray;
@property (nonatomic, retain) NSDictionary* selectSeatArrayDic;//
@property (nonatomic, copy) NSString* originTotalPrice;//总价
@property (nonatomic, retain) NSString* totalPrice;//总价
@property (nonatomic, retain) NSArray* couponArray;//使用优惠券
@property (nonatomic, retain) NSString* isUseCoupon;//是否使用优惠券

@property (nonatomic, retain) NSString* orderID; //订单编号
@property (nonatomic, assign) NSTimeInterval timeOffset; //服务器时间与本地时间的时间差
@property (nonatomic, retain) NSDate* serverTime; //服务器时间
@property (nonatomic, retain) NSDate* orderTime; //下单时间
@property (nonatomic, retain) NSDate* expireTime; //过期时间
@property (nonatomic, assign) BOOL isExpire; //是否已过期
@property (nonatomic, assign) CGFloat userBalance; //用户账户余额
@property (nonatomic, assign) CGFloat needPay;//需支付

@property (nonatomic, retain) NSString* confirmationID;
@property (nonatomic, retain) NSString* message;

- (id)initWithDictionaryOfPaid:(NSDictionary*)safeDic;
- (id)initWithDictionaryOfUnpay:(NSDictionary*)safeDic;

- (NSInteger)expireSecond;
- (void)completePropertyWithDictionary:(NSDictionary*)safeDic;

@end
