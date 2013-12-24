//
//  LSOrder.m
//  LaShouMovie
//
//  Created by Li XiangYu on 13-9-15.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSOrder.h"
#import "LSCoupon.h"

@implementation LSOrder

@synthesize cinema=_cinema;//影院
@synthesize film=_film;//影片
@synthesize schedule=_schedule;//排期

@synthesize section=_section;
@synthesize sectionArray=_sectionArray;
@synthesize selectSeatArray=_selectSeatArray;//
@synthesize originTotalPrice=_originTotalPrice;
@synthesize totalPrice=_totalPrice;//总价
@synthesize couponArray=_couponArray;
@synthesize isUseCoupon=_isUseCoupon;

@synthesize orderID=_orderID; //订单编号
@synthesize timeOffset=_timeOffset; //服务器时间与本地时间的时间差
@synthesize serverTime=_serverTime;
@synthesize orderTime=_orderTime; //下单时间
@synthesize expireTime=_expireTime; //过期时间
@synthesize isExpire=_isExpire; //是否已过期
@synthesize userBalance=_userBalance; //用户账户余额
@synthesize needPay=_needPay;//需支付

@synthesize confirmationID=_confirmationID;
@synthesize message=_message;

#pragma mark- 属性方法
- (void)setSelectSeatArray:(NSArray *)selectSeatArray
{
    if(![_selectSeatArray isEqual:selectSeatArray])
    {
        if(_selectSeatArray!=nil)
        {
            LSRELEASE(_selectSeatArray)
        }
        _selectSeatArray=[selectSeatArray retain];
    }
    //自动填充
    self.totalPrice=[[NSString stringWithFormat:@"%.2f",_selectSeatArray.count*[_schedule.price floatValue]] stringByReplacingOccurrencesOfString:@".00" withString:@""];
}

- (void)setSection:(LSSection *)section
{
    if(![_section isEqual:section])
    {
        if(_section!=nil)
        {
            LSRELEASE(_section)
        }
        _section=[section copy];
    }
}

- (NSInteger)expireSecond
{
    if (self.expireTime!=nil)
    {
        NSTimeInterval serviceNow = [[NSDate date] timeIntervalSince1970] - self.timeOffset;
        NSTimeInterval expire = [self.expireTime timeIntervalSince1970];
        
        if ((NSInteger)(expire - serviceNow) > 0)
        {
            return (NSInteger)(expire - serviceNow);
        }
    }
    return 0;
}

#pragma mark- 生命周期

- (id)init
{
    self=[super init];
    if(self!=nil)
    {
        self.isUseCoupon=LSOrderUseCouponNo;
    }
    return self;
}

- (id)initWithDictionaryOfPaid:(NSDictionary*)safeDic
{
    self=[super init];
    if(self!=nil)
    {
#warning 待解析字段
        //    {
        //        bookingId = "\U7a7a";
        //        status = 2;
        //    }
        
        if([[safeDic objectForKey:@"cinema"] isKindOfClass:[NSDictionary class]])
        {
            LSCinema* cinema=[[LSCinema alloc] initWithDictionary:[safeDic objectForKey:@"cinema"]]; //影院信息
            self.cinema=cinema;
            [cinema release];
        }
        
        if([[safeDic objectForKey:@"film"] isKindOfClass:[NSDictionary class]])
        {
            LSFilm* film=[[LSFilm alloc] initWithDictionary:[safeDic objectForKey:@"film"]]; //影片信息
            self.film=film;
            [film release];
        }
        
        if([[safeDic objectForKey:@"schedule"] isKindOfClass:[NSDictionary class]])
        {
            LSSchedule* schedule=[[LSSchedule alloc] initWithDictionary:[safeDic objectForKey:@"schedule"]]; //排期信息
            self.schedule=schedule;
            [schedule release];
        }
        
        if([[safeDic objectForKey:@"section"] isKindOfClass:[NSDictionary class]])
        {
            LSSection* section=[[LSSection alloc] initWithDictionary:[safeDic objectForKey:@"section"]]; //座位信息
            self.section=section;
            [section release];
        }
        
        self.orderID=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"trade_no"]];
        self.totalPrice=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"total_fee"]];
        self.orderTime=[NSDate dateWithTimeIntervalSince1970:[[safeDic objectForKey:@"trade_time"] doubleValue]];
        
        if(![[safeDic objectForKey:@"confirmationId"] isEqualToString:@""])
        {
            self.message=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"confirmationId"]];
        }
        else
        {
            self.message=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"message"]];
        }
    }
    return self;
}

