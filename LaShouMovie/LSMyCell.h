//
//  LSMyCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-30.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewCell.h"

@interface LSMyCell : LSTableViewCell
{
    NSString* _imageName;
    NSString* _title;
}
@property(nonatomic,retain) NSString* title;
@property(nonatomic,retain) NSString* imageName;

@end
