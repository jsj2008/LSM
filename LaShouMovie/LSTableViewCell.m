//
//  LSTableViewCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-18.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewCell.h"

@implementation LSTableViewCell

@synthesize isClearBG=_isClearBG;
@synthesize standardBottomLine=_standardBottomLine;
@synthesize noBottomLine=_noBottomLine;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor=LSColorClear;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
    if(!_isClearBG)
    {
        [self drawRectangleInRect:rect fillColor:LSColorWhite];
    }
    
    if(!_noBottomLine)
    {
        if(_standardBottomLine)
        {
            [self drawLineAtStartPointX:10.f y:rect.size.height endPointX:rect.size.width y:rect.size.height strokeColor:LSColorSeparatorLineGray lineWidth:0.3f];
        }
        else
        {
            [self drawLineAtStartPointX:0.f y:rect.size.height endPointX:rect.size.width y:rect.size.height strokeColor:LSColorSeparatorLineGray lineWidth:0.3f];
        }
    }
}

@end
