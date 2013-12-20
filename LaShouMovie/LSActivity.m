//
//  LSActivity.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-18.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSActivity.h"

@implementation LSActivity

@synthesize activityID=_activityID;

- (id)initWithDictionary:(NSDictionary*)safeDic
{
    self=[super init];
    if(self!=nil)
    {
        self.activityID=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"mactivityId"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_activityID forKey:@"activityID"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self.activityID=[decoder decodeObjectForKey:@"activityID"];
    return self;
}

@end