- (id)initWithDictionaryOfUnpay:(NSDictionary*)safeDic
{
    self=[super init];
    if(self!=nil)
    {
        if([[safeDic objectForKey:@"cinema"] isKindOfClass:[NSDictionary class]])
        {
            LSCinema* cinema=[[LSCinema alloc] initWithDictionary:[safeDic objectForKey:@"cinema"]]; //影院信息
            self.cinema=cinema;
            [cinema release];
        }
        
        if([[safeDic objectForKey:@"film"] isKindOfClass:[NSDictionary class]])
        {
            LSFilm* film=[[LSFilm alloc] initWithDictionary:[safeDic objectForKey:@"film"]]; //影片信息
            self.film=film;
            [film release];
        }
        
        if([[safeDic objectForKey:@"schedule"] isKindOfClass:[NSDictionary class]])
        {
            LSSchedule* schedule=[[LSSchedule alloc] initWithDictionary:[safeDic objectForKey:@"schedule"]]; //排期信息
            self.schedule=schedule;
            [schedule release];
        }
        
        if([[safeDic objectForKey:@"section"] isKindOfClass:[NSDictionary class]])
        {
            LSSection* section=[[LSSection alloc] initWithDictionary:[safeDic objectForKey:@"section"]]; //座位信息
            self.section=section;
            [section release];
            
            self.selectSeatArray=_section.seatArray;
        }
        
        self.orderID=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"trade_no"]];
        self.totalPrice=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"total_fee"]];
        //复制原始价格
        self.originTotalPrice=self.totalPrice;
        self.serverTime=[NSDate dateWithTimeIntervalSince1970:[[safeDic objectForKey:@"service_time"] doubleValue]];
        self.orderTime=[NSDate dateWithTimeIntervalSince1970:[[safeDic objectForKey:@"trade_time"] doubleValue]];
        self.expireTime=[NSDate dateWithTimeIntervalSince1970:[[safeDic objectForKey:@"expire_time"] doubleValue]];
        self.userBalance=[[LSUser currentUser].balance floatValue];
        
        _timeOffset= [[NSDate date] timeIntervalSince1970]-[[safeDic objectForKey:@"service_time"] doubleValue];
        
        if([safeDic objectForKey:@"voucher"]!=NULL && [safeDic objectForKey:@"voucher"]!=[NSNull null] && [[safeDic objectForKey:@"voucher"] isKindOfClass:[NSDictionary class]])
        {
            NSDictionary* voucherDic=[safeDic objectForKey:@"voucher"];
            
            self.totalPrice=[voucherDic objectForKey:@"total"];
            
            NSMutableArray* couponMArray=[NSMutableArray arrayWithCapacity:0];
            NSArray* tmpArray=[voucherDic objectForKey:@"voucher"];
            for(NSDictionary* dic in tmpArray)
            {
                LSCoupon* coupon=[[LSCoupon alloc] initWithDictionary:dic];
                [couponMArray addObject:coupon];
                [coupon release];
            }
            
            self.couponArray=couponMArray;
            self.isUseCoupon=LSOrderUseCouponYes;
        }
        else
        {
            self.isUseCoupon=LSOrderUseCouponNo;
        }
        
        if(self.userBalance>=[self.totalPrice floatValue])
        {
            self.needPay=0.f;
        }
        else
        {
            self.needPay=[self.totalPrice floatValue]-[[LSUser currentUser].balance floatValue];//需支付
        }
    }
    return self;
}

- (void)completePropertyWithDictionary:(NSDictionary*)safeDic
{
    self.orderID=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"trade_no"]];
    self.totalPrice=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"total_fee"]];
    //复制原始价格
    self.originTotalPrice=self.totalPrice;
    self.serverTime=[NSDate dateWithTimeIntervalSince1970:[[safeDic objectForKey:@"service_time"] doubleValue]];
    self.orderTime=[NSDate dateWithTimeIntervalSince1970:[[safeDic objectForKey:@"trade_time"] doubleValue]];
    self.expireTime=[NSDate dateWithTimeIntervalSince1970:[[safeDic objectForKey:@"expire_time"] doubleValue]];
    self.userBalance=[[safeDic objectForKey:@"userBalance"] floatValue];
    
    _timeOffset= [[NSDate date] timeIntervalSince1970]-[[safeDic objectForKey:@"service_time"] doubleValue];
    
    if(self.userBalance>=[self.totalPrice floatValue])
    {
        self.needPay=0.f;
    }
    else
    {
        self.needPay=[self.totalPrice floatValue]-self.userBalance;//需支付
    }
}

