//
//  LSPaySeatCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-11-27.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSOrder.h"

@protocol LSPaySeatCellDelegate;
@interface LSPaySeatCell : LSTableViewCell
{
    UIButton* _spreadButton;
    
    LSOrder* _order;
    id<LSPaySeatCellDelegate> _delegate;
}
@property (nonatomic,retain) LSOrder* order;
@property (nonatomic,assign) id<LSPaySeatCellDelegate> delegate;

+ (CGFloat)heightForOrder:(LSOrder*)order;

@end

@protocol LSPaySeatCellDelegate <NSObject>

- (void)LSPaySeatCellDidFold;

@end
