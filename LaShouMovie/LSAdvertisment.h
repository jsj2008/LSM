//
//  LSAdvertisment.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-9.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSAdvertisment : NSObject<NSCoding>
{
//    data =     {
//        
//    };
//    imageurl = "http://filmmanage.test.lashou.com/cinema/banner/201305/53-17572.png";
//    type = 2;
    
    LSAdvertismentType _adType;
    id _data;
    NSString* _imageURL;
}
@property(nonatomic,assign) LSAdvertismentType adType;
@property(nonatomic,retain) id data;
@property(nonatomic,retain) NSString* imageURL;

- (id)initWithDictionary:(NSDictionary*)safeDic;
@end
