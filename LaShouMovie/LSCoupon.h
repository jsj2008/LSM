//
//  LSCoupon.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-11-27.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSCoupon : NSObject<NSCoding>
{
//    voucher =     {
//        charge = "\U9700\U8865\U5dee\U4ef7\Uffe540";//需补差价
//        convert = "";//兑换规则
//        deadline = "2013-12-11";//有效期
//        isUsed = 1;//是否已用
//        isValid = 1;//是否有效
//        limitnum = 0;//客户端不使用
//        orderid = 0;//客户端不使用
//        price = 20;//代金券金额
//        type = 0;//类型
//        vouchNo = c121;//券号
//    };
    
    LSCouponValid _couponValid;//券有效
    LSCouponStatus _couponStatus;//券状态
    LSCouponType _couponType;//券类型
    NSString* _couponID;//券号
    NSString* _price;//金额（代金券填，通兑券空）
    NSString* _exchangeWay;//兑换方式（通兑券有，代金券空）
    NSString* _lessPriceRemind;//补差价提示（通兑券有，代金券空）
    NSString* _expireTime;//过期时间
}
@property (nonatomic, assign) LSCouponValid couponValid;//券有效
@property (nonatomic, assign) LSCouponStatus couponStatus;//券状态
@property (nonatomic, assign) LSCouponType couponType;//券类型
@property (nonatomic, retain) NSString* couponID;//券号
@property (nonatomic, retain) NSString* price;//金额（代金券填，通兑券空）
@property (nonatomic, retain) NSString* exchangeWay;//兑换方式（通兑券有，代金券空）
@property (nonatomic, retain) NSString* lessPriceRemind;//补差价提示（通兑券有，代金券空）
@property (nonatomic, retain) NSString* expireTime;//过期时间

- (id)initWithDictionary:(NSDictionary*)safeDic;

@end
