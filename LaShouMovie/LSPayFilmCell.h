//
//  LSPayFilmCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-11-27.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSOrder.h"

@protocol LSPayFilmCellDelegate;
@interface LSPayFilmCell : LSTableViewCell
{
    UIButton* _spreadButton;
    
    LSOrder* _order;
    BOOL _isSpread;
    id<LSPayFilmCellDelegate> _delegate;
}
@property (nonatomic,retain) LSOrder* order;
@property (nonatomic,assign) BOOL isSpread;
@property (nonatomic,assign) id<LSPayFilmCellDelegate> delegate;

+ (CGFloat)heightForOrder:(LSOrder*)order;
- (void)showSpreadButton;

@end

@protocol LSPayFilmCellDelegate <NSObject>

- (void)LSPayFilmCellDidSpread;

@end
