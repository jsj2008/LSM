//
//  LSPayWay.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-26.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSPayWay.h"

@implementation LSPayWay

@synthesize payWayID=_payWayID;
@synthesize payWayName=_payWayName;
@synthesize information=_information;

- (id)initWithDictionary:(NSDictionary*)safeDic
{
    self = [super init];
    if (self!=nil)
    {
        self.payWayID = [[safeDic objectForKey:@"message"] intValue];
        self.payWayName = [NSString stringWithFormat:@"%@",[safeDic objectForKey:@"message"]];
        self.information = [NSString stringWithFormat:@"%@",[safeDic objectForKey:@"message"]];
    }
    return self;
}

- (void)dealloc
{
//    self.payWayID = nil;
    self.payWayName = nil;
    self.information = nil;
    [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:_payWayID forKey:@"payWayID"];
    [aCoder encodeObject:_payWayName forKey:@"payWayName"];
    [aCoder encodeObject:_information forKey:@"information"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self.payWayID=[decoder decodeIntForKey:@"payWayID"];
    self.payWayName=[decoder decodeObjectForKey:@"payWayName"];
    self.information=[decoder decodeObjectForKey:@"information"];
    return self;
}

@end
