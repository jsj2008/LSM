//
//  LSTableViewCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-18.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewCell.h"

@implementation LSTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.clipsToBounds = YES;
        self.backgroundColor=LSColorClear;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect
{
    if(_standardBottomLine)
    {
        [self drawLineAtStartPointX:10.f y:rect.size.height endPointX:rect.size.width y:rect.size.height strokeColor:LSColorSeparatorLineGray lineWidth:0.5f];
    }
    else if(_wholeBottomLine)
    {
        [self drawLineAtStartPointX:0.f y:rect.size.height endPointX:rect.size.width y:rect.size.height strokeColor:LSColorSeparatorLineGray lineWidth:0.5f];
    }
}

@end
