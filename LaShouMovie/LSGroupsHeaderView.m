//
//  LSGroupsHeaderView.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-30.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSGroupsHeaderView.h"

@implementation LSGroupsHeaderView

@synthesize delegate=_delegate;
@synthesize groupStatus=_groupStatus;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=LSColorNavigationRed;
        
        _segmentedControl=[[LSSegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"待付款", @"已付款", nil]];
        _segmentedControl.delegate=self;
        [self addSubview:_segmentedControl];
        [_segmentedControl release];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _segmentedControl.frame=CGRectInset(self.frame, 10.f, 10.f);
    if(_groupStatus)
    {
        _segmentedControl.selectedSegmentIndex=_groupStatus-1;
    }
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
    [_delegate LSGroupsHeaderView:self didSelectGroupStatus:index+1];
}
@end
