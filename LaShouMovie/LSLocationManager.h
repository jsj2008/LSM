//
//  LSLocation.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-11.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface LSLocationManager : CLLocationManager<CLLocationManagerDelegate>

@property(nonatomic,assign) NSInteger locationNumber;
@property(nonatomic,retain) LSUser* user;
@property(nonatomic,retain) LSMessageCenter* messageCenter;

//定位开始
+ (void)start;
//定位停止
+ (void)end;

@end
