//
//  LSScheduleDictionary.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-12.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSScheduleDictionary : NSObject<NSCoding>
{
//    {
//        days = 0;
//        schedule=();
//    }
    
    int _scheduleDate;
    NSArray* _scheduleArray;
}
@property(nonatomic,assign) int scheduleDate;
@property(nonatomic,retain) NSArray* scheduleArray;

- (id)initWithDictionary:(NSDictionary*)safeDic;

@end
