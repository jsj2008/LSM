//
//  LSSettingWifiCell.m
//  LaShouMovie
//
//  Created by Li XiangYu on 13-10-4.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSSettingSwitchCell.h"

@implementation LSSettingSwitchCell

@synthesize isTurnOn=_isTurnOn;
@synthesize delegate=_delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.textLabel.textColor=LSColorBlack;
        self.textLabel.font=LSFontSetTitle;
        
        _switch=[[UISwitch alloc] initWithFrame:CGRectMake(255.f, 7.f, 55.f, 30.f)];
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
    _switch.on=_isTurnOn;
}

#pragma mark- UISwitch值变化的方法
- (void)switchValueChange:(UISwitch*)sender
{
    _isTurnOn=!_isTurnOn;
    [_delegate LSSettingSwitchCell:self didChangeValue:_isTurnOn];
}

@end
