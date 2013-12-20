//
//  LSFilmListCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-4.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSFilm.h"

@interface LSFilmListShowCell : LSTableViewCell
{
    UIImageView* _filmImageView;//显示电影图片
    UIImageView* _starImageView;//显示星级图片
    
    LSFilm* _film;
}

@property(nonatomic,retain) LSFilm* film;
@property(nonatomic,retain) UIImageView* filmImageView;

@end
