//
//  LSFilmInfoInfoCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-5.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSFilm.h"

@interface LSFilmInfoInfoCell : LSTableViewCell
{
    LSFilm* _film;
}
@property(nonatomic,retain) LSFilm* film;

@end
