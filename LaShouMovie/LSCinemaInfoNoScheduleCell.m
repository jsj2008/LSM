//
//  LSCinemaInfoNoScheduleCell.m
//  LaShouMovie
//
//  Created by Li XiangYu on 13-9-14.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSCinemaInfoNoScheduleCell.h"

@implementation LSCinemaInfoNoScheduleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.clipsToBounds = YES;
        self.contentView.backgroundColor=[UIColor clearColor];
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
    [[UIImage stretchableImageWithImage:[UIImage lsImageNamed:@"schedule_bg.png"] top:22 left:7 bottom:22 right:7] drawInRect:CGRectMake(11, 0, rect.size.width-22, rect.size.height)];
    
    [self drawLineAtStartPointX:20 y:0 endPointX:rect.size.width-20 y:0 strokeColor:LSColorLineLightGrayColor lineWidth:2];
    
    [self drawLineAtStartPointX:20 y:rect.size.height endPointX:rect.size.width-20 y:rect.size.height strokeColor:LSColorLineLightGrayColor lineWidth:2];
    
    NSString* text=@"暂无排期";
    CGSize size=[text sizeWithFont:[UIFont systemFontOfSize:17.0]];
    [text drawInRect:CGRectMake((rect.size.width-size.width)/2, (rect.size.height-size.height)/2, size.width, size.height) withFont:LSFont17 lineBreakMode:NSLineBreakByClipping];
}

@end
