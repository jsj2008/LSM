//
//  LSSettingTextCell.m
//  LaShouMovie
//
//  Created by Li XiangYu on 13-10-4.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSSettingTextCell.h"

@implementation LSSettingTextCell

@synthesize text=_text;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
        self.textLabel.textColor=LSColorBlack;
        self.textLabel.font=LSFontSetTitle;
        
        _infoLabel=[[UILabel alloc] initWithFrame:CGRectZero];
        _infoLabel.textColor=LSColorBlack;
        _infoLabel.font=LSFontSetTitle;
        [self.contentView addSubview:_infoLabel];
        [_infoLabel release];
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
    CGSize size=[_text sizeWithAttributes:[LSAttribute attributeFont:LSFontSetTitle lineBreakMode:NSLineBreakByTruncatingTail]];
    _infoLabel.frame=CGRectMake(self.width-30.f-size.width, (44.f-size.height)/2, size.width, size.height);
    _infoLabel.text=_text;
}

@end
