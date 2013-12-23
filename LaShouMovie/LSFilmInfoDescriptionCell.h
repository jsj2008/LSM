//
//  LSFilmInfoDescriptionCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-5.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewCell.h"
#import "LSFilm.h"

@interface LSFilmInfoDescriptionCell : LSTableViewCell
{
    BOOL _isSpread;//指代是否为展开状态
    LSFilm* _film;
}

@property(nonatomic,assign) BOOL isSpread;
@property(nonatomic,retain) LSFilm* film;

+ (CGFloat)heightOfFilm:(LSFilm*) film;

@end
