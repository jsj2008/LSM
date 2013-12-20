//
//  LSGroupOrder.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-10.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LSGroupOrder : NSObject
{
    //未付款订单
//    {
//        aleadyPay = 0;
//        amount = 1;
//        "buy_time" = 1381298687;
//        "goods_id" = 7752928;
//        "goods_title" = "\U5927\U5730\U6570\U5b57\U5f71\U9662\U89c2\U5f711\U4eba\U6b21\Uff01\U4e0a\U6d773\U5e97\U901a\U7528\Uff01";
//        orderStatus = 0;
//        shouldPay = "29.5";
//        totalPrice = "29.50";
//        "trade_no" = 7752928cc9wee488687;
//        userBalance = "0.00";
//    }
    
    //生成订单
//    {
//        aleadyPay = "0.0";
//        amount = 1;
//        "buy_time" = 1381549960;
//        "goods_title" = "\U62a0\U7535\U5f71\Uff1a6\U5e97\U7535\U5f71\U5728\U7ebf\U9009\U5ea7\U5238\Uff0c\U65e0\U9700\U9884\U7ea6";
//        totalPrice = "29.90";
//        "trade_no" = 7587103914e54be9960;
//        userBalance = "0.00";
//    }
    
    NSString* _groupID;//团ID
    NSString* _groupTitle;//团标题
    
    NSString* _orderID; //订单号
    
    NSDate* _buyTime;//购买时间
    NSString* _amount;//购买数量
    NSString* _totalPrice;//总价
    CGFloat _hadPay;//已支付
    CGFloat _userBalance; //用户账户余额
    NSString* _needPay;//需支付
    
//    orderStatus
//    0表示完全未付款
//    1表示付款进行中
//    2表示付款已完成
    LSGroupOrderStatus _orderStatus;//订单状态
    BOOL _isPaid;//是否已经付款
}
@property(nonatomic,retain) NSString* groupID;
@property(nonatomic,retain) NSString* groupTitle;

@property(nonatomic,retain) NSString* orderID;

@property(nonatomic,retain) NSDate* buyTime;
@property(nonatomic,retain) NSString* amount;
@property(nonatomic,retain) NSString* totalPrice;
@property(nonatomic,assign) CGFloat hadPay;
@property(nonatomic,assign) CGFloat userBalance;
@property(nonatomic,retain) NSString* needPay;
@property(nonatomic,assign) LSGroupOrderStatus orderStatus;
@property(nonatomic,assign) BOOL isPaid;


- (id)initWithDictionary:(NSDictionary*)safeDic;

@end
