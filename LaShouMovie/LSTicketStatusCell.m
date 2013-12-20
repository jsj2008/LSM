//
//  LSTicketStatusCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-16.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTicketStatusCell.h"

@implementation LSTicketStatusCell

@synthesize status=_status;
@synthesize isSelect=_isSelect;

- (void)dealloc
{
    self.status=nil;
    [super dealloc];
}

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
        [[UIImage stretchableImageWithImage:[UIImage lsImageNamed:@"my_group_order_tag_down.png"] top:4 left:4 bottom:4 right:4]  drawInRect:rect];
        
        CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);
    }
    else
    {
        [[UIImage stretchableImageWithImage:[UIImage lsImageNamed:@"my_group_order_tag_up.png"] top:4 left:4 bottom:4 right:4]  drawInRect:rect];
        
        CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);
    }
    
    [_status drawInRect:CGRectMake(10, 10, rect.size.width-10 , 20) withFont:LSFont18 lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
}

@end
