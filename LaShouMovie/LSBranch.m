//
//  LSBranch.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-16.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSBranch.h"

@implementation LSBranch

@synthesize cinemaName=_cinemaName;
@synthesize address=_address;
@synthesize latitude=_latitude;
@synthesize longitude=_longitude;
@synthesize phone=_phone;

- (id)initWithDictionary:(NSDictionary*)safeDic
{
    self=[super init];
    if(self!=nil)
    {
        self.cinemaName=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"branch_cinemaName"]];
        self.address=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"branch_address"]];
        self.latitude=[[safeDic objectForKey:@"branch_latitude"] doubleValue];
        self.longitude=[[safeDic objectForKey:@"branch_longitude"] doubleValue];
        self.phone=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"branch_phone"]];
    }
    return self;
}

- (void)dealloc
{
    self.cinemaName=nil;
    self.address=nil;
//    self.latitude=nil;
//    self.longitude=nil;
    self.phone=nil;
    [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_cinemaName forKey:@"cinemaName"];
    [aCoder encodeObject:_address forKey:@"address"];
    [aCoder encodeDouble:_latitude forKey:@"latitude"];
    [aCoder encodeDouble:_longitude forKey:@"longitude"];
    [aCoder encodeObject:_phone forKey:@"phone"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self.cinemaName=[decoder decodeObjectForKey:@"cinemaName"];
    self.address=[decoder decodeObjectForKey:@"address"];
    self.latitude=[decoder decodeDoubleForKey:@"latitude"];
    self.longitude=[decoder decodeDoubleForKey:@"longitude"];
    self.phone=[decoder decodeObjectForKey:@"phone"];
    return self;
}

@end
