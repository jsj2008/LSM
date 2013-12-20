//
//  LSPositionSectionHeader.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-10.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    LSPositionSectionHeaderTypeNear=0,//附近区域
    LSPositionSectionHeaderTypeUsual=1//常去
}LSPositionSectionHeaderType;

@protocol LSPositionSectionHeaderDelegate;
@interface LSPositionSectionHeader : UIView
{
    UIButton* _positionButton;
    NSString* _title;//标题
    LSPositionSectionHeaderType _positionSectionHeaderType;//类型
    
    id<LSPositionSectionHeaderDelegate> _delegate;
}

@property(nonatomic,retain) NSString* title;//标题
@property(nonatomic,assign) LSPositionSectionHeaderType positionSectionHeaderType;//类型
@property(nonatomic,assign) id<LSPositionSectionHeaderDelegate> delegate;

@end

@protocol LSPositionSectionHeaderDelegate <NSObject>

@required
- (void)LSPositionSectionHeader:(LSPositionSectionHeader*)positionSectionHeader didClickPositionButton:(UIButton*)positionButton;

@end
