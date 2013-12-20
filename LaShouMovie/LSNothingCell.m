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
        self.backgroundColor=[UIColor clearColor];
        self.contentView.backgroundColor=[UIColor clearColor];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.clipsToBounds = YES;
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
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    [self drawRoundRectangleInRect:rect topRadius:0.f bottomRadius:0.f isBottomLine:YES fillColor:[UIColor whiteColor] strokeColor:[UIColor whiteColor] borderWidth:0.f];
        
    [self drawLineAtStartPointX:0 y:rect.size.height endPointX:rect.size.width y:rect.size.height strokeColor:LSColorLineLightGrayColor lineWidth:1];

    if(_title!=nil)
    {
        CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);
        CGSize size=[_title sizeWithFont:LSFont17];
        [_title drawInRect:CGRectMake((rect.size.width-size.width)/2, (rect.size.height-size.height)/2, size.width, size.height) withFont:LSFont17];
    }
}

@end
