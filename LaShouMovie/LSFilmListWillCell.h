//
//  LSFilmListWillCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-14.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSFilm.h"

@interface LSFilmListWillCell : LSTableViewCell
{
    UIImageView* _filmImageView;//显示电影图片
    
    LSFilm* _film;
}

@property(nonatomic,retain) UIImageView* filmImageView;
@property(nonatomic,retain) LSFilm* film;

@end
