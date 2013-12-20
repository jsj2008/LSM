//
//  LSSegmentedControl.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-19.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSSegmentedControl.h"

@implementation LSSegmentedControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithItems:(NSArray *)items
{
    self = [super initWithItems:items];
    if (self) {
        // Initialization code
        [self setDividerImage:[UIImage lsImageNamed:@""] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [self setDividerImage:[UIImage lsImageNamed:@""] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        [self addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
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

- (void)valueChanged:(UISegmentedControl*)sender
{
    [_delegate LSSegmentedControl:self didChangeValue:sender.selectedSegmentIndex];
}

@end
