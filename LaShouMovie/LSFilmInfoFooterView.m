//
//  LSFilmInfoFooterView.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-20.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSFilmInfoFooterView.h"

@implementation LSFilmInfoFooterView

@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=LSColorBackgroundGray;
        
        _selectButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _selectButton.layer.cornerRadius=3.f;
        _selectButton.backgroundColor=LSColorButtonNormalRed;
        _selectButton.titleLabel.font=LSFont14;
        [_selectButton setTitle:@"选座购票" forState:UIControlStateNormal];
        [_selectButton addTarget:self action:@selector(selectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_selectButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _selectButton.frame=CGRectMake(10.f, 5.f, self.width-20.f, self.height-10.f);
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
- (void)selectButtonClick:(UIButton*)sender
{
    [_delegate LSFilmInfoFooterView:self didClickSelectButton:sender];
}

@end
