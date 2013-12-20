//
//  LSStillsViewController.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-16.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewController.h"
#import "LSFilm.h"

@interface LSStillsViewController : LSTableViewController
{
    LSFilm* _film;
}
@property(nonatomic,retain) LSFilm* film;

@end
