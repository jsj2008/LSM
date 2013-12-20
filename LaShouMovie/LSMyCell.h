//
//  LSMyCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-30.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSMyCell : LSTableViewCell
{
    NSString* _category;
    int _count;
}
@property(nonatomic,retain) NSString* category;
@property(nonatomic,assign) int count;

@end
