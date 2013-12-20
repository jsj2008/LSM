//
//  LSTabBarItem.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-2.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTabBarItem.h"

@implementation LSTabBarItem

@synthesize itemIndex=_itemIndex;
@synthesize delegate=_delegate;

@synthesize backgroundImage=_backgroundImage;

#pragma mark- 属性设置
- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    if(![_backgroundImage isEqual:backgroundImage])
    {
        if(_backgroundImage!=nil)
        {
            LSRELEASE(_backgroundImage)
        }
        _backgroundImage=[backgroundImage retain];
        
        [self setBackgroundImage:_backgroundImage forState:UIControlStateNormal];
        [self setBackgroundImage:_backgroundImage forState:UIControlStateHighlighted];
    }
}

#pragma mark- 生命周期
- (void)dealloc
{
    self.backgroundImage=nil;
    [super dealloc];
}

- (id)init
{
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        super.backgroundColor = [UIColor clearColor];
        
        self.clipsToBounds = YES;//将子视图超出父视图的部分裁剪
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [self addTarget:self action:@selector(selfClicked:) forControlEvents:UIControlEventTouchDown];
        _itemIndex = 0;
    }
    
    return self;
}

#pragma mark- 按钮方法
- (void)selfClicked:(LSTabBarItem*)item
{
    dispatch_async(dispatch_get_main_queue(),^{
        
        [_delegate LSTabBarItemSelected:self];
    });
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
