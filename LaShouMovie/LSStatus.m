//
//  LSStatus.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-5.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSStatus.h"

@implementation LSStatus

@synthesize code=_code;
@synthesize message=_message;

- (void)dealloc
{
	self.message = nil;
	[super dealloc];
}

- (id)init
{
    self = [super init];
    if (self!=nil)
    {
        self.code = 0;
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary*)safeDic
{
    self = [super init];
    if (self!=nil)
    {
        self.code = [[safeDic objectForKey:@"code"] integerValue];
        self.message = [NSString stringWithFormat:@"%@",[safeDic objectForKey:@"message"]];
    }
    return self;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"LSStatus:{\n Code:'%d',\n Message:'%@'\n}",_code,_message];
}

@end
