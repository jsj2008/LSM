//
//  LSDateCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-12.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSDateCell.h"

@implementation LSDateCell

@synthesize time=_time;
@synthesize isSelect=_isSelect;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.clipsToBounds=YES;
        self.backgroundColor=[UIColor clearColor];
        self.contentView.backgroundColor=[UIColor clearColor];
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
    if (_isSelect)
    {
        [self drawRoundRectangleInRect:CGRectMake(1.f, 1.f, rect.size.width-2.f, rect.size.height-2.f)  topRadius:0.f bottomRadius:0.f isBottomLine:YES fillColor:LSColorBlackRedColor strokeColor:LSColorBlackRedColor borderWidth:0.f];

        CGContextSetFillColorWithColor(contextRef, [UIColor whiteColor].CGColor);
    }
    else
    {
        [[UIImage stretchableImageWithImage:[UIImage lsImageNamed:@"date_sel_bg.png"] top:21 left:5 bottom:21 right:5]  drawInRect:rect];
        
        CGContextRef contextRef = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);
    }
    
    CGSize size=[_time sizeWithFont:LSFont14];
    [_time drawInRect:CGRectMake((rect.size.width-size.width)/2, (rect.size.height-size.height)/2, size.width, size.height) withFont:LSFont14];
}

@end
