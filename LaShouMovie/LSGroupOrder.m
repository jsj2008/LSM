//
//  LSGroupOrder.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-10.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSGroupOrder.h"

@implementation LSGroupOrder
@synthesize groupID=_groupID;
@synthesize groupTitle=_groupTitle;
@synthesize buyTime=_buyTime;
@synthesize amount=_amount;
@synthesize totalPrice=_totalPrice;
@synthesize hadPay=_hadPay;
@synthesize userBalance=_userBalance;
@synthesize needPay=_needPay;
@synthesize orderID=_orderID;
@synthesize orderStatus=_orderStatus;
@synthesize isPaid=_isPaid;

- (id)initWithDictionary:(NSDictionary*)safeDic
{
    self=[super init];
    if(self!=nil)
    {
        self.groupID=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"goods_id"]];
        self.groupTitle=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"goods_title"]];
        
        self.orderID=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"trade_no"]];
        self.buyTime=[NSDate dateWithTimeIntervalSince1970:[[safeDic objectForKey:@"buy_time"] doubleValue]];
        self.amount=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"amount"]];
        self.totalPrice=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"totalPrice"]];
        self.hadPay=[[safeDic objectForKey:@"aleadyPay"] floatValue];
        self.userBalance=[[safeDic objectForKey:@"userBalance"] floatValue];
        if([safeDic objectForKey:@"shouldPay"]!=NULL && [safeDic objectForKey:@"shouldPay"]!=[NSNull null] && [safeDic objectForKey:@"shouldPay"]!=nil && ![[safeDic objectForKey:@"shouldPay"] isEqual:LSNULL])
        {
            self.needPay=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"shouldPay"]];
        }
        else
        {
            self.needPay=[NSString stringWithFormat:@"%.2f",[self.totalPrice floatValue]-self.hadPay];
        }
        self.orderStatus=[[safeDic objectForKey:@"orderStatus"] integerValue];
        if(self.orderStatus==LSGroupOrderStatusPaid)
        {
            self.isPaid=YES;
        }
    }
    return self;
}

- (void)dealloc
{
    self.groupID=nil;
    self.groupTitle=nil;
    
    self.orderID=nil;
    self.buyTime=nil;
    //    self.hadPay=nil;
    self.amount=nil;
    self.totalPrice=nil;
//    self.userBalance=nil;
    self.needPay=nil;
    //    self.orderStatus=nil;
    [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_groupID forKey:@"groupID"];
    [aCoder encodeObject:_groupTitle forKey:@"groupTitle"];
    
    [aCoder encodeObject:_orderID forKey:@"orderID"];
    [aCoder encodeObject:_buyTime forKey:@"buyTime"];
    [aCoder encodeObject:_amount forKey:@"amount"];
    [aCoder encodeObject:_totalPrice forKey:@"totalPrice"];
    [aCoder encodeFloat:_hadPay forKey:@"hadPay"];
    [aCoder encodeFloat:_userBalance forKey:@"userBalance"];
    [aCoder encodeObject:_needPay forKey:@"needPay"];
    [aCoder encodeInt:_orderStatus forKey:@"orderStatus"];
    [aCoder encodeBool:_isPaid forKey:@"isPaid"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self.groupID=[decoder decodeObjectForKey:@"groupID"];
    self.groupTitle=[decoder decodeObjectForKey:@"groupTitle"];
    
    self.orderID=[decoder decodeObjectForKey:@"orderID"];
    self.buyTime=[decoder decodeObjectForKey:@"buyTime"];
    self.amount=[decoder decodeObjectForKey:@"amount"];
    self.totalPrice=[decoder decodeObjectForKey:@"totalPrice"];
    self.hadPay=[decoder decodeFloatForKey:@"hadPay"];
    self.userBalance=[decoder decodeFloatForKey:@"userBalance"];
    self.needPay=[decoder decodeObjectForKey:@"needPay"];
    self.orderStatus=[decoder decodeIntForKey:@"orderStatus"];
    self.isPaid=[decoder decodeBoolForKey:@"isPaid"];
    
    return self;
}

@end
