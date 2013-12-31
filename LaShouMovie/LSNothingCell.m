//
//  LSNothingCell.m
//  LaShouMovie
//
//  Created by Li XiangYu on 13-10-2.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSNothingCell.h"

@implementation LSNothingCell

@synthesize title=_title;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
