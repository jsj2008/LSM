//
//  LSSwitchSectionHeader.m
//  LaShouMovie
//
//  Created by Li XiangYu on 13-9-15.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSSwitchSectionHeader.h"

@implementation LSSwitchSectionHeader

@synthesize delegate=_delegate;
@synthesize isSpread=_isSpread;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = frame;
        _button.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [_button setTitleEdgeInsets:UIEdgeInsetsMake(5, -30, 0, 0)];
        _button.titleLabel.font = LSFont17;
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button setTitle:@"选择影院其他场次" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
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
- (void)layoutSubviews
{
    [super layoutSubviews];
    if(_isSpread)
    {
        [_button setBackgroundImage:[UIImage lsImageNamed:@"seat_schedule_down.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_button setBackgroundImage:[UIImage lsImageNamed:@"seat_schedule_up.png"] forState:UIControlStateNormal];
    }
}

- (void)buttonClick:(UIButton*)sender
{
    _isSpread=!_isSpread;
    [self setNeedsLayout];
    
    if([_delegate respondsToSelector:@selector(LSSwitchSectionHeader: isSpread:)])
    {
        [_delegate LSSwitchSectionHeader:self isSpread:_isSpread];
    }
}

@end
