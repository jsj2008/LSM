//
//  LSCinemaMapViewController.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-12.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSViewController.h"
#import <MapKit/MapKit.h>
#import "LSCinema.h"

@interface LSCinemaMapViewController : LSViewController<CLLocationManagerDelegate,MKMapViewDelegate,UIAlertViewDelegate>
{
    MKMapView* _mapView;
    UIImageView* _locationImageView;
    CLLocation* _location;//地理位置
    
    BOOL _isLocation;//是否因为定位导致的移动
    BOOL _isAdapt;//是否因为适应导致的地图缩放
    BOOL _isAnnotation;//是否因为适应导致地图缩放后却不能满足影院显示Annotation导致的地图移动
    BOOL _isCanShowRootAnnotation;//是否现在允许显示RootAnnotation
    
    LSCinema* _cinema;
}
@property(nonatomic,retain) LSCinema* cinema;

@end