- (void)dealloc
{
    self.cinema=nil;//影院
    self.film=nil;//影片
    self.schedule=nil;//排期

    self.section=nil;
    self.sectionArray=nil;
    self.selectSeatArray=nil;// 
//    self.totalPrice=nil;//总价
    self.couponArray=nil;
    self.isUseCoupon=nil;
    
    self.orderID=nil; //订单编号
//    self.timeOffset=nil; //服务器时间与本地时间的时间差
    self.orderTime=nil; //下单时间
    self.expireTime=nil; //过期时间
//    self.isExpire=nil; //是否已过期
//    self.needPay=nil;//需支付
//    self.userBalance=nil; //用户账户余额
    
    self.confirmationID=nil;
    self.message=nil;
    
    [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_cinema forKey:@"cinema"];
    [aCoder encodeObject:_film forKey:@"film"];
    [aCoder encodeObject:_schedule forKey:@"schedule"];
    [aCoder encodeObject:_section forKey:@"section"];
    [aCoder encodeObject:_sectionArray forKey:@"sectionArray"];
    [aCoder encodeObject:_selectSeatArray forKey:@"selectSeatArray"];
    [aCoder encodeObject:_originTotalPrice forKey:@"originTotalPrice"];
    [aCoder encodeObject:_totalPrice forKey:@"totalPrice"];
    [aCoder encodeObject:_couponArray forKey:@"couponArray"];
    [aCoder encodeObject:_isUseCoupon forKey:@"isUseCoupon"];
    [aCoder encodeObject:_orderID forKey:@"orderID"];
    [aCoder encodeInt:_timeOffset forKey:@"timeOffset"];
    [aCoder encodeObject:_serverTime forKey:@"serverTime"];
    [aCoder encodeObject:_orderTime forKey:@"orderTime"];
    [aCoder encodeObject:_expireTime forKey:@"expireTime"];
    [aCoder encodeBool:_isExpire forKey:@"isExpire"];
    [aCoder encodeFloat:_needPay forKey:@"needPay"];
    [aCoder encodeFloat:_userBalance forKey:@"userBalance"];
    [aCoder encodeObject:_confirmationID forKey:@"confirmationID"];
    [aCoder encodeObject:_message forKey:@"message"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self.cinema=[decoder decodeObjectForKey:@"cinema"];//影院
    self.film=[decoder decodeObjectForKey:@"film"];//影片
    self.schedule=[decoder decodeObjectForKey:@"schedule"];//排期
    self.section=[decoder decodeObjectForKey:@"section"];
    self.sectionArray=[decoder decodeObjectForKey:@"sectionArray"];
    self.selectSeatArray=[decoder decodeObjectForKey:@"selectSeatArray"];//
    self.originTotalPrice=[decoder decodeObjectForKey:@"originTotalPrice"];
    self.totalPrice=[decoder decodeObjectForKey:@"totalPrice"];//总价
    self.couponArray=[decoder decodeObjectForKey:@"couponArray"];//使用优惠券
    self.isUseCoupon=[decoder decodeObjectForKey:@"isUseCoupon"];
    self.orderID=[decoder decodeObjectForKey:@"orderID"];//订单编号
    self.timeOffset=[decoder decodeIntForKey:@"timeOffset"];//服务器时间与本地时间的时间差
    self.serverTime=[decoder decodeObjectForKey:@"serverTime"];
    self.orderTime=[decoder decodeObjectForKey:@"orderTime"];//下单时间
    self.expireTime=[decoder decodeObjectForKey:@"expireTime"];//过期时间
    self.isExpire=[decoder decodeBoolForKey:@"isExpire"];//是否已过期
    self.needPay=[decoder decodeFloatForKey:@"needPay"];//需支付
    self.userBalance=[decoder decodeFloatForKey:@"userBalance"];//用户账户余额
    self.confirmationID=[decoder decodeObjectForKey:@"confirmationID"];
    self.message=[decoder decodeObjectForKey:@"message"];
    return self;
}

@end
