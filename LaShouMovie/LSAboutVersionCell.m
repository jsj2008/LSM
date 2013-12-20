//
//  LSAboutVersionCell.m
//  LaShouMovie
//
//  Created by Li XiangYu on 13-10-4.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSAboutVersionCell.h"

@implementation LSAboutVersionCell

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
    CGFloat contentY=10.f;
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);
    NSString* text = [NSString stringWithFormat:@"版本号：V%@", lsSoftwareVersion];
    CGSize size=[text sizeWithFont:LSFont14 constrainedToSize:CGSizeMake(rect.size.width-20*2, rect.size.height) lineBreakMode:NSLineBreakByTruncatingTail];
    [text drawInRect:CGRectMake(20, contentY, rect.size.width-20*2, size.height) withFont:LSFont14 lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
    
    contentY+=size.height;
    contentY+=10;
    
    text = @"@ 2013 北京拉手网络技术有限公司 LaShou.com";
    size=[text sizeWithFont:LSFont13 constrainedToSize:CGSizeMake(rect.size.width-10*2, rect.size.height) lineBreakMode:NSLineBreakByTruncatingTail];
    [text drawInRect:CGRectMake(10, contentY, rect.size.width-10*2, size.height) withFont:LSFont13 lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
}

@end
