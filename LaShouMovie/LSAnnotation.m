//
//  LSAnnotation.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-12.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSAnnotation.h"

@implementation LSAnnotation

@synthesize title=_title;
@synthesize subtitle=_subtitle;
@synthesize coordinate=_coordinate;
@synthesize cinema=_cinema;

- (id)initWithTitle:(NSString*)title subTitle:(NSString*)subTitle coordinate:(CLLocationCoordinate2D)coordinate
{
    self=[super init];
    if(self)
    {
        self.title=title;
        self.subtitle=subTitle;
        self.coordinate=coordinate;
    }
    return self;
}

@end
