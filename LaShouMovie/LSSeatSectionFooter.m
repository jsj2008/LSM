//
//  LSSeatSectionFooter.m
//  LaShouMovie
//
//  Created by Li XiangYu on 13-9-14.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSSeatSectionFooter.h"

@implementation LSSeatSectionFooter
@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        
        _button=[UIButton buttonWithType:UIButtonTypeCustom];
        _button.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        [_button setBackgroundImage:[UIImage stretchableImageWithImage:[UIImage lsImageNamed:@"film_select.png"] top:18 left:5 bottom:18 right:5] forState:UIControlStateNormal];
        [_button setBackgroundImage:[UIImage stretchableImageWithImage:[UIImage lsImageNamed:@"film_select_d.png"] top:18 left:5 bottom:18 right:5] forState:UIControlStateHighlighted];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button setTitle:@"选座购票" forState:UIControlStateNormal];
        _button.titleLabel.font = LSFontBold18;
        [_button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _button.frame = CGRectMake((self.width-200)/2, (self.height-44.f)/2, 200, 44);
}

- (void)buttonClick:(UIButton*)sender
{
    if([_delegate respondsToSelector:@selector(LSSeatSectionFooter: didClickButton:)])
    {
        [_delegate LSSeatSectionFooter:self didClickButton:sender];
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [[UIImage lsImageNamed:@"tab_bg.png"]  drawInRect:CGRectMake(0.f, 0.f, rect.size.width, rect.size.height)];
}


@end
