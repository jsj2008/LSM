//
//  LSGroupInfoInfoCell.h
//  LaShouMovie
//
//  Created by Li XiangYu on 13-10-10.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewCell.h"
#import "LSGroup.h"

@interface LSGroupInfoInfoCell : LSTableViewCell
{
    LSGroup* _group;
}
@property(nonatomic,retain) LSGroup* group;

+ (CGFloat)heightOfGroup:(LSGroup*)group;

@end
