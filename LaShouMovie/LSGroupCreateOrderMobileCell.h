//
//  LSGroupCreateOrderMobileCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-12.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewCell.h"

@protocol LSGroupCreateOrderMobileCellDelegate;
@interface LSGroupCreateOrderMobileCell : LSTableViewCell
{
    UIButton* _bindButton;
    id<LSGroupCreateOrderMobileCellDelegate> _delegate;
}
@property(nonatomic,assign) id<LSGroupCreateOrderMobileCellDelegate> delegate;

@end

@protocol LSGroupCreateOrderMobileCellDelegate <NSObject>

- (void)LSGroupCreateOrderMobileCellDidSelect;

@end
