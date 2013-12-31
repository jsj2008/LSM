//
//  LSDateCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-12.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewCell.h"

@interface LSDateCell : LSTableViewCell
{
    NSString* _title;
    BOOL _isSelect;
}
@property(nonatomic,retain) NSString* title;
@property(nonatomic,assign) BOOL isSelect;

@end
