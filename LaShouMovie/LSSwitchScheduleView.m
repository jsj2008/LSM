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

@synthesize tableView=_tableView;
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
        self.backgroundColor=[UIColor clearColor];
        
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
        _tableView.backgroundColor=[UIColor clearColor];
        _tableView.clipsToBounds=YES;
        _tableView.bounces=NO;
        _tableView.showsVerticalScrollIndicator=NO;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.delegate=self;
        _tableView.dataSource=self;
        [self addSubview:_tableView];
        [_tableView release];
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


#pragma mark- UITableView的委托方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.f;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    _switchSectionHeader=[[[LSSwitchSectionHeader alloc] initWithFrame:CGRectZero] autorelease];
    _switchSectionHeader.delegate=self;
    return _switchSectionHeader;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _scheduleArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
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
    
    if([_delegate respondsToSelector:@selector(LSSwitchScheduleView: didSelectRowAtIndexPath:)])
    {
        [_delegate LSSwitchScheduleView:self didSelectRowAtIndexPath:indexPath.row];
    }
    
    _switchSectionHeader.isSpread=NO;
    [_switchSectionHeader setNeedsLayout];
    if([_delegate respondsToSelector:@selector(LSSwitchScheduleView: isSpread:)])
    {
        [_delegate LSSwitchScheduleView:self isSpread:NO];
    }
}


#pragma mark- LSSwitchSectionHeader的委托方法
- (void)LSSwitchSectionHeader:(LSSwitchSectionHeader *)switchSectionHeader isSpread:(BOOL)isSpread
{
    if([_delegate respondsToSelector:@selector(LSSwitchScheduleView: isSpread:)])
    {
        [_delegate LSSwitchScheduleView:self isSpread:isSpread];
    }
}

@end
