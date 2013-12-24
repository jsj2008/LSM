//
//  LSSwitchScheduleView.m
//  LaShouMovie
//
//  Created by Li XiangYu on 13-9-15.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSSwitchScheduleView.h"
#import "LSSchedule.h"
#import "LSSwitchScheduleCell.h"

@implementation LSSwitchScheduleView

@synthesize scheduleArray=_scheduleArray;
@synthesize selectIndex=_selectIndex;
@synthesize delegate=_delegate;

#pragma mark- 生命周期
- (void)dealloc
{
    self.scheduleArray=nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _blurView=[[FXBlurView alloc] initWithFrame:CGRectZero];
        _blurView.dynamic = NO;
        _blurView.tintColor = [UIColor colorWithRed:0 green:0.5 blue:0.5 alpha:1];
        [_blurView.layer displayIfNeeded]; //force immediate redraw
        _blurView.contentMode = UIViewContentModeBottom;
        [self addSubview:_blurView];
        [_blurView release];
        
        _scheduleTableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _scheduleTableView.clipsToBounds=YES;
        _scheduleTableView.bounces=NO;
        _scheduleTableView.showsVerticalScrollIndicator=NO;
        _scheduleTableView.showsHorizontalScrollIndicator=NO;
        _scheduleTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _scheduleTableView.delegate=self;
        _scheduleTableView.dataSource=self;
        [self addSubview:_scheduleTableView];
        [_scheduleTableView release];
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

- (void)layoutSubviews
{
    [super layoutSubviews];
    if(_scheduleArray.count>=3)
    {
        _scheduleTableView.frame=CGRectMake(0.f, 0.f, self.width, 60.f*3);
        _scheduleTableView.showsVerticalScrollIndicator=YES;
    }
    else
    {
        _scheduleTableView.frame=CGRectMake(0.f, 0.f, self.width, 60.f*_scheduleArray.count);
        _scheduleTableView.showsVerticalScrollIndicator=NO;
    }
    _blurView.frame=CGRectMake(0.f, 0.f, self.width, self.height);
}


#pragma mark- UITableView的委托方法
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.f;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    _switchSectionHeader=[[[LSSwitchSectionHeader alloc] initWithFrame:CGRectZero] autorelease];
    _switchSectionHeader.schedule=[_scheduleArray objectAtIndex:_selectIndex];
    _switchSectionHeader.delegate=self;
    return _switchSectionHeader;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _scheduleArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSSwitchScheduleCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSSwitchScheduleCell"];
    if(cell==nil)
    {
        cell=[[[LSSwitchScheduleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSSwitchScheduleCell"] autorelease];
    }
    cell.isInitial=(indexPath.row==_selectIndex);
    cell.schedule=[_scheduleArray objectAtIndex:indexPath.row];
    [cell setNeedsDisplay];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectIndex=indexPath.row;
    
    for(LSSwitchScheduleCell* cell in tableView.visibleCells)
    {
        cell.isInitial=NO;
        [cell setNeedsDisplay];
    }
    
    LSSwitchScheduleCell* cell=(LSSwitchScheduleCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.isInitial=YES;
    [cell setNeedsDisplay];
    
    [_delegate LSSwitchScheduleView:self didSelectRowAtIndexPath:indexPath.row];
    
    _switchSectionHeader.isSpread=NO;
    _switchSectionHeader.schedule=[_scheduleArray objectAtIndex:_selectIndex];
    [_switchSectionHeader setNeedsLayout];
    
    self.bounds=CGRectMake(0.f, 0.f, self.width, 44.f);
}


#pragma mark- LSSwitchSectionHeader的委托方法
- (void)LSSwitchSectionHeader:(LSSwitchSectionHeader *)switchSectionHeader isSpread:(BOOL)isSpread
{
    if(isSpread)
    {
        self.bounds=CGRectMake(0.f, 0.f, self.width, 480.f-20.f-44.f);
    }
    else
    {
        self.bounds=CGRectMake(0.f, 0.f, self.width, 44.f);
    }
}

@end
