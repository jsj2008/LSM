//
//  LSDateCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-12.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSDateCell.h"

@implementation LSDateCell

@synthesize title=_title;
@synthesize isSelect=_isSelect;

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

- (void)drawRect:(CGRect)rect
{
    if (_isSelect)
    {
        [self drawRectangleInRect:CGRectMake(0.f, 0.f, rect.size.width, rect.size.height) borderWidth:0.f fillColor:LSColorButtonNormalRed strokeColor:LSColorButtonNormalRed];
    }
    else
    {
        [self drawRectangleInRect:CGRectMake(0.f, 0.f, rect.size.width, rect.size.height) borderWidth:0.f fillColor:LSColorBackgroundGray strokeColor:LSColorBackgroundGray];
        
        [self drawLineAtStartPointX:0.f y:0.f endPointX:0.f y:rect.size.height strokeColor:LSColorSeparatorLineGray lineWidth:1.f];
        [self drawLineAtStartPointX:rect.size.width y:0.f endPointX:rect.size.width y:rect.size.height strokeColor:LSColorSeparatorLineGray lineWidth:1.f];
    }

    CGSize size=[_title sizeWithAttributes:[LSAttribute attributeFont:LSFontScheduleDate]];
    [_title drawInRect:CGRectMake((rect.size.width-size.width)/2, (rect.size.height-size.height)/2, size.width, size.height) withAttributes:[LSAttribute attributeFont:LSFontScheduleDate color:LSColorTextGray]];
}

@end
