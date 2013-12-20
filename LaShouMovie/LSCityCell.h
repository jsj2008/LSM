//
//  LSCityCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-6.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSCity.h"

@interface LSCityCell : LSTableViewCell
{
    LSCity* _city;
}
@property(nonatomic,retain) LSCity* city;

@end
