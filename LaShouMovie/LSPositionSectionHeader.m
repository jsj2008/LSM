//
//  LSPositionSectionHeader.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-10.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSPositionSectionHeader.h"

@implementation LSPositionSectionHeader

@synthesize title=_title;
@synthesize positionSectionHeaderType=_positionSectionHeaderType;
@synthesize delegate=_delegate;

#pragma mark- 生命周期
- (void)dealloc
{
    self.title = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.backgroundColor=LSColorBackgroundGray;

        _positionButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        _positionButton.titleLabel.font = LSFontButton;
        [_positionButton setTitleColor:LSColorTextRed forState:UIControlStateNormal];
        [_positionButton setTitle:@"切换区域" forState:UIControlStateNormal];
        [_positionButton addTarget:self action:@selector(positionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_positionButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _positionButton.frame = CGRectMake(self.width-75.f, 0.f, 65.f, self.height);
    if(_positionSectionHeaderType==LSPositionSectionHeaderTypeUsual)
    {
        _positionButton.hidden=YES;
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGRect nameRect = [_title boundingRectWithSize:CGSizeMake(rect.size.width, INT32_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[LSAttribute attributeFont:LSFontSection] context:nil];
    [_title drawInRect:CGRectMake(10.f, (rect.size.height - nameRect.size.height)/2, nameRect.size.width, nameRect.size.height) withAttributes:[LSAttribute attributeFont:LSFontSection color:LSColorTextGray]];
}


#pragma mark- 按钮的目标方法
- (void)buttonClick:(UIButton*)sender
{
    [_delegate LSPositionSectionHeader:self didClickPositionButton:sender];
}

@end
