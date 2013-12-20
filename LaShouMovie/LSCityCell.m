//
//  LSCityCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-6.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSCityCell.h"

@implementation LSCityCell

@synthesize city=_city;

- (void)dealloc
{
    self.city=nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.textLabel.font = LSFontBold16;
        self.textLabel.textColor = [UIColor grayColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.text=_city.cityName;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
