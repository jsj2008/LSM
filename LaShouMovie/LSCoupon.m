//
//  LSCoupon.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-11-27.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSCoupon.h"

@implementation LSCoupon

@synthesize couponValid=_couponValid;//券有效
@synthesize couponStatus=_couponStatus;//券状态
@synthesize couponType=_couponType;//券类型
@synthesize couponID=_couponID;//券号
@synthesize price=_price;//金额（代金券填，通兑券空）
@synthesize exchangeWay=_exchangeWay;//兑换方式（通兑券有，代金券空）
@synthesize lessPriceRemind=_lessPriceRemind;//补差价提示（通兑券有，代金券空）
@synthesize expireTime=_expireTime;//过期时间

- (id)initWithDictionary:(NSDictionary*)safeDic
{
    self=[super init];
    if(self!=nil)
    {
        self.couponValid=[[safeDic objectForKey:@"isValid"] intValue];//券有效
        self.couponStatus=[[safeDic objectForKey:@"isUsed"] intValue];//券状态
        self.couponType=[[safeDic objectForKey:@"type"] intValue];//券类型
        self.couponID=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"vouchNo"]];//券号
        self.price=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"price"]];//金额（代金券填，通兑券空）
        self.exchangeWay=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"convert"]];//兑换方式（通兑券有，代金券空）
        self.lessPriceRemind=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"charge"]];//补差价提示（通兑券有，代金券空）
        self.expireTime=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"deadline"]];//过期时间
    }
    return self;
}

- (void)dealloc
{
//    self.couponStatus=nil;//券状态
//    self.couponType=nil;//券类型
    self.couponID=nil;//券号
    self.price=nil;//金额（代金券填，通兑券空）
    self.exchangeWay=nil;//兑换方式（通兑券有，代金券空）
    self.lessPriceRemind=nil;//补差价提示（通兑券有，代金券空）
    self.expireTime=nil;//过期时间
    
    [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:_couponValid forKey:@"couponValid"];
    [aCoder encodeInt:_couponStatus forKey:@"couponStatus"];
    [aCoder encodeInt:_couponType forKey:@"couponType"];
    [aCoder encodeObject:_couponID forKey:@"couponID"];
    [aCoder encodeObject:_price forKey:@"price"];
    [aCoder encodeObject:_exchangeWay forKey:@"exchangeWay"];
    [aCoder encodeObject:_lessPriceRemind forKey:@"lessPriceRemind"];
    [aCoder encodeObject:_expireTime forKey:@"expireTime"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self.couponValid=[decoder decodeIntForKey:@"couponValid"];//券有效
    self.couponStatus=[decoder decodeIntForKey:@"couponStatus"];//券状态
    self.couponType=[decoder decodeIntForKey:@"couponType"];//券类型
    self.couponID=[decoder decodeObjectForKey:@"couponID"];//券号
    self.price=[decoder decodeObjectForKey:@"price"];//金额（代金券填，通兑券空）
    self.exchangeWay=[decoder decodeObjectForKey:@"exchangeWay"];//兑换方式（通兑券有，代金券空）
    self.lessPriceRemind=[decoder decodeObjectForKey:@"lessPriceRemind"];//补差价提示（通兑券有，代金券空）
    self.expireTime=[decoder decodeObjectForKey:@"expireTime"];//过期
    return self;
}

@end
