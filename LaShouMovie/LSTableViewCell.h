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
    BOOL _standardBottomLine;
    BOOL _wholeBottomLine;
}
@property(nonatomic,assign) BOOL standardBottomLine;
@property(nonatomic,assign) BOOL wholeBottomLine;

@end
