//
//  LSMyMobileCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-30.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSMyMobileCellDelegate;
@interface LSMyMobileCell : LSTableViewCell
{
    UIButton* _bindButton;
    id<LSMyMobileCellDelegate> _delegate;
}
@property(nonatomic,assign) id<LSMyMobileCellDelegate> delegate;

@end

@protocol LSMyMobileCellDelegate <NSObject>

- (void)LSMyMobileCellDidSelect;

@end
