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
@synthesize isCompress=_isCompress;
@synthesize positionSectionHeaderType=_positionSectionHeaderType;
@synthesize delegate=_delegate;

#pragma mark- 属性方法
- (void)setIsCompress:(BOOL)isCompress
{
    _isCompress=isCompress;
    if (_isCompress)
    {
        _button.frame = CGRectMake(self.width-85.f, (self.height-25.f)/2, 65.f, 25.f);
    }
}

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
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        
        _button=[UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(self.width-75, (self.height-25)/2, 65, 25);
        [_button setBackgroundImage:[UIImage stretchableImageWithImage:[UIImage lsImageNamed:@"cinemas_switch_section.png"] top:12 left:8 bottom:12 right:8] forState:UIControlStateNormal];
        [_button setBackgroundImage:[UIImage stretchableImageWithImage:[UIImage lsImageNamed:@"cinemas_switch_section_d.png"] top:12 left:8 bottom:12 right:8] forState:UIControlStateHighlighted];
        _button.titleLabel.font = LSFont13;
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button setTitle:@"切换区域" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if(_positionSectionHeaderType==LSPositionSectionHeaderTypeUsual)
    {
        _button.hidden=YES;
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    if (_isCompress)
    {
        [[UIImage lsImageNamed:@"cinemas_section_bg.png"] drawInRect:CGRectMake(10.f, 0.f, rect.size.width-20.f, rect.size.height)];
    }
    else
    {
        [[UIImage lsImageNamed:@"cinemas_section_bg.png"] drawInRect:CGRectMake(0.f, 0.f, rect.size.width, rect.size.height)];
    }
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    if (_title!=nil)
    {
        CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);
        CGSize size=[_title sizeWithFont:LSFont15];
        if (_isCompress)
        {
            [_title drawInRect:CGRectMake(20.f, (rect.size.height - size.height)/2, size.width, size.height) withFont:LSFont15];
        }
        else
        {
            [_title drawInRect:CGRectMake(10.f, (rect.size.height - size.height)/2, size.width, size.height) withFont:LSFont15];
        }
    }
}


#pragma mark- 按钮的目标方法
- (void)buttonClick:(UIButton*)sender
{
    if([_delegate respondsToSelector:@selector(LSPositionSectionHeader: didClickPositionButton:)])
    {
        [_delegate LSPositionSectionHeader:self didClickPositionButton:sender];
    }
}

@end
