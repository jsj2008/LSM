//
//  LSSelectorCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-11.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSSelectorCell : LSTableViewCell
{
    UILabel* _infoLabel;
    
    BOOL _isInitial;//是否高亮
    LSSelectorViewType _type;//类型
}

@property(nonatomic,assign) BOOL isInitial;
@property(nonatomic,assign) LSSelectorViewType type;
@property(nonatomic,retain) UILabel* infoLabel;

@end
