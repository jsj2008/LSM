//
//  LSFilmPosterWillCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-19.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewCell.h"
#import "LSFilm.h"

@interface LSFilmPosterWillCell : LSTableViewCell
{
    UIImageView* _filmImageView;//显示电影图片
    
    LSFilm* _film;
}

@property(nonatomic,retain) UIImageView* filmImageView;
@property(nonatomic,retain) LSFilm* film;

@end
