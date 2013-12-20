//
//  LSGroupInfoGroupCell.h
//  LaShouMovie
//
//  Created by Li XiangYu on 13-10-10.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSGroupInfoCell : LSTableViewCell
{
    CGFloat _bottomRadius;
    
    NSString* _text;
}
@property(nonatomic,assign) CGFloat bottomRadius;
@property(nonatomic,retain) NSString* text;

@end
