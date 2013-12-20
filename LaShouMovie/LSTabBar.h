//
//  LSTabBar.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-8-30.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSTabBarItem.h"

@protocol LSTabBarDelegate;
@interface LSTabBar : UIView<LSTabBarItemDelegate>
{
    NSArray* _itemArray;//按钮数组
    UIImage* _backgroundImage;//背景图片
    id<LSTabBarDelegate> _delegate;
    
    CGFloat _baseWidth;//基本宽度，也就是一个按钮占的宽度
    UIView* _indicator;//红色的指示器
    
    NSInteger _currentIndex;
}

@property(nonatomic,assign) NSInteger currentIndex;
@property(nonatomic,retain) NSArray* itemArray;
@property(nonatomic,retain) UIImage* backgroundImage;
@property(nonatomic,assign) id<LSTabBarDelegate> delegate;

@end

@protocol LSTabBarDelegate <NSObject>

@required
- (void)LSTabBar:(LSTabBar*)tabBar selectedIndex:(NSInteger)index;

@end
