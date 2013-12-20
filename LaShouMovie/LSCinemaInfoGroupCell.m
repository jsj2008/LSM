//
//  LSCinemaInfoGroupCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-12.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSCinemaInfoGroupCell.h"
#import "LSGroup.h"
#import "LSCinemaGroupCell.h"

#define timerInterval 3.0

@implementation LSCinemaInfoGroupCell

@synthesize groupArray=_groupArray;
@synthesize delegate=_delegate;

#pragma mark- 生命周期
- (void)dealloc
{
    self.groupArray=nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.clipsToBounds = YES;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor=[UIColor clearColor];
        
        _groupTableView=[[UITableView alloc] init];
        _groupTableView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _groupTableView.backgroundColor=[UIColor clearColor];
        _groupTableView.backgroundView=nil;
        _groupTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _groupTableView.pagingEnabled=YES;
        _groupTableView.showsVerticalScrollIndicator=NO;
        _groupTableView.delegate=self;
        _groupTableView.dataSource=self;
        [self addSubview:_groupTableView];
        [_groupTableView release];
        
        _timer=[NSTimer scheduledTimerWithTimeInterval:timerInterval target:self selector:@selector(timerToScroll) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _groupTableView.frame=CGRectMake(0.f, 0.f, self.width, self.height);
    [_groupTableView reloadData];
}

#pragma mark- 定时滚动广告
- (void)timerToScroll
{
    if(_groupArray.count>1)
    {
        int currentRow=[_groupTableView indexPathForCell:_groupTableView.visibleCells.lastObject].row;
        [_groupTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:currentRow+1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}


#pragma mark- UITableView的委托方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _groupArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.height;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSCinemaGroupCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSCinemaGroupCell"];
    if(cell==nil)
    {
        cell=[[[LSCinemaGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSCinemaGroupCell"] autorelease];
    }
    LSGroup* group=[_groupArray objectAtIndex:indexPath.row];
    cell.group=group;
    [cell setNeedsDisplay];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([_delegate respondsToSelector:@selector(LSCinemaInfoGroupCell: didSelectRowAtIndexPath:)])
    {
        [_delegate LSCinemaInfoGroupCell:self didSelectRowAtIndexPath:indexPath.row];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y==scrollView.contentSize.height-self.height)
    {
        scrollView.contentOffset=CGPointMake(scrollView.contentOffset.x, 0);
    }
}

@end
