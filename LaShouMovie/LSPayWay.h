//
//  LSPayWay.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-26.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSPayWay : NSObject<NSCoding>
{
    LSPayWayType _payWayID;
    NSString* _payWayName;
    NSString* _information;
}
@property(nonatomic,assign) LSPayWayType payWayID;
@property(nonatomic,retain) NSString* payWayName;
@property(nonatomic,retain) NSString* information;

@end
