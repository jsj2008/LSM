//
//  LSCinemaInfoFilmCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-12.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSCinemaInfoFilmCell.h"
#import "LSCinemaFilmCell.h"
#import "LSFilm.h"

#define gap 10.f

@implementation LSCinemaInfoFilmCell

@synthesize filmArray=_filmArray;
@synthesize assignIndex=_assignIndex;
@synthesize delegate=_delegate;

#pragma mark- 生命周期

- (void)dealloc
{
    self.filmArray=nil;
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
        
        _filmTableView=[[UITableView alloc] initWithFrame:CGRectZero];
        _filmTableView.delegate=self;
        _filmTableView.dataSource=self;
        _filmTableView.showsVerticalScrollIndicator=NO;
        _filmTableView.pagingEnabled=YES;
        _filmTableView.clipsToBounds=YES;
        _filmTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _filmTableView.transform=CGAffineTransformMakeRotation(-M_PI/2);//将视图旋转90
        [self.contentView addSubview:_filmTableView];
        [_filmTableView release];
        
        UIImageView* iconImageView=[[UIImageView alloc] initWithFrame:CGRectZero];
        iconImageView.image=[UIImage lsImageNamed:@""];
        [self addSubview:iconImageView];
        [iconImageView release];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect
{
    CGFloat contentX = gap;
    
    LSFilm* film=[_filmArray objectAtIndex:_assignIndex];
    CGRect nameRect = [film.filmName boundingRectWithSize:CGSizeMake(150.f, INT32_MAX) options:NSStringDrawingTruncatesLastVisibleLine attributes:[LSAttribute attributeFont:LSFontFilmName] context:nil];
    [film.filmName drawInRect:CGRectMake(contentX, (rect.size.height-nameRect.size.height)/2, nameRect.size.width, nameRect.size.height) withAttributes:[LSAttribute attributeFont:LSFontFilmName lineBreakMode:NSLineBreakByTruncatingTail]];
    
    contentX+=(nameRect.size.width+5.f);
    [[NSString stringWithFormat:@"%@分",film.grade] drawInRect:CGRectMake(contentX, (rect.size.height-nameRect.size.height)/2, 50.f, nameRect.size.height) withAttributes:[LSAttribute attributeFont:LSFontFilmName color:LSColorTextRed]];
    
    [@"影片详情" drawInRect:CGRectMake(210.f, (rect.size.height-nameRect.size.height)/2, 80.f, nameRect.size.height) withAttributes:[LSAttribute attributeFont:LSFontFilmName color:LSColorTextGray]];
    
    [[UIImage lsImageNamed:@""] drawInRect:CGRectMake(290.f, (rect.size.height-20.f)/2, 20.f, 20.f)];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _filmTableView.center=CGPointMake(self.width/2, (self.height-44.f)/2);
    _filmTableView.bounds=CGRectMake(0, 0, self.height-44.f, self.width);
    [_filmTableView reloadData];
    
    [_filmTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_assignIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
}

#pragma mark- UITableView的委托方法
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (self.width-63.f)/2;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return (self.width-63.f)/2;
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _filmArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 63.f;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSCinemaFilmCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSCinemaFilmCell"];
    if(cell==nil)
    {
        cell=[[[LSCinemaFilmCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSCinemaFilmCell"] autorelease];
        cell.contentView.transform=CGAffineTransformMakeRotation(M_PI/2);//将视图旋转90
    }

    if(!tableView.isDragging && !tableView.isDecelerating)
    {
        LSFilm* film=[_filmArray objectAtIndex:indexPath.row];
        [cell.imageView setImageWithURL:[NSURL URLWithString:film.imageURL] placeholderImage:LSPlaceholderImage];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_assignIndex!=indexPath.row)
    {
        [_filmTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        
        _assignIndex=indexPath.row;
        [_delegate LSCinemaInfoFilmCell:self didChangeRowToIndexPath:_assignIndex];
        
        for(LSCinemaFilmCell* cell in tableView.visibleCells)
        {
            cell.isSelect=NO;
            [cell setNeedsDisplay];
        }
        
        LSCinemaFilmCell* cell=(LSCinemaFilmCell*)[tableView cellForRowAtIndexPath:indexPath];
        cell.isSelect=YES;
        [cell setNeedsDisplay];
    }
    else
    {
        //如果用户重复点击
        [_delegate LSCinemaInfoFilmCell:self didSelectRowAtIndexPath:indexPath.row];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(!decelerate)//是否有减速,没有减速说明是匀速拖动
    {
        [self soapSmooth];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self soapSmooth];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    _assignIndex=[_filmTableView indexPathForSelectedRow].row;
    [_delegate LSCinemaInfoFilmCell:self didChangeRowToIndexPath:_assignIndex];
    
    for(LSCinemaFilmCell* cell in _filmTableView.visibleCells)
    {
        cell.isSelect=NO;
        [cell setNeedsDisplay];
    }
    
    LSCinemaFilmCell* cell=(LSCinemaFilmCell*)[_filmTableView cellForRowAtIndexPath:[_filmTableView indexPathForSelectedRow]];
    cell.isSelect=YES;
    [cell setNeedsDisplay];
}

#pragma mark 肥皂滑代码实现
- (void)soapSmooth
{
    NSArray* cellArray=[_filmTableView visibleCells];
    for(LSCinemaFilmCell* cell in cellArray)
    {
        NSIndexPath* indexPath=[_filmTableView indexPathForCell:cell];
        LSFilm* film=[_filmArray objectAtIndex:indexPath.row];
        [cell.imageView setImageWithURL:[NSURL URLWithString:film.imageURL] placeholderImage:LSPlaceholderImage];
    }
}

@end
