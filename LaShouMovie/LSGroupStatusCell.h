//
//  LSGroupStatusCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-9.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSGroupStatusCell : LSTableViewCell
{
    NSString* _status;
    BOOL _isSelect;
}
@property(nonatomic,retain) NSString* status;
@property(nonatomic,assign) BOOL isSelect;

@end
