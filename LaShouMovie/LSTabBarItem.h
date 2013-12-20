//
//  LSTabBarItem.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-2.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSTabBarItemDelegate;

@interface LSTabBarItem : UIButton
{
    NSInteger _itemIndex;//按钮代表的视图位置
    id<LSTabBarItemDelegate> _delegate;
    
    UIImage* _backgroundImage;//按钮的背景图
}

@property(nonatomic,assign) NSInteger itemIndex;
@property(nonatomic,assign) id<LSTabBarItemDelegate> delegate;

@property(nonatomic,retain) UIImage* backgroundImage;

@end

@protocol LSTabBarItemDelegate <NSObject>

@required
- (void)LSTabBarItemSelected:(LSTabBarItem*)item;

@end
