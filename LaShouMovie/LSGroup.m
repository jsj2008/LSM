//
//  LSGroup.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-10.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSGroup.h"

@implementation LSGroup

@synthesize groupID=_groupID;
@synthesize groupTitle=_groupTitle;

@synthesize isFetchDetail=_isFetchDetail;
@synthesize bigImageURL=_bigImageURL;//大图
@synthesize midImageURL=_midImageURL;//中图
@synthesize smallImageURL=_smallImageURL;//小图
@synthesize initialPrice=_initialPrice;//原价
@synthesize price=_price;//终价
@synthesize isSevenRefund=_isSevenRefund;//是否支持七天退款
@synthesize isAutoRefund=_isAutoRefund;//是否支持自动退款
@synthesize aleadyBought=_aleadyBought; //已经购买数
@synthesize maxCanBuy=_maxCanBuy;//最大购买数
@synthesize minMustBuy=_minMustBuy;//最小购买数
@synthesize endTime=_endTime;//结束时间
@synthesize serverTime=_serverTime; //服务器时间
@synthesize goodsDetail=_goodsDetail;//本单详情
@synthesize goodsTips=_goodsTips;//温馨提示
@synthesize graphicDetails=_graphicDetails;//图文详情
@synthesize phone=_phone;//客服


- (id)initWithDictionary:(NSDictionary*)safeDic
{
    self=[super init];
    if(self!=nil)
    {
        self.groupID=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"goods_id"]];
        self.groupTitle=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"goods_title"]];
    }
    return self;
}

- (void)completePropertyWithDictionary:(NSDictionary *)safeDic
{
    self.isFetchDetail=YES;
    self.bigImageURL=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"imageBig"]];//大图
    self.midImageURL=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"imageMid"]];//中图
    self.smallImageURL=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"imageSmall"]];//小图
    self.initialPrice=[[safeDic objectForKey:@"initialPrice"] floatValue];//原价
    self.price=[[safeDic objectForKey:@"price"] floatValue];//终价
    self.isSevenRefund=[[safeDic objectForKey:@"isSevenRefund"] boolValue];//是否支持七天退款
    self.isAutoRefund=[[safeDic objectForKey:@"isAutoRefund"] boolValue];//是否支持自动退款
    self.aleadyBought=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"aleadyBought"]]; //已经购买数
    self.maxCanBuy=[[safeDic objectForKey:@"maxPerUserCanBuy"] integerValue];//最大购买数
    self.minMustBuy=[[safeDic objectForKey:@"minPerUserMustBuy"] integerValue];//最小购买数
    self.endTime=[NSDate dateWithTimeIntervalSince1970:[[safeDic objectForKey:@"endTime"] doubleValue]];//结束时间
    self.serverTime=[NSDate dateWithTimeIntervalSince1970:[[safeDic objectForKey:@"serverTime"] doubleValue]]; //服务器时间
    self.goodsDetail=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"goodsDetail"]];//本单详情
    self.goodsTips=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"goodsTips"]];//温馨提示
    self.graphicDetails=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"graphicDetails"]];//图文详情
    self.phone=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"phone"]];//客服
}

- (void)dealloc
{
    self.groupID=_groupID;
    self.groupTitle=_groupTitle;
    
    self.bigImageURL=nil;//大图
    self.midImageURL=nil;//中图
    self.smallImageURL=nil;//小图
//    self.initialPrice=nil;//原价
//    self.price=nil;//终价
//    self.isSevenRefund=nil;//是否支持七天退款
//    self.isAutoRefund=nil;//是否支持自动退款
    self.aleadyBought=nil; //已经购买数
//    self.maxCanBuy=nil;//最大购买数
//    self.minMustBuy=nil;//最小购买数
    self.endTime=nil;//结束时间
    self.serverTime=nil; //服务器时间
    self.goodsDetail=nil;//本单详情
    self.goodsTips=nil;//温馨提示
    self.graphicDetails=nil;//图文详情
    self.phone=nil;//客服
    
    [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_groupID forKey:@"groupID"];
    [aCoder encodeObject:_groupTitle forKey:@"groupTitle"];
    
    [aCoder encodeBool:_isFetchDetail forKey:@"isFetchDetail"];
    [aCoder encodeObject:_bigImageURL forKey:@"bigImageURL"];
    [aCoder encodeObject:_midImageURL forKey:@"midImageURL"];
    [aCoder encodeObject:_smallImageURL forKey:@"smallImageURL"];
    [aCoder encodeFloat:_initialPrice forKey:@"initialPrice"];
    [aCoder encodeFloat:_price forKey:@"price"];
    [aCoder encodeBool:_isSevenRefund forKey:@"isSevenRefund"];
    [aCoder encodeBool:_isAutoRefund forKey:@"isAutoRefund"];
    [aCoder encodeObject:_aleadyBought forKey:@"aleadyBought"];
    [aCoder encodeInt:_maxCanBuy forKey:@"maxCanBuy"];
    [aCoder encodeInt:_minMustBuy forKey:@"minMustBuy"];
    [aCoder encodeObject:_endTime forKey:@"endTime"];
    [aCoder encodeObject:_serverTime forKey:@"serverTime"];
    [aCoder encodeObject:_goodsDetail forKey:@"goodsDetail"];
    [aCoder encodeObject:_goodsTips forKey:@"goodsTips"];
    [aCoder encodeObject:_graphicDetails forKey:@"graphicDetails"];
    [aCoder encodeObject:_phone forKey:@"phone"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self.groupID=[decoder decodeObjectForKey:@"groupID"];
    self.groupTitle=[decoder decodeObjectForKey:@"groupTitle"];
    
    self.isFetchDetail=[decoder decodeBoolForKey:@"isFetchDetail"];//是否已经请求详情
    self.bigImageURL=[decoder decodeObjectForKey:@"bigImageURL"];//大图
    self.midImageURL=[decoder decodeObjectForKey:@"midImageURL"];//中图
    self.smallImageURL=[decoder decodeObjectForKey:@"smallImageURL"];//小图
    self.initialPrice=[decoder decodeFloatForKey:@"initialPrice"];//原价
    self.price=[decoder decodeFloatForKey:@"price"];//终价
    self.isSevenRefund=[decoder decodeBoolForKey:@"isSevenRefund"];//是否支持七天退款
    self.isAutoRefund=[decoder decodeBoolForKey:@"isAutoRefund"];//是否支持自动退款
    self.aleadyBought=[decoder decodeObjectForKey:@"aleadyBought"]; //已经购买数
    self.maxCanBuy=[decoder decodeIntForKey:@"maxCanBuy"];//最大购买数
    self.minMustBuy=[decoder decodeIntForKey:@"minMustBuy"];//最小购买数
    self.endTime=[decoder decodeObjectForKey:@"endTime"];//结束时间
    self.serverTime=[decoder decodeObjectForKey:@"serverTime"]; //服务器时间
    self.goodsDetail=[decoder decodeObjectForKey:@"goodsDetail"];//本单详情
    self.goodsTips=[decoder decodeObjectForKey:@"goodsTips"];//温馨提示
    self.graphicDetails=[decoder decodeObjectForKey:@"graphicDetails"];//图文详情
    self.phone=[decoder decodeObjectForKey:@"phone"];//客服

    return self;
}

@end
