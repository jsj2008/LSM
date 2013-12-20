//
//  LSGroupInfoSectionHeader.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-10.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSGroupInfoSectionHeaderDelegate;
@interface LSGroupInfoSectionHeader : UIView
{
    BOOL _isOpen;
    id<LSGroupInfoSectionHeaderDelegate> _delegate;
}
@property(nonatomic,assign) BOOL isOpen;
@property(nonatomic,assign) id<LSGroupInfoSectionHeaderDelegate> delegate;

@end

@protocol LSGroupInfoSectionHeaderDelegate <NSObject>

- (void)LSGroupInfoSectionHeader:(LSGroupInfoSectionHeader*)groupInfoSectionHeader isOpen:(BOOL)isOpen;

@end
