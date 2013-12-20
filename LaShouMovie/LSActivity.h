//
//  LSActivity.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-18.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSActivity : NSObject<NSCoding>
{
    NSString* _activityID;
}
@property(nonatomic,retain) NSString* activityID;

- (id)initWithDictionary:(NSDictionary*)safeDic;

@end
