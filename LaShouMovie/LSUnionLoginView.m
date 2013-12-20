//
//  LSUnionLoginView.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-18.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSUnionLoginView.h"

@implementation LSUnionLoginView

@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UIButton* sinaWBButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sinaWBButton.tag=LSLoginTypeSinaWB;
        sinaWBButton.frame = CGRectMake(76, 280, 44, 33);
        [sinaWBButton setBackgroundImage:[UIImage lsImageNamed:@""] forState:UIControlStateNormal];
        [sinaWBButton addTarget:self action:@selector(unionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sinaWBButton];
        
        UIButton* QQWBButton = [UIButton buttonWithType:UIButtonTypeCustom];
        QQWBButton.tag=LSLoginTypeQQWB;
        QQWBButton.frame = CGRectMake(138, 280, 44, 33);
        [QQWBButton setBackgroundImage:[UIImage lsImageNamed:@""] forState:UIControlStateNormal];
        [QQWBButton addTarget:self action:@selector(unionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:QQWBButton];
        
        UIButton* QQButton = [UIButton buttonWithType:UIButtonTypeCustom];
        QQButton.tag=LSLoginTypeQQ;
        QQButton.frame = CGRectMake(200, 280, 44, 33);
        [QQButton setBackgroundImage:[UIImage lsImageNamed:@""] forState:UIControlStateNormal];
        [QQButton addTarget:self action:@selector(unionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:QQButton];
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

#pragma mark- 私有方法
- (void)unionButtonClick:(UIButton*)sender
{
    [_delegate LSUnionLoginView:self didClickUnionLoginButton:sender];
}

@end
