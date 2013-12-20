//
//  LSCity.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-6.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSCity.h"

@implementation LSCity

@synthesize cityID=_cityID;
@synthesize cityName=_cityName;
@synthesize pinyin=_pinyin;

- (void)dealloc
{
    self.cityID=nil;
    self.cityName=nil;
    self.pinyin=nil;
    [super dealloc];
}

- (id)initWithDictionary:(NSDictionary*)safeDic
{
    self=[super init];
    if(self!=nil)
    {
        self.cityID=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"cityId"]];
        self.cityName=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"cityName"]];
        self.pinyin=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"letter"]];
    }
    return  self;
}

- (BOOL)cityNameSort:(LSCity* )city
{
    return  [self.pinyin localizedCompare:city.pinyin];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_cityID forKey:@"cityID"];
    [aCoder encodeObject:_cityName forKey:@"cityName"];
    [aCoder encodeObject:_pinyin forKey:@"pinyin"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self.cityID=[decoder decodeObjectForKey:@"cityID"];
    self.cityName=[decoder decodeObjectForKey:@"cityName"];
    self.pinyin=[decoder decodeObjectForKey:@"pinyin"];
    return self;
}

@end
