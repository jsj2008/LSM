//
//  LSHall.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-16.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSHall.h"

@implementation LSHall

@synthesize hallID=_hallID;//放映厅ID
@synthesize hallName=_hallName;//放映厅名称

- (id)initWithDictionary:(NSDictionary *)safeDic
{
    self=[super init];
    if(self!=nil)
    {
        self.hallID=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"hallId"]];
        self.hallName=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"hallName"]];
    }
    return self;
}

- (void)dealloc
{
    self.hallID=nil;
    self.hallName=nil;
    [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_hallID forKey:@"hallID"];
    [aCoder encodeObject:_hallName forKey:@"hallName"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self.hallID=[decoder decodeObjectForKey:@"hallID"];
    self.hallName=[decoder decodeObjectForKey:@"hallName"];
    return self;
}
@end
