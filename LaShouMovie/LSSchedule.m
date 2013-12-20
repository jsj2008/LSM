//
//  LSSchedule.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-12.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSSchedule.h"

@implementation LSSchedule

@synthesize scheduleID=_scheduleID;//排期ID
@synthesize dimensional=_dimensional;//2D、3D
@synthesize isIMAX=_isIMAX;//iMax
@synthesize language=_language;//语言
@synthesize hall=_hall;//放映厅
@synthesize initialPrice=_initialPrice;//原价
@synthesize price=_price;//终价
@synthesize isOnSale=_isOnSale;//是否特价
@synthesize startDate=_startDate;//开始日期
@synthesize startTime=_startTime;//开始时间
@synthesize expectEndTime=_expectEndTime;//预计结束时间

- (id)initWithDictionary:(NSDictionary *)safeDic
{
    self=[super init];
    if(self!=nil)
    {
        self.scheduleID=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"seqNo"]];
        self.dimensional=[[safeDic objectForKey:@"dimensional"] intValue];
        self.isIMAX=[[safeDic objectForKey:@"imax"] boolValue];
        self.language=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"language"]];
        if([[safeDic objectForKey:@"hall"] isKindOfClass:[NSDictionary class]])
        {
            NSDictionary* hallDic=[safeDic objectForKey:@"hall"];
            
            LSHall* hall=[[LSHall alloc] initWithDictionary:hallDic];
            self.hall=hall;
            [hall release];
        }
        self.initialPrice=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"initialPrice"]];
        self.price=[[safeDic objectForKey:@"price"] floatValue];
        self.isOnSale=[[safeDic objectForKey:@"campaignSign"] boolValue];
        self.startDate=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"startDate"]];
        self.startTime=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"startTime"]];
        self.expectEndTime=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"expectEndTime"]];
    }
    return self;
}

- (void)dealloc
{
    self.scheduleID=nil;
//    self.dimensional=nil;
//    self.isIMAX=nil;
    self.language=nil;
    self.hall=nil;
    self.initialPrice=nil;
//    self.price=nil;
//    self.isOnSale=nil;
    self.startDate=nil;
    self.startTime=nil;
    self.expectEndTime=nil;
    [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_scheduleID forKey:@"scheduleID"];
    [aCoder encodeInt:_dimensional forKey:@"dimensional"];
    [aCoder encodeBool:_isIMAX forKey:@"isIMAX"];
    [aCoder encodeObject:_language forKey:@"language"];
    [aCoder encodeObject:_hall forKey:@"hall"];
    [aCoder encodeObject:_initialPrice forKey:@"initialPrice"];
    [aCoder encodeFloat:_price forKey:@"price"];
    [aCoder encodeBool:_isOnSale forKey:@"isOnSalev"];
    [aCoder encodeObject:_startDate forKey:@"startDate"];
    [aCoder encodeObject:_startTime forKey:@"startTime"];
    [aCoder encodeObject:_expectEndTime forKey:@"expectEndTime"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self.scheduleID=[decoder decodeObjectForKey:@"scheduleID"];
    self.dimensional=[decoder decodeIntForKey:@"dimensional"];
    self.isIMAX=[decoder decodeBoolForKey:@"isIMAX"];
    self.language=[decoder decodeObjectForKey:@"language"];
    self.hall=[decoder decodeObjectForKey:@"hall"];
    self.initialPrice=[decoder decodeObjectForKey:@"initialPrice"];
    self.price=[decoder decodeFloatForKey:@"price"];
    self.isOnSale=[decoder decodeBoolForKey:@"isOnSalev"];
    self.startDate=[decoder decodeObjectForKey:@"startDate"];
    self.startTime=[decoder decodeObjectForKey:@"startTime"];
    self.expectEndTime=[decoder decodeObjectForKey:@"expectEndTime"];
    return self;
}

@end
