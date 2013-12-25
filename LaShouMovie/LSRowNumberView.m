//
//  LSRowNumberView.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-16.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSRowNumberView.h"

@implementation LSRowNumberView

@synthesize rowIDArray=_rowIDArray;
@synthesize paddingY=_paddingY;
@synthesize seatHeight=_seatHeight;
@synthesize basicPaddingY=_basicPaddingY;
@synthesize space=_space;

#pragma mark- 生命周期
- (void)dealloc
{
    self.rowIDArray=nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = LSColorBackgroundGray;
        self.userInteractionEnabled = NO;
        self.clipsToBounds = YES;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGFloat contentY=_paddingY;
    for(NSArray* rowIDArray in _rowIDArray)
    {
        for(NSString* number in rowIDArray)
        {
            if(![number isEqualToString:LSSeatRowSpace])
            {
                [number drawInRect:CGRectMake(0.f, contentY, rect.size.width, _seatHeight) withAttributes:[LSAttribute attributeFont:LSFontSeatRowID color:LSColorWhite textAlignment:NSTextAlignmentCenter]];
            }
            contentY+=(_seatHeight+_basicPaddingY);
        }
        
        contentY-=_basicPaddingY;
        contentY+=_space;
    }
}

@end
