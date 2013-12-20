//
//  LSRowNumberView.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-16.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSRowNumberView.h"

#define LSSeatRowSpace @"space"

@implementation LSRowNumberView
@synthesize rowIDArray=_rowIDArray;

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
        self.backgroundColor = [UIColor clearColor];
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
    if (_rowIDArray.count==0)
        return;
    
    CGFloat positionY=_paddingY;
    
    for(NSString* number in _rowIDArray)
    {
        positionY+=_basicPadding;
        if(![number isEqual:@"space"])
        {
            [number drawInRect:CGRectMake(0, positionY, rect.size.width, _basicContentSide) withFont:[UIFont systemFontOfSize:15.0f*(_basicAreaSide/40.f)] lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
        }
        positionY+=(_basicContentSide+_basicPadding);
    }
}


@end
