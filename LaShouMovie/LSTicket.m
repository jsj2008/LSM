//
//  LSTicket.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-16.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTicket.h"
#import "LSBranch.h"

@implementation LSTicket

@synthesize groupID=_groupID;//团ID
@synthesize groupTitle=_groupTitle;//团标题
@synthesize orderID=_orderID;//订单ID
@synthesize ticketID=_ticketID;//拉手券号
@synthesize ticketPassword=_ticketPassword;
@synthesize smallImageURL=_smallImageURL;//小图
@synthesize initialPrice=_initialPrice;//原价
@synthesize price=_price;//终价
@synthesize isSevenRefund=_isSevenRefund;//是否支持七天退款
@synthesize isAutoRefund=_isAutoRefund;//是否支持自动退款
@synthesize openTime=_openTime; //商家营业时间
@synthesize buyTime=_buyTime;//购买时间
@synthesize expireTime=_expireTime;//过期时间
@synthesize consumeTime=_consumeTime;//消费时间
@synthesize goodsTips=_goodsTips;//温馨提示
@synthesize phone=_phone;//客服

@synthesize branchArray=_branchArray;//商家
@synthesize ticketStatus=_ticketStatus;//拉手券状态

- (id)initWithDictionary:(NSDictionary*)safeDic
{
    self=[super init];
    if(self!=nil)
    {
        self.groupID=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"goods_id"]];//团ID
        self.groupTitle=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"goods_title"]];//团标题
        
        self.orderID=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"trade_no"]];//订单ID
        
        self.ticketID=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"code_id"]];//拉手券号
        self.ticketPassword=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"code_password"]];
        
        self.smallImageURL=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"imageSmall"]];//小图
        self.initialPrice=[[safeDic objectForKey:@"initialPrice"] floatValue];//原价
        self.price=[[safeDic objectForKey:@"price"] floatValue];//终价
        self.isSevenRefund=[[safeDic objectForKey:@"isSevenRefund"] boolValue];//是否支持七天退款
        self.isAutoRefund=[[safeDic objectForKey:@"isAutoRefund"] boolValue];//是否支持自动退款
        self.openTime=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"sp_open_time"]]; //商家营业时间
        self.buyTime=[NSDate dateWithTimeIntervalSince1970:[[safeDic objectForKey:@"buy_time"] doubleValue]];//购买时间
        self.expireTime=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"expire_time"]];//过期时间
        self.consumeTime=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"consume_time"]];//消费时间
        self.goodsTips=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"goodsTips"]];//温馨提示
        self.phone=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"sp_phone"]];//客服
        
        if(![[safeDic objectForKey:@"sp_allBranch"] isKindOfClass:[NSArray class]])
        {
            NSMutableArray* branchMArray=[NSMutableArray arrayWithCapacity:0];
            NSArray* tmpArray=[safeDic objectForKey:@"sp_allBranch"];
            for (id object in tmpArray)
            {
                if([object isKindOfClass:[NSDictionary class]])
                {
                    LSBranch* branch=[[LSBranch alloc] initWithDictionary:object];
                    [branchMArray addObject:branch];
                    [branch release];
                }
            }
            
            self.branchArray=branchMArray;//商家
        }

        self.ticketStatus=[[safeDic objectForKey:@"code_status"] integerValue];//拉手券状态
    }
    return self;
}

- (void)dealloc
{
    self.groupID=nil;//团ID
    self.groupTitle=nil;//团标题
    self.orderID=nil;//订单ID
    self.ticketID=nil;//拉手券号
    self.ticketPassword=nil;
    self.smallImageURL=nil;//小图
//    self.initialPrice=nil;//原价
//    self.price=nil;//终价
//    self.isSevenRefund=nil;//是否支持七天退款
//    self.isAutoRefund=nil;//是否支持自动退款
    self.openTime=nil; //商家营业时间
    self.buyTime=nil;//购买时间
    self.expireTime=nil;//过期时间
    self.consumeTime=nil;//消费时间
    self.goodsTips=nil;//温馨提示
    self.phone=nil;//客服
    
    self.branchArray=nil;//商家
//    self.ticketStatus=nil;//拉手券状态
    [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_groupID forKey:@"groupID"];
    [aCoder encodeObject:_groupTitle forKey:@"groupTitle"];
    [aCoder encodeObject:_orderID forKey:@"orderID"];
    [aCoder encodeObject:_ticketID forKey:@"ticketID"];
    [aCoder encodeObject:_ticketPassword forKey:@"ticketPassword"];
    [aCoder encodeObject:_smallImageURL forKey:@"smallImageURL"];
    [aCoder encodeFloat:_initialPrice forKey:@"initialPrice"];
    [aCoder encodeFloat:_price forKey:@"price"];
    [aCoder encodeBool:_isSevenRefund forKey:@"isSevenRefund"];
    [aCoder encodeBool:_isAutoRefund forKey:@"isAutoRefund"];
    [aCoder encodeObject:_openTime forKey:@"openTime"];
    [aCoder encodeObject:_buyTime forKey:@"buyTime"];
    [aCoder encodeObject:_expireTime forKey:@"expireTime"];
    [aCoder encodeObject:_consumeTime forKey:@"consumeTime"];
    [aCoder encodeObject:_goodsTips forKey:@"goodsTips"];
    [aCoder encodeObject:_phone forKey:@"phone"];
    [aCoder encodeObject:_branchArray forKey:@"branchArray"];
    [aCoder encodeInt:_ticketStatus forKey:@"ticketStatus"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self.groupID=[decoder decodeObjectForKey:@"groupID"];
    self.groupTitle=[decoder decodeObjectForKey:@"groupTitle"];
    self.orderID=[decoder decodeObjectForKey:@"orderID"];
    self.ticketID=[decoder decodeObjectForKey:@"ticketID"];
    self.ticketPassword=[decoder decodeObjectForKey:@"ticketPassword"];
    self.smallImageURL=[decoder decodeObjectForKey:@"smallImageURL"];
    self.initialPrice=[decoder decodeFloatForKey:@"initialPrice"];
    self.price=[decoder decodeFloatForKey:@"price"];
    self.isSevenRefund=[decoder decodeBoolForKey:@"isSevenRefund"];
    self.isAutoRefund=[decoder decodeBoolForKey:@"isAutoRefund"];
    self.openTime=[decoder decodeObjectForKey:@"openTime"];
    self.buyTime=[decoder decodeObjectForKey:@"buyTime"];
    self.expireTime=[decoder decodeObjectForKey:@"expireTime"];
    self.consumeTime=[decoder decodeObjectForKey:@"consumeTime"];
    self.goodsTips=[decoder decodeObjectForKey:@"goodsTips"];
    self.phone=[decoder decodeObjectForKey:@"phone"];
    self.branchArray=[decoder decodeObjectForKey:@"branchArray"];
    self.ticketStatus=[decoder decodeIntForKey:@"ticketStatus"];
    return self;
}

@end
