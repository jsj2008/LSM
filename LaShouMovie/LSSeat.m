//
//  LSSeat.m
//  LaShouMovie
//
//  Created by Li XiangYu on 13-9-15.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSSeat.h"

@implementation LSSeat

@synthesize realColumnID=_realColumnID;
@synthesize columnID=_columnID;
@synthesize realRowID=_realRowID;
@synthesize rowID=_rowID;
@synthesize isDamage=_isDamage;
@synthesize type=_type;
@synthesize isSold=_isSold;

//本地数据
@synthesize seatStatus=_seatStatus;
@synthesize originSeatStatus=_originSeatStatus;

//- (id)copyWithZone:(NSZone *)zone
//{
//    LSSeat* seat=[[LSSeat allocWithZone:zone] init];
//    seat.realColumnID=_realColumnID;
//    seat.columnID=_columnID;
//    seat.realRowID=_realRowID;
//    seat.rowID=_rowID;
//    seat.isDamage=_isDamage;
//    seat.type=_type;
//    seat.isSold=_isSold;
//    seat.seatStatus=_seatStatus;
//    seat.originSeatStatus=_originSeatStatus;
//    return seat;
//}

- (id)initWithDictionary:(NSDictionary*)safeDic
{
    self=[super init];
    if(self!=nil)
    {
        //本地生成
        self.originSeatStatus=LSSeatStatusNormal;
        self.seatStatus=LSSeatStatusNormal;
        
        //下载数据
        self.realColumnID=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"columnId"]];
        self.columnID=[[safeDic objectForKey:@"columnNum"] floatValue];
        self.realRowID=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"rowId"]];
        self.rowID=[[safeDic objectForKey:@"rowNum"] intValue];
        self.isDamage=[[safeDic objectForKey:@"isDamaged"] boolValue];
        self.type=[[safeDic objectForKey:@"type"] intValue];
        self.isSold=NO;
    }
    return self;
}

- (void)setIsSold:(BOOL)isSold
{
    _isSold=isSold;
    if(_isSold)
    {
        self.originSeatStatus=LSSeatStatusSold;
        self.seatStatus=LSSeatStatusSold;
    }
}

- (void)setType:(LSSeatType)type
{
    _type=type;
    if(type==LSSeatTypeLoveFirst || type==LSSeatTypeLoveSecond)
    {
        self.originSeatStatus=LSSeatStatusLove;
        self.seatStatus=LSSeatStatusLove;
    }
}

- (void)setIsDamage:(BOOL)isDamage
{
    _isDamage=isDamage;
    if(_isDamage)
    {
        self.originSeatStatus=LSSeatStatusUnable;
        self.seatStatus=LSSeatStatusUnable;
    }
}

- (void)dealloc
{
    self.realColumnID=nil;
//    self.columnID=nil;
    self.realRowID=nil;
//    self.rowID=nil;
//    self.isDamage=nil;
//    self.type=nil;
//    self.isSold=nil;
//    self.originSeatStatus=nil;
//    self.seatStatus=nil;
    [super dealloc];
}

- (BOOL)sortByColumnID:(LSSeat*)seat
{
    if(self.columnID>seat.columnID)
    {
        return YES;
    }
    return NO;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_realColumnID forKey:@"realColumnID"];
    [aCoder encodeFloat:_columnID forKey:@"columnID"];
    [aCoder encodeObject:_realRowID forKey:@"realRowID"];
    [aCoder encodeInt:_rowID forKey:@"rowID"];
    [aCoder encodeBool:_isDamage forKey:@"isDamage"];
    [aCoder encodeInt:_type forKey:@"type"];
    [aCoder encodeBool:_isSold forKey:@"isSold"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self.realColumnID=[decoder decodeObjectForKey:@"realColumnID"];
    self.columnID=[decoder decodeFloatForKey:@"columnID"];
    self.realRowID=[decoder decodeObjectForKey:@"realRowID"];
    self.rowID=[decoder decodeIntForKey:@"rowID"];
    self.isDamage=[decoder decodeBoolForKey:@"isDamage"];
    self.type=[decoder decodeIntForKey:@"type"];
    self.isSold=[decoder decodeBoolForKey:@"isSold"];
    return self;
}

@end
