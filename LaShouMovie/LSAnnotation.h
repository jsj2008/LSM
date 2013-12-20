//
//  LSAnnotation.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-12.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "LSCinema.h"

@interface LSAnnotation : NSObject<MKAnnotation>
{
    NSString* _title;
    NSString* _subtitle;
    CLLocationCoordinate2D _coordinate;
    LSCinema* _cinema;
}

@property(nonatomic,copy) NSString* title;
@property(nonatomic,copy) NSString* subtitle;
@property(nonatomic,assign) CLLocationCoordinate2D coordinate;
@property(nonatomic,retain) LSCinema* cinema;


- (id)initWithTitle:(NSString*)titles subTitle:(NSString*)subTitle coordinate:(CLLocationCoordinate2D)coordinate;

@end
