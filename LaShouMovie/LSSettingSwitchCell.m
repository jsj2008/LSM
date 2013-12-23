//
//  LSSettingWifiCell.m
//  LaShouMovie
//
//  Created by Li XiangYu on 13-10-4.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSSettingSwitchCell.h"

@implementation LSSettingSwitchCell

@synthesize topRadius=_topRadius;
@synthesize topMargin=_topMargin;
@synthesize isTurnOn=_isTurnOn;
@synthesize delegate=_delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _switch=[[UISwitch alloc] initWithFrame:CGRectZero];
        [_switch addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_switch];
        [_switch release];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame=CGRectMake(self.imageView.left+10, self.imageView.top+_topMargin/2, self.imageView.width, self.imageView.height);
    self.textLabel.frame=CGRectMake(self.textLabel.left+10, self.textLabel.top+_topMargin/2, self.textLabel.width, self.textLabel.height);
    self.textLabel.backgroundColor=LSColorBgWhiteColor;

    _switch.frame=CGRectMake(self.width-(LSiOS7?65.f:95.f), 7.f+(_topMargin>0.f?_topMargin:0.f), 55.f, 30.f);
    _switch.on=_isTurnOn;
}

- (void)drawRect:(CGRect)rect
{
    CGRect bgRect=CGRectMake(10.f, _topMargin, rect.size.width-10.f*2, rect.size.height-_topMargin);
    
    [self drawRoundRectangleInRect:bgRect topRadius:_topRadius bottomRadius:0.f isBottomLine:NO fillColor:LSColorBgWhiteColor strokeColor:LSColorLineLightGrayColor borderWidth:0.5f];
}

#pragma mark- UISwitch值变化的方法
- (void)switchValueChange:(UISwitch*)sender
{
    _isTurnOn=!_isTurnOn;
    
    if([_delegate respondsToSelector:@selector(LSSettingSwitchCell: didChangeValue:)])
    {
        [_delegate LSSettingSwitchCell:self didChangeValue:_isTurnOn];
    }
}

@end
