//
//  LSTabBar.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-8-30.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTabBar.h"

@implementation LSTabBar

@synthesize currentIndex=_currentIndex;
@synthesize itemArray=_itemArray;
@synthesize backgroundImage=_backgroundImage;
@synthesize delegate=_delegate;

#pragma mark- 属性设置

- (void)setItemArray:(NSArray *)itemArray
{
    if(![_itemArray isEqual:itemArray])
    {
        if(_itemArray!=nil)
        {
            LSRELEASE(_itemArray);
        }
        _itemArray=[itemArray retain];
        
        [self removeAllSubview];//清除所有的子视图
        
        _baseWidth=self.width/_itemArray.count;//计算宽度
        
        _indicator=[[UIView alloc] initWithFrame:CGRectMake(0, 0, _baseWidth, self.height)];
        _indicator.clipsToBounds = YES;
        _indicator.backgroundColor = [UIColor clearColor];
        _indicator.layer.contents = (id)([UIImage lsImageNamed:@"tab_i.png"].CGImage);
        _indicator.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:_indicator];
        [_indicator release];
        
        for (int i=0; i<_itemArray.count; i++)
        {
            LSTabBarItem* tabBarItem=[_itemArray objectAtIndex:i];
            tabBarItem.delegate=self;
            [self addSubview:tabBarItem];
            tabBarItem.frame = CGRectMake(i*_baseWidth, 0, _baseWidth, self.height);
        }
    }
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    if(![_backgroundImage isEqual:backgroundImage])
    {
        if(_backgroundImage!=nil)
        {
            LSRELEASE(_backgroundImage);
        }
        _backgroundImage=[backgroundImage retain];
        
        self.layer.contents = (id)(_backgroundImage.CGImage);
    }
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    [_delegate LSTabBar:self selectedIndex:currentIndex];
    
    _indicator.frame=CGRectMake(currentIndex*_baseWidth, 0, _indicator.width, _indicator.height);
}

#pragma mark- 生命周期

- (void)dealloc
{
    self.itemArray=nil;
    self.backgroundImage=nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;//将子视图超出父视图的部分裁剪
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;//设置宽高自适应
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark- LSTabBarItem委托方法
- (void)LSTabBarItemSelected:(LSTabBarItem *)item
{
    [_delegate LSTabBar:self selectedIndex:item.itemIndex];
    
    _indicator.frame=CGRectMake(item.itemIndex*_baseWidth, 0, _indicator.width, _indicator.height);
}

@end
