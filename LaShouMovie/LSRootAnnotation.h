//
//  LSRootAnnotation.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-12.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface LSRootAnnotation : NSObject<MKAnnotation>
{
    NSString* _title;
    NSString* _subtitle;
    CLLocationCoordinate2D _coordinate;
}

@property(nonatomic,copy) NSString* title;
@property(nonatomic,copy) NSString* subtitle;
@property(nonatomic,assign) CLLocationCoordinate2D coordinate;

- (id)initWithTitle:(NSString*)titles subTitle:(NSString*)subTitle coordinate:(CLLocationCoordinate2D)coordinate;

@end
