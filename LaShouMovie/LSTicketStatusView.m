//
//  LSTicketStatusView.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-16.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTicketStatusView.h"
#import "LSTicketStatusCell.h"

@implementation LSTicketStatusView

@synthesize status=_status;
@synthesize delegate=_delegate;

#pragma mark- 生命周期

- (void)dealloc
{
    LSRELEASE(_statusArray)
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor whiteColor];
        
        _statusArray=[[NSArray alloc] initWithObjects:@"未使用", @"已使用", @"已过期", nil];
        
        _tableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.center=CGPointMake(320/2, 42/2);
        _tableView.bounds=CGRectMake(0, 0, 42, 320);
        _tableView.backgroundColor=[UIColor clearColor];
        _tableView.backgroundView=nil;
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.pagingEnabled=YES;
        _tableView.showsVerticalScrollIndicator=NO;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.transform=CGAffineTransformMakeRotation(-M_PI/2);//将视图旋转90
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

#pragma mark- UITableView委托方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _statusArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 320/_statusArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSTicketStatusCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSTicketStatusCell"];
    if(cell==nil)
    {
        cell=[[[LSTicketStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSTicketStatusCell"] autorelease];
        cell.transform=CGAffineTransformMakeRotation(M_PI/2);//将视图旋转90
    }
    cell.status=[_statusArray objectAtIndex:indexPath.row];
    if(indexPath.row==_status)
    {
        cell.isSelect=YES;
    }
    else
    {
        cell.isSelect=NO;
    }
    [cell setNeedsDisplay];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row!=_status)
    {
        _status=indexPath.row;
        
        for(LSTicketStatusCell* cell in tableView.visibleCells)
        {
            cell.isSelect=NO;
            [cell setNeedsDisplay];
        }
        
        LSTicketStatusCell* cell=(LSTicketStatusCell*)[tableView cellForRowAtIndexPath:indexPath];
        cell.isSelect=YES;
        [cell setNeedsDisplay];
        
        if([_delegate respondsToSelector:@selector(LSTicketStatusView:didSelectRowAtIndexPath:)])
        {
            [_delegate LSTicketStatusView:self didSelectRowAtIndexPath:indexPath.row+1];
        }
    }
}

@end
