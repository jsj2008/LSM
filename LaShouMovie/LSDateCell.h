//
//  LSDateCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-12.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSDateCell : LSTableViewCell
{
    NSString* _time;
    BOOL _isSelect;
}
@property(nonatomic,retain) NSString* time;
@property(nonatomic,assign) BOOL isSelect;

@end
