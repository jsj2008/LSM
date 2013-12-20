//
//  LSScheduleDictionary.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-12.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSScheduleDictionary.h"
#import "LSSchedule.h"

@implementation LSScheduleDictionary

@synthesize scheduleDate=_scheduleDate;
@synthesize scheduleArray=_scheduleArray;

- (id)initWithDictionary:(NSDictionary*)safeDic
{
    self=[super init];
    if(self!=nil)
    {
        self.scheduleDate=[[safeDic objectForKey:@"days"] intValue];
        
        NSMutableArray* scheduleMArray=[NSMutableArray arrayWithCapacity:0];
        NSArray* tmpArray=[safeDic objectForKey:@"schedule"];
        for(NSDictionary* dic in tmpArray)
        {
            LSSchedule* schedule=[[LSSchedule alloc] initWithDictionary:dic];
            [scheduleMArray addObject:schedule];
            [schedule release];
        }
        
        self.scheduleArray=scheduleMArray;
    }
    return self;
}

- (void)dealloc
{
//    self.scheduleDate=nil;
    self.scheduleArray=nil;
    [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:_scheduleDate forKey:@"scheduleDate"];
    [aCoder encodeObject:_scheduleArray forKey:@"scheduleArray"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self.scheduleDate=[decoder decodeIntForKey:@"scheduleDate"];
    self.scheduleArray=[decoder decodeObjectForKey:@"scheduleArray"];
    return self;
}

@end
