//
//  LSTableViewCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-18.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSTableViewCell : UITableViewCell
{
    BOOL _isClearBG;
    BOOL _standardBottomLine;
    BOOL _noBottomLine;
}
@property(nonatomic,assign) BOOL isClearBG;
@property(nonatomic,assign) BOOL standardBottomLine;
@property(nonatomic,assign) BOOL noBottomLine;

@end
