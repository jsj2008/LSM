//
//  LSDistrictSelectorCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-20.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSDistrictSelectorCell.h"

@implementation LSDistrictSelectorCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.textLabel.font = LSFontSectionHeader;
        self.textLabel.textColor = LSColorTextBlack;
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

@end
