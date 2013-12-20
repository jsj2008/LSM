//
//  LSStatusCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-23.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSCinemaStatusCell.h"

@implementation LSCinemaStatusCell

@synthesize status=_status;
@synthesize isSelect=_isSelect;

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

- (void)drawRect:(CGRect)rect
{
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    if (_isSelect)
    {
        [self drawRoundRectangleInRect:CGRectMake(1, 1, rect.size.width-2, rect.size.height-2) topRadius:0.f bottomRadius:0.f isBottomLine:YES fillColor:LSColorBlackRedColor strokeColor:LSColorBlackRedColor borderWidth:0.f];
        
        CGContextSetFillColorWithColor(contextRef, [UIColor whiteColor].CGColor);
    }
    else
    {
        [[UIImage stretchableImageWithImage:[UIImage lsImageNamed:@"date_sel_bg.png"] top:21 left:5 bottom:21 right:5]  drawInRect:rect];
        
        CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);
    }
    
    CGSize size=[_status sizeWithFont:LSFont18];
    [_status drawInRect:CGRectMake((rect.size.width-size.width)/2, (rect.size.height-size.height)/2, size.width, size.height) withFont:LSFont18];
}

@end
