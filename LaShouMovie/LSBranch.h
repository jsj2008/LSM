//
//  LSBranch.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-16.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSBranch : NSObject<NSCoding>
{
//    branch_cinemaName：分店名
//    
//    branch_latitude：纬度
//    
//    branch_longitude：经度
//    
//    branch_phone：电话
//    
//    branch_address：分店地址
    
    
    
    NSString* _cinemaName;//影院名
    NSString* _address;//地址
    double _latitude;//纬度
    double _longitude;//经度
    NSString* _phone;//电话
}
@property(nonatomic,retain) NSString* cinemaName;
@property(nonatomic,retain) NSString* address;
@property(nonatomic,assign) double latitude;
@property(nonatomic,assign) double longitude;
@property(nonatomic,retain) NSString* phone;

- (id)initWithDictionary:(NSDictionary*)safeDic;

@end
