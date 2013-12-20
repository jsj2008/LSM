//
//  LSCinemasMapViewController.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-10.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSViewController.h"
#import <MapKit/MapKit.h>
#import "LSAnnotation.h"

@interface LSCinemasMapViewController : LSViewController<MKMapViewDelegate,UIAlertViewDelegate>
{
    MKMapView* _mapView;
    NSArray* _cinemaArray;
    LSAnnotation* _selectAnnotation;
}
@property(nonatomic,retain) NSArray* cinemaArray;

@end
