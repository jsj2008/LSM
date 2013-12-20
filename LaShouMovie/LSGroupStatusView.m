//
//  LSGroupStatusView.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-9.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSGroupStatusView.h"
#import "LSGroupStatusCell.h"

@implementation LSGroupStatusView

@synthesize groupStatus=_groupStatus;
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
        
        _statusArray=[[NSArray alloc] initWithObjects:@"待付款",@"已付款", nil];
        
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

- (void)layoutSubviews
{
    [super layoutSubviews];
    if(_tableView !=nil)
        [_tableView reloadData];
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
    LSGroupStatusCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSGroupStatusCell"];
    if(cell==nil)
    {
        cell=[[[LSGroupStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSGroupStatusCell"] autorelease];
        cell.transform=CGAffineTransformMakeRotation(M_PI/2);//将视图旋转90
    }
    cell.status=[_statusArray objectAtIndex:indexPath.row];
    if(indexPath.row==_groupStatus)
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
    if(indexPath.row!=_groupStatus)
    {
        _groupStatus=indexPath.row;
        
        for(LSGroupStatusCell* cell in tableView.visibleCells)
        {
            cell.isSelect=NO;
            [cell setNeedsDisplay];
        }
        
        LSGroupStatusCell* cell=(LSGroupStatusCell*)[tableView cellForRowAtIndexPath:indexPath];
        cell.isSelect=YES;
        [cell setNeedsDisplay];
        
        if([_delegate respondsToSelector:@selector(LSGroupStatusView:didSelectRowAtIndexPath:)])
        {
            [_delegate LSGroupStatusView:self didSelectRowAtIndexPath:indexPath.row+1];
        }
    }
}

@end
