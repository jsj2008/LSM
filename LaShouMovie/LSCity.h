//
//  LSCity.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-6.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSCity : NSObject<NSCoding>
{
    NSString* _cityID;
    NSString* _cityName;
    NSString* _pinyin;
}

@property(nonatomic,retain) NSString* cityID;
@property(nonatomic,retain) NSString* cityName;
@property(nonatomic,retain) NSString* pinyin;

- (BOOL)cityNameSort:(LSCity* )city;
- (id)initWithDictionary:(NSDictionary*)safeDic;

@end
