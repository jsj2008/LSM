//
//  LSSettingCell.m
//  LaShouMovie
//
//  Created by Li XiangYu on 13-10-4.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSSettingCell.h"

@implementation LSSettingCell

@synthesize topRadius=_topRadius;
@synthesize bottomRadius=_bottomRadius;
@synthesize topMargin=_topMargin;
@synthesize isBottomLine=_isBottomLine;

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

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame=CGRectMake(self.imageView.left+10, self.imageView.top+_topMargin/2, self.imageView.width, self.imageView.height);
    self.textLabel.frame=CGRectMake(self.textLabel.left+10, self.textLabel.top+_topMargin/2, self.textLabel.width, self.textLabel.height);
    self.textLabel.backgroundColor=LSColorBgWhiteColor;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(contextRef, LSColorLineLightGrayColor.CGColor);
    CGContextSetFillColorWithColor(contextRef, LSColorBgWhiteColor.CGColor);
    
    CGContextSetAllowsAntialiasing(contextRef,true);
    CGContextSetLineWidth(contextRef, 1.f);
	CGRect rrect = CGRectMake((10 + 1.f / 2), (_topMargin+1.f/2), (300 - 1.f), (rect.size.height-_topMargin-(_isBottomLine?1.f:0.f)));
	
	CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
	CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
    CGContextMoveToPoint(contextRef, minx, midy);
    CGContextAddArcToPoint(contextRef, minx, miny, midx, miny, _topRadius);
    CGContextAddArcToPoint(contextRef, maxx, miny, maxx, midy, _topRadius);
    CGContextAddArcToPoint(contextRef, maxx, maxy, midx, maxy, _bottomRadius);
    CGContextAddArcToPoint(contextRef, minx, maxy, minx, midy, _bottomRadius);
    CGContextClosePath(contextRef);
	CGContextDrawPath(contextRef, kCGPathFillStroke);
    
    [[UIImage lsImageNamed:@"cinemas_arrow.png"] drawInRect:CGRectMake(rect.size.width - 30, (44-15)/2+_topMargin, 10, 15)];
}

@end
