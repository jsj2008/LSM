//
//  LSMySectionHeader.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-30.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSMySectionHeader.h"

@implementation LSMySectionHeader

@synthesize isOpen=_isOpen;
@synthesize mySectionHeaderType=_mySectionHeaderType;
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
    CGRect bgRect=CGRectMake(10.f, 10.f, 300.f, rect.size.height-10.f);
    [self drawRoundRectangleInRect:bgRect topRadius:3.f bottomRadius:_isOpen?0.f:3.f isBottomLine:_isOpen?NO:YES fillColor:LSColorBgWhiteColor strokeColor:LSColorLineLightGrayColor borderWidth:0.5f];
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);
    NSString *text = nil;
    if (_mySectionHeaderType==LSMySectionHeaderTypeMovie)
    {
        text = @"订座电影票";
    }
    else
    {
        text = @"团购电影票";
    }
    CGSize size=[text sizeWithFont:LSFont15 constrainedToSize:CGSizeMake(rect.size.width, rect.size.height) lineBreakMode:NSLineBreakByClipping];
    [text drawInRect:CGRectMake(45, (rect.size.height-10-size.height)/2+10, 250, size.height) withFont:LSFont15 lineBreakMode:NSLineBreakByClipping];
    
    if (_isOpen)
    {
        [[UIImage lsImageNamed:@"cinemas_arrow_down.png"] drawInRect:CGRectMake(rect.size.width - 35, (rect.size.height-10-15)/2+10, 15, 15)];
    }
    else
    {
        [[UIImage lsImageNamed:@"cinemas_arrow_right.png"] drawInRect:CGRectMake(rect.size.width - 35, (rect.size.height-10-15)/2+10, 15, 15)];
    }
    
    if (_mySectionHeaderType==LSMySectionHeaderTypeMovie)
    {
        [[UIImage lsImageNamed:@"my_ticket.png"] drawInRect:CGRectMake(20, (rect.size.height-10-19)/2+10, 19, 19)];
    }
    else
    {
        [[UIImage lsImageNamed:@"my_group.png"] drawInRect:CGRectMake(20, 23, (rect.size.height-10-19)/2+10, 19)];
    }
}


- (void)selfTap:(UITapGestureRecognizer*)recognizer
{
    _isOpen=!_isOpen;
    [self setNeedsDisplay];
    
    if([_delegate respondsToSelector:@selector(LSMySectionHeader: isOpen:)])
    {
        [_delegate LSMySectionHeader:self isOpen:_isOpen];
    }
}

@end
