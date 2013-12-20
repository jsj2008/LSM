//
//  LSLocation.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-11.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSLocationManager.h"

@implementation LSLocationManager

@synthesize locationNumber;
@synthesize user;
@synthesize messageCenter;

static LSLocationManager* locationManager;

#pragma mark- 私有方法，单例方法

+ (LSLocationManager *)currentManager
{
    @synchronized(self)
    {
        if (locationManager==nil)
        {
            locationManager=[[super allocWithZone:NULL] init];
            locationManager.delegate=locationManager;
            locationManager.desiredAccuracy=kCLLocationAccuracyBest;//定位精度,最好
            locationManager.distanceFilter=1000;//范围(移动范围内不再使用定位)
            //以上两项和耗电有关，精度越高，耗电越快

            locationManager.user=[LSUser currentUser];
            locationManager.messageCenter=[LSMessageCenter defaultCenter];
            [locationManager.messageCenter addObserver:locationManager selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeCityCityIDByName object:nil];
        }
    }
    
    locationManager.locationNumber=0;
    return locationManager;
}
+ (id)alloc
{
    return [[self currentManager] retain];
}
+ (id)allocWithZone:(NSZone *)zone
{
    return [[self currentManager] retain];
}
- (id)copyWithZone:(NSZone *)zone;
{
    return self; //确保copy对象也是唯一
}
- (id)retain
{
    return self; //确保计数唯一
}
- (NSUInteger)retainCount
{
    return NSUIntegerMax;  //这样打印出来的计数永远为-1
}
- (oneway void)release
{
    //do nothing
}
+ (void)release
{
    //do nothing
}
- (id)autorelease
{
    return self;//确保计数唯一
}


#pragma mark- 公共方法
//定位开始
+ (void)start
{
    LSLocationManager* locationManager=[LSLocationManager currentManager];
    //基础定位服务
    if([CLLocationManager locationServicesEnabled])//判断是否定位可用
    {
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorized)//如果用户未处理或者已经授权
        {
            LSLOG(@"开始定位");
            [locationManager startUpdatingLocation];
        }
        else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusRestricted)
        {
            LSLOG(@"未知原因导致不能使用定位服务");
            [locationManager defaultUpdateToLocation];
        }
        else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)
        {
            LSLOG(@"用户禁止了定位服务");
            [locationManager defaultUpdateToLocation];
        }
    }
    else
    {
        LSLOG(@"当前定位功能不可用");
    }
}
//定位停止
+ (void)end
{
    [locationManager stopUpdatingLocation];
}


#pragma mark- CLLocationManager的委托方法
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    LSLOG(@"定位位置: %f,%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
    locationManager.user.location=newLocation;//设置User的地理位置
    [manager stopUpdatingLocation];//定位成功就停止
    
    [locationManager VeivoReverseGeocodeLocation:newLocation];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if(locationManager.locationNumber<5)
    {
        LSLOG(@"定位失败,第 %d 次",locationManager.locationNumber);
        [manager startUpdatingLocation];
        locationManager.locationNumber++;
    }
    else
    {
        LSLOG(@"定位最终失败");
        [self defaultUpdateToLocation];
    }
}

#pragma mark- 定位失败的时候执行的方法
- (void)defaultUpdateToLocation
{
    [locationManager stopUpdatingLocation];//定位失败停止
    
    CLLocation* location=[[CLLocation alloc] initWithLatitude:lsDefaultLatitude longitude:lsDefaultLongitude];
    locationManager.user.location=location;//设置User的默认地理位置
}

#pragma mark- 反编译
- (void)VeivoReverseGeocodeLocation:(CLLocation*)location
{
#ifdef LSDEBUG
    NSLog(@"地理坐标信息: %@",location);
#endif
    
    CLGeocoder* geocoder=[[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray* placemarks, NSError* error) {
        
        if (placemarks.count > 0)
        {
            for(CLPlacemark* placemark in placemarks)
            {
                LSLOG(@"\n name: %@\n thoroughfare: %@\n subThoroughfare: %@\n locality: %@\n subLocality: %@\n administrativeArea: %@\n subAdministrativeArea: %@\n",
                      placemark.name,
                      placemark.thoroughfare,
                      placemark.subThoroughfare,
                      placemark.locality,
                      placemark.subLocality,
                      placemark.administrativeArea,
                      placemark.subAdministrativeArea
                      );
                //摩托罗拉大厦
                //望京东路
                //1号
                //(null)
                //朝阳区
                //北京市
                //(null)
                
                NSString* city=(placemark.administrativeArea==nil?placemark.locality:placemark.administrativeArea);
                LSLOG(@"反编译城市: %@",city);
                [locationManager.messageCenter LSMCCityCityIDWithName:city];
            }
        }
        else if (error == nil && [placemarks count] == 0)
        {
            LSLOG(@"未查询到结果");
        }
        else if (error != nil)
        {
            LSLOG(@"反编码失败: %@",error);
        }
        else
        {
            LSLOG(@"未知失败: %@",error);
        }
    }];
    
    [geocoder release];
}

#pragma mark- 消息中心通知
- (void)lsHttpRequestNotification:(NSNotification*)notification
{
    if([notification.object isEqual:lsRequestFailed])
    {
        //超时
        return;
    }
    
    if([notification.object isKindOfClass:[LSStatus class]])
    {
        //状态
        return;
    }
    
    if([notification.object isKindOfClass:[LSError class]])
    {
        //错误
        return;
    }
    
    if([notification.name isEqualToString:lsRequestTypeCityCityIDByName])
    {
//        (
//            2419,
//            "\U5317\U4eac"
//        )
        if([notification.object isKindOfClass:[NSArray class]])
        {
            locationManager.user.locationCityID=[NSString stringWithFormat:@"%@",[notification.object objectAtIndex:0]];
            locationManager.user.locationCityName=[NSString stringWithFormat:@"%@",[notification.object objectAtIndex:1]];
            
            if(![locationManager.user.cityID isEqualToString:locationManager.user.locationCityID])
            {
                [locationManager.messageCenter postNotificationName:LSNotificationLocationChanged object:nil];
            }
        }
    }
}

@end
