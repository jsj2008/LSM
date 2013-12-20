//
//  LSStatusCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-23.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSCinemaStatusCell : LSTableViewCell
{
    NSString* _status;
    BOOL _isSelect;
}
@property(nonatomic,retain) NSString* status;
@property(nonatomic,assign) BOOL isSelect;

@end
