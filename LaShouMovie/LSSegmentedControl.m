//
//  LSSegmentedControl.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-19.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSSegmentedControl.h"

@implementation LSSegmentedControl

- (id)initWithItems:(NSArray *)items
{
    self = [super initWithItems:items];
    if (self) {
        // Initialization code
//        self.backgroundColor=LSColorButtonHighlightedRed;
        self.tintColor=LSColorButtonHighlightedRed;
        [self setTitleTextAttributes:[LSAttribute attributeFont:LSFont13 color:LSColorWhite] forState:UIControlStateNormal];
        [self setTitleTextAttributes:[LSAttribute attributeFont:LSFont13 color:LSColorWhite] forState:UIControlStateHighlighted];
        [self setTitleTextAttributes:[LSAttribute attributeFont:LSFont13 color:LSColorWhite] forState:UIControlStateSelected];
        [self addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
        self.selectedSegmentIndex=0;
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
    [_delegate LSSegmentedControl:self didSelectSegmentIndex:sender.selectedSegmentIndex];
}

@end
