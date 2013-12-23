//
//  LSStillCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-16.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewCell.h"

@interface LSStillCell : LSTableViewCell<UIScrollViewDelegate>
{
    UIScrollView* _scrollView;
    UIImageView* _stillImageView;
    NSString* _stillURL;
    NSString* _bigStillURL;
}
@property(nonatomic,retain) NSString* bigStillURL;
@property(nonatomic,retain) NSString* stillURL;

@end
