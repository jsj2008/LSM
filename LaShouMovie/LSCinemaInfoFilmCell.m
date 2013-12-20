//
//  LSCinemaInfoFilmCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-12.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSCinemaInfoFilmCell.h"
#import "LSCinemaFilmCell.h"

@implementation LSCinemaInfoFilmCell

@synthesize filmArray=_filmArray;
@synthesize animated=_animated;
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
        _filmTableView.backgroundColor=[UIColor clearColor];
        _filmTableView.backgroundView=nil;
        _filmTableView.delegate=self;
        _filmTableView.dataSource=self;
        _filmTableView.showsVerticalScrollIndicator=NO;
        _filmTableView.pagingEnabled=NO;
        _filmTableView.clipsToBounds=YES;
        _filmTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _filmTableView.transform=CGAffineTransformMakeRotation(-M_PI/2);//将视图旋转90
        [self.contentView addSubview:_filmTableView];
        [_filmTableView release];
        
        _filmInfoView=[[LSFilmInfoView alloc] initWithFrame:CGRectZero];
        _filmInfoView.delegate=self;
        [self.contentView addSubview:_filmInfoView];
        [_filmInfoView release];
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
    [[UIImage lsImageNamed:@"cinema_films_bg.png"] drawAsPatternInRect:CGRectMake(0, 0, rect.size.width, rect.size.height)];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _filmTableView.center=CGPointMake(self.width/2, self.height/2-46/2-5);
    _filmTableView.bounds=CGRectMake(0, 0, self.height-46-20, self.width-30);
    [_filmTableView reloadData];
    
    _filmInfoView.frame=CGRectMake(10, 105, self.width-20, 46);

    if(_lastIndex==0)
    {
        _animated=NO;
        [self howToScroll];
    }
    else
    {
        NSIndexPath* indexPath=[NSIndexPath indexPathForRow:_lastIndex inSection:0];
        [_filmTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }
}

#pragma mark- LSFilmInfoView的委托方法
- (void)LSFilmInfoView:(LSFilmInfoView *)filmInfoView didClickForFilm:(LSFilm *)film
{
    if([_delegate respondsToSelector:@selector(LSCinemaInfoGroupCell: didSelectRowAtIndexPath:)])
    {
        [_delegate LSCinemaInfoFilmCell:self didSelectRowAtIndexPath:[_filmArray indexOfObject:film]];
    }
}

#pragma mark- UITableView的委托方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _filmArray.count+4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row<=1 || indexPath.row>=_filmArray.count+2)
    {
        return 70;
    }
    return 70;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row<=1 || indexPath.row>=_filmArray.count+2)
    {
        UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if(cell==nil)
        {
            cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"] autorelease];
            cell.contentView.transform=CGAffineTransformMakeRotation(M_PI/2);//将视图旋转90
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor=[UIColor clearColor];
            cell.backgroundColor=[UIColor clearColor];
        }
        return cell;
    }
    
    LSCinemaFilmCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSCinemaFilmCell"];
    if(cell==nil)
    {
        cell=[[[LSCinemaFilmCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSCinemaFilmCell"] autorelease];
        cell.contentView.transform=CGAffineTransformMakeRotation(M_PI/2);//将视图旋转90
    }
    cell.filmImageView.image=LSPlaceholderImage;
    
    if(!tableView.isDragging && !tableView.isDecelerating)
    {
        LSFilm* film=[_filmArray objectAtIndex:indexPath.row-2];
//        LSFilm* film=[_filmArray objectAtIndex:indexPath.row];
        [cell.filmImageView setImageWithURL:[NSURL URLWithString:film.imageURL] placeholderImage:LSPlaceholderImage];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row>1 && indexPath.row<_filmArray.count+2)
    {
        if(_lastIndex!=indexPath.row)
        {
            _lastIndex=indexPath.row;
            [self doScroll];
        }
        else
        {
            //如果用户重复点击
            if([_delegate respondsToSelector:@selector(LSCinemaInfoGroupCell: didSelectRowAtIndexPath:)])
            {
                [_delegate LSCinemaInfoFilmCell:self didSelectRowAtIndexPath:indexPath.row-2];
            }
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(!decelerate)//是否有减速,没有减速说明是匀速拖动
    {
        [self soapSmooth];
        
        [self howToScroll];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self soapSmooth];
    
    [self howToScroll];
}

#pragma mark- 计算偏移量
- (void)howToScroll
{
    if(_filmTableView.contentOffset.y>_lastContentoffsetY)//看后面的
    {
        if(_filmTableView.contentOffset.y-_lastContentoffsetY>=35 && _filmTableView.contentOffset.y-_lastContentoffsetY<105)
        {
            _lastIndex++;
        }
        else
        {
            _lastIndex+=(int)((_filmTableView.contentOffset.y-_lastContentoffsetY)/70);
        }
    }
    else if(_filmTableView.contentOffset.y<_lastContentoffsetY)//看前面的
    {
        if(_lastContentoffsetY-_filmTableView.contentOffset.y>=35 && _lastContentoffsetY-_filmTableView.contentOffset.y<105)
        {
            _lastIndex--;
        }
        else
        {
            _lastIndex-=(int)((_lastContentoffsetY-_filmTableView.contentOffset.y)/70);
        }
    }
    
    if(_lastIndex<2)
    {
        _lastIndex=2;
    }
    else if(_lastIndex>_filmArray.count+1)
    {
        _lastIndex=_filmArray.count+1;
    }
    
    [self doScroll];
}
- (void)doScroll
{
    [_filmTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_lastIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:_animated];
    _animated=YES;
    
    if(_filmArray.count>0)
    {
        LSFilm* film=[_filmArray objectAtIndex:_lastIndex-2];
        _filmInfoView.film=film;
        [_filmInfoView setNeedsDisplay];
    }
    
    if(_lastContentoffsetY!=(_lastIndex-2+0.5)*70)
    {
        if([_delegate respondsToSelector:@selector(LSCinemaInfoFilmCell: didChangeRowToIndexPath:)])
        {
            [_delegate LSCinemaInfoFilmCell:self didChangeRowToIndexPath:_lastIndex-2];
        }
    }
    _lastContentoffsetY=(_lastIndex-2+0.5)*70;
}

#pragma mark 肥皂滑代码实现
- (void)soapSmooth
{
    NSArray* cellArray=[_filmTableView visibleCells];
    for(LSCinemaFilmCell* cell in cellArray)
    {
        NSIndexPath* indexPath=[_filmTableView indexPathForCell:cell];
        if(indexPath.row>1 && indexPath.row<_filmArray.count+2)
        {
            LSFilm* film=[_filmArray objectAtIndex:indexPath.row-2];
            [cell.filmImageView setImageWithURL:[NSURL URLWithString:film.imageURL] placeholderImage:LSPlaceholderImage];
        }
    }
}

@end
