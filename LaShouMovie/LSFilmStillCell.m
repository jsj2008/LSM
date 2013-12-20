//
//  LSStillCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-6.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSFilmStillCell.h"

@implementation LSFilmStillCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
        self.contentView.backgroundColor=[UIColor clearColor];
        self.clipsToBounds=YES;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
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
    CGRect rect=UIEdgeInsetsInsetRect(self.contentView.frame, UIEdgeInsetsMake(3, 3, 3, 3));
    self.imageView.frame=rect;
}

@end
