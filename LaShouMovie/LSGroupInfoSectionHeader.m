//
//  LSGroupInfoSectionHeader.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-10.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSGroupInfoSectionHeader.h"

@implementation LSGroupInfoSectionHeader

@synthesize isOpen=_isOpen;
@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
        
        UITapGestureRecognizer* tapGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfTap:)];
        [self addGestureRecognizer:tapGestureRecognizer];
        [tapGestureRecognizer release];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGContextSetAllowsAntialiasing(contextRef,true);
    CGContextSetLineWidth(contextRef, 1.f);
	CGRect rrect = CGRectMake((10.f + 1.f / 2), (10.f + 1.f / 2), (300.f - 1.f), (rect.size.height - 10.f - 1.f));
	
	CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
	CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
    CGContextMoveToPoint(contextRef, minx, midy);
    if (_isOpen)
    {
        CGContextAddArcToPoint(contextRef, minx, miny, midx, miny, 3.f);
        CGContextAddArcToPoint(contextRef, maxx, miny, maxx, midy, 3.f);
        CGContextAddArcToPoint(contextRef, maxx, maxy, midx, maxy, 0.f);
        CGContextAddArcToPoint(contextRef, minx, maxy, minx, midy, 0.f);
    }
    else
    {
        CGContextAddArcToPoint(contextRef, minx, miny, midx, miny, 3.f);
        CGContextAddArcToPoint(contextRef, maxx, miny, maxx, midy, 3.f);
        CGContextAddArcToPoint(contextRef, maxx, maxy, midx, maxy, 3.f);
        CGContextAddArcToPoint(contextRef, minx, maxy, minx, midy, 3.f);
    }
    CGContextClosePath(contextRef);
	CGContextDrawPath(contextRef, kCGPathFillStroke);
    
    
    CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);
    NSString *text = @"其他团购";
    CGSize size=[text sizeWithFont:LSFont15];
    [text drawInRect:CGRectMake(20.f, (rect.size.height-10-size.height)/2+10, 250, size.height) withFont:LSFont15];
    
    if (_isOpen)
    {
        [[UIImage lsImageNamed:@"cinemas_arrow_down.png"] drawInRect:CGRectMake(rect.size.width - 35.f, (rect.size.height - 10.f -15.f)/2 + 10.f, 15.f, 15.f)];
    }
    else
    {
        [[UIImage lsImageNamed:@"cinemas_arrow_right.png"] drawInRect:CGRectMake(rect.size.width - 35.f, (rect.size.height - 10.f -15.f)/2 + 10.f, 15.f, 15.f)];
    }
}


- (void)selfTap:(UITapGestureRecognizer*)recognizer
{
    _isOpen=!_isOpen;
    [self setNeedsDisplay];
    
    if([_delegate respondsToSelector:@selector(LSGroupInfoSectionHeader: isOpen:)])
    {
        [_delegate LSGroupInfoSectionHeader:self isOpen:_isOpen];
    }
}

@end
