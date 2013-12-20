//
//  LSSwitchSectionHeader.h
//  LaShouMovie
//
//  Created by Li XiangYu on 13-9-15.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSSwitchSectionHeaderDelegate;
@interface LSSwitchSectionHeader : UIView
{
    UIImageView* _arrowImageView;
    UIButton* _button;
    BOOL _isSpread;//是否为展开状态
    id<LSSwitchSectionHeaderDelegate> _delegate;
}
@property(nonatomic,assign) BOOL isSpread;;
@property(nonatomic,assign) id<LSSwitchSectionHeaderDelegate> delegate;

@end

@protocol LSSwitchSectionHeaderDelegate <NSObject>

- (void)LSSwitchSectionHeader:(LSSwitchSectionHeader*)switchSectionHeader isSpread:(BOOL)isSpread;

@end
