//
//  LSAboutBriefCell.m
//  LaShouMovie
//
//  Created by Li XiangYu on 13-10-4.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSAboutBriefCell.h"

@implementation LSAboutBriefCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundView=nil;
        self.backgroundColor=[UIColor clearColor];
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
    CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);
    NSString* text = [NSString stringWithFormat:@"%@是拉手网为您精心打造的电影在线订做APP，为您提供全国各大知名影院的在线订座服务，可以查看热映影片的排期，并可以用手机直接在订座购票，无需排队，体验最好的位置，节省宝贵的时间，达到最佳观影享受。", lsSoftwareName];
    CGSize size=[text sizeWithFont:LSFont14 constrainedToSize:CGSizeMake(rect.size.width-20*2, rect.size.height) lineBreakMode:NSLineBreakByTruncatingTail];
    [text drawInRect:CGRectMake(20, 10, rect.size.width-20*2, size.height) withFont:LSFont14];
}

@end
