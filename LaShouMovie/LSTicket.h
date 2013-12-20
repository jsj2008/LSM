//
//  LSTicket.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-16.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSTicket : NSObject<NSCoding>
{
//    "buy_time" = 1381737360;
//    "code_id" = 1555529738;
//    "code_password" = "\U8be6\U89c1\U77ed\U4fe1";
//    "code_status" = 1;
//    "consume_time" = "\U6682\U65e0\U4fe1\U606f";
//    "expire_time" = "2014-12-31 23:00:00";
//    goodsTips = "这是一个网页";
//    "goods_id" = 682831;
//    "goods_title" = "\U4ec5\U552e49\U5143\Uff01\U539f\U4ef7\U6700\U9ad8112\U5143\U7684\U4eca\U5178\U82b1\U56ed\U5e97\U7535\U5f71\U5927\U7247\U7279\U4ef7\U4f9b\U5e94\Uff0c\U5148\U5230\U5148\U5f97\Uff01";
//    imageSmall = "http://s1.lashouimg.com/zt_mobile_110/201209/20/134812583860408800.jpg";
//    initialPrice = "112.00";
//    isAutoRefund = 1;
//    isSevenRefund = 1;
//    price = "49.00";
//    "sp_address" = "这是一个网页";
//    "sp_allBranch" =             (
//    );
//    "sp_name" = "\U4eca\U5178\U7535\U5f71\U9662";
//    "sp_open_time" = "";
//    "sp_phone" = "";
//    "trade_no" = 68283144b8w6e47347;

    NSString* _groupID;//团ID
    NSString* _groupTitle;//团标题
    
    NSString* _orderID;//订单ID
    
    NSString* _ticketID;//拉手券号
    NSString* _ticketPassword;
    
    NSString* _smallImageURL;//小图
    CGFloat _initialPrice;//原价
    CGFloat _price;//终价
    BOOL _isSevenRefund;//是否支持七天退款
    BOOL _isAutoRefund;//是否支持自动退款
    NSString* _openTime; //商家营业时间
    NSDate* _buyTime;//购买时间
    NSString* _expireTime;//过期时间
    NSString* _consumeTime;//消费时间
    NSString* _goodsTips;//温馨提示
    NSString* _phone;//客服
    
    NSArray* _branchArray;//商家
    
//    ticketStatus
//    0表示已禁用
//    1表示未使用
//    2表示已使用
//    3表示已退款
//    4表示退款中
    LSTicketStatus _ticketStatus;//拉手券状态
}
@property(nonatomic,retain) NSString* groupID;//团ID
@property(nonatomic,retain) NSString* groupTitle;//团标题

@property(nonatomic,retain) NSString* orderID;//订单ID

@property(nonatomic,retain) NSString* ticketID;//拉手券号
@property(nonatomic,retain) NSString* ticketPassword;

@property(nonatomic,retain) NSString* smallImageURL;//小图
@property(nonatomic,assign) CGFloat initialPrice;//原价
@property(nonatomic,assign) CGFloat price;//终价
@property(nonatomic,assign) BOOL isSevenRefund;//是否支持七天退款
@property(nonatomic,assign) BOOL isAutoRefund;//是否支持自动退款
@property(nonatomic,retain) NSString* openTime; //商家营业时间
@property(nonatomic,retain) NSDate* buyTime;//购买时间
@property(nonatomic,retain) NSString* expireTime;//过期时间
@property(nonatomic,retain) NSString* consumeTime;//消费时间
@property(nonatomic,retain) NSString* goodsTips;//温馨提示
@property(nonatomic,retain) NSString* phone;//客服

@property(nonatomic,retain) NSArray* branchArray;//商家
@property(nonatomic,assign) LSTicketStatus ticketStatus;//拉手券状态

- (id)initWithDictionary:(NSDictionary*)safeDic;

@end
