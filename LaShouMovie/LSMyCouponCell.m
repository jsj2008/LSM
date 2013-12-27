//
//  LSMyCouponCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-27.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSMyCouponCell.h"

@implementation LSMyCouponCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.textLabel.font=LSFontMyTitle;
        self.textLabel.textColor=LSColorTextBlack;
        self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.text=_title;
    self.imageView.image=[UIImage lsImageNamed:_imageName];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
