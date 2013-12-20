//
//  LSGroupCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-13.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSCinemaGroupCell.h"

#define gapL 20.f
#define basicWidth 230.f
#define basicSize CGSizeMake(basicWidth, INT32_MAX)

@implementation LSCinemaGroupCell

@synthesize group=_group;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.clipsToBounds = YES;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor=[UIColor clearColor];
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
    [self drawRoundRectangleInRect:CGRectMake(10.f, 10.f, 300.f, 44.f) topRadius:3.f bottomRadius:3.f isBottomLine:YES fillColor:LSColorBgWhiteColor strokeColor:LSColorLineLightGrayColor borderWidth:0.5f];

    [[UIImage lsImageNamed:@"tuan_icon.png"] drawInRect:CGRectMake(gapL, (rect.size.height-16.f)/2, 16.f, 16.f)];
    
    if(_group.groupTitle!=nil)
    {
        CGContextRef contextRef = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);
        CGSize size=[_group.groupTitle sizeWithFont:LSFont15 constrainedToSize:basicSize lineBreakMode:NSLineBreakByCharWrapping];
        if(size.height>34.f)
        {
            size=[_group.groupTitle sizeWithFont:LSFont15 constrainedToSize:CGSizeMake(basicWidth, 34.f) lineBreakMode:NSLineBreakByTruncatingTail];
            [_group.groupTitle drawInRect:CGRectMake(40.f, (rect.size.height-size.height)/2, size.width, size.height) withFont:LSFont15 lineBreakMode:NSLineBreakByTruncatingTail];
        }
        else
        {
            [_group.groupTitle drawInRect:CGRectMake(40.f, (rect.size.height-size.height)/2, size.width, size.height) withFont:LSFont15 lineBreakMode:NSLineBreakByCharWrapping];
        }
    }
    
    [[UIImage lsImageNamed:@"cinemas_arrow.png"] drawInRect:CGRectMake(rect.size.width - 40.f, (rect.size.height-15.f)/2, 10.f, 15.f)];
}


@end
