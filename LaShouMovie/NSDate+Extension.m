//
//  NSDate+Extension.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-29.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

- (NSString*)stringValueByFormatter:(NSString*)formatter
{
    NSDateFormatter* dateFormatter=[[[NSDateFormatter alloc] init] autorelease];
    dateFormatter.dateFormat = formatter;
    return [dateFormatter stringFromDate:self];
}

@end
