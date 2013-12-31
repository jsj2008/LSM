//
//  LSGroupInfoGroupCell.m
//  LaShouMovie
//
//  Created by Li XiangYu on 13-10-10.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSGroupInfoCell.h"

#define basicWidth 280
#define basicSize CGSizeMake(basicWidth, INT32_MAX)

@implementation LSGroupInfoCell

@synthesize bottomRadius=_bottomRadius;
@synthesize text=_text;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundView=nil;
        self.backgroundColor=[UIColor clearColor];
        self.clipsToBounds=NO;
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
    
    CGContextSetAllowsAntialiasing(contextRef,true);
    CGContextSetLineWidth(contextRef, 1.f);
	CGRect rrect = CGRectMake((10.f + 1.f / 2), 0.f , (300.f - 1.f), (rect.size.height - 1.f/2));
	
	CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
	CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
    CGContextMoveToPoint(contextRef, minx, midy);
    CGContextAddArcToPoint(contextRef, minx, miny, midx, miny, 0.f);
    CGContextAddArcToPoint(contextRef, maxx, miny, maxx, midy, 0.f);
    CGContextAddArcToPoint(contextRef, maxx, maxy, midx, maxy, _bottomRadius);
    CGContextAddArcToPoint(contextRef, minx, maxy, minx, midy, _bottomRadius);
    CGContextClosePath(contextRef);
	CGContextDrawPath(contextRef, kCGPathFillStroke);
    
    CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);
    CGSize size=[_text sizeWithFont:LSFont15 constrainedToSize:CGSizeMake(rect.size.width-40.f*2, rect.size.height) lineBreakMode:NSLineBreakByCharWrapping];
    [_text drawInRect:CGRectMake(40.f, (rect.size.height-size.height)/2, size.width, size.height) withFont:LSFont15 lineBreakMode:NSLineBreakByCharWrapping];
    
    [[UIImage stretchableImageWithImage:[UIImage lsImageNamed:@"tuan_icon.png"] top:0 left:0 bottom:24 right:24] drawInRect:CGRectMake(20.f, (44.f - 16.f) / 2, 16.f, 16.f)];
    [[UIImage lsImageNamed:@"cinemas_arrow.png"] drawInRect:CGRectMake(rect.size.width - 30.f, (44.f - 15.f) / 2, 10.f, 15.f)];
}
@end
