//
//  LSAdvertisment.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-9.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSAdvertisment.h"
#import "LSCinema.h"
#import "LSFilm.h"
#import "LSActivity.h"

@implementation LSAdvertisment

@synthesize adType = _adType;
@synthesize data = _data;
@synthesize imageURL = _imageURL;

- (id)initWithDictionary:(NSDictionary*)safeDic
{
    self=[super init];
    if(self!=nil)
    {
        self.adType=[[safeDic objectForKey:@"type"] integerValue];
        
        if(_adType==LSAdvertismentTypeNotNeedShow)
        {
            
        }
        else if(_adType==LSAdvertismentTypeShowImage)
        {
            
        }
        else if(_adType==LSAdvertismentTypeToFilmView)
        {
            LSFilm* film=[[LSFilm alloc] initWithDictionary:[safeDic objectForKey:@"data"]];
            self.data=film;
            [film release];
        }
        else if(_adType==LSAdvertismentTypeToCinemaView)
        {
            LSCinema* cinema=[[LSCinema alloc] initWithDictionary:[safeDic objectForKey:@"data"]];
            self.data=cinema;
            [cinema release];
        }
        else if(_adType==LSAdvertismentTypeToWapView)
        {
            
        }
        else if(_adType==LSAdvertismentTypeToActivity)
        {
            LSActivity* activity=[[LSActivity alloc] initWithDictionary:[safeDic objectForKey:@"data"]];
            self.data=activity;
            [activity release];
        }
        
        self.imageURL=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"imageurl"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:_adType forKey:@"adType"];
    [aCoder encodeObject:_data forKey:@"data"];
    [aCoder encodeObject:_imageURL forKey:@"imageURL"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self.adType=[decoder decodeIntForKey:@"adType"];
    self.data=[decoder decodeObjectForKey:@"data"];
    self.imageURL=[decoder decodeObjectForKey:@"imageURL"];
    return self;
}

@end
