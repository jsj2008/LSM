//
//  LSStatusView.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-23.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSCinemaStatusView.h"

@implementation LSCinemaStatusView

@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor whiteColor];

        LSSegmentedControl* segmentedControl=[[LSSegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"订座",@"团购",@"全部", nil]];
        segmentedControl.frame=CGRectInset(frame, 10.f, 10.f);
        segmentedControl.delegate=self;
        [self addSubview:segmentedControl];
        [segmentedControl release];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark- LSSegmentedControl的委托方法
- (void)LSSegmentedControl:(LSSegmentedControl *)control didSelectSegmentIndex:(NSInteger)index
{
    [_delegate LSCinemaStatusView:self didSelectRowAtIndexPath:index];
}

@end
