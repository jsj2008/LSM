//
//  LSMyCouponCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-27.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewCell.h"

@interface LSMyCouponCell : LSTableViewCell
{
    NSString* _imageName;
    NSString* _title;
}
@property(nonatomic,retain) NSString* title;
@property(nonatomic,retain) NSString* imageName;

@end
