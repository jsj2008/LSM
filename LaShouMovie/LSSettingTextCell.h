//
//  LSSettingTextCell.h
//  LaShouMovie
//
//  Created by Li XiangYu on 13-10-4.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewCell.h"

@interface LSSettingTextCell : LSTableViewCell
{
    UILabel* _infoLabel;
    NSString* _text;
}
@property(nonatomic,retain) NSString* text;

@end
