//
//  LSCinemaCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-10.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSCinema.h"

@interface LSCinemaCell : LSTableViewCell
{
    LSCinema* _cinema;
}
@property(nonatomic,retain) LSCinema* cinema;
+ (CGFloat)heightForCinema:(LSCinema*)cinema;

@end
