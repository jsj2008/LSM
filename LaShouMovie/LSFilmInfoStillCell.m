//
//  LSFilmInfoStillCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-5.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSFilmInfoStillCell.h"
#import "LSFilmStillCell.h"

#define gapL 20.f

@implementation LSFilmInfoStillCell

@synthesize stillArray=_stillArray;
@synthesize delegate=_delegate;

#pragma mark- 生命周期
- (void)dealloc
{
    self.stillArray=nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.clipsToBounds = YES;
        
        _stillTableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _stillTableView.backgroundColor=[UIColor clearColor];
        _stillTableView.backgroundView=nil;
        _stillTableView.delegate=self;
        _stillTableView.dataSource=self;
        _stillTableView.pagingEnabled=YES;
        _stillTableView.showsVerticalScrollIndicator=NO;
        _stillTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _stillTableView.transform=CGAffineTransformMakeRotation(-M_PI/2);//将视图旋转90
        [self addSubview:_stillTableView];
        [_stillTableView release];
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
    _stillTableView.center=CGPointMake(self.width/2, self.height/2+15.f);
    _stillTableView.bounds=CGRectMake(0, 0, 70.f, self.width-40.f);
    [_stillTableView reloadData];
}

- (void)drawRect:(CGRect)rect
{
    [self drawRoundRectangleInRect:CGRectMake(10.f, 10.f, (rect.size.width - 20.f), (rect.size.height - 20.f)) topRadius:3.f bottomRadius:3.f isBottomLine:YES fillColor:LSColorBgWhiteColor strokeColor:LSColorLineLightGrayColor borderWidth:0.5];
 
    //绘制标题
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextRef, LSColorBlackRedColor.CGColor);
    NSString* text=@"影片剧照";
    CGSize size=[text sizeWithFont:LSFont16];
    [text drawInRect:CGRectMake(gapL, 15.f, size.width, size.height) withFont:LSFont16];
}


#pragma mark- UITableView的委托方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _stillArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSFilmStillCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSFilmStillCell"];
    if(cell==nil)
    {
        cell=[[[LSFilmStillCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSFilmStillCell"] autorelease];
        cell.contentView.transform=CGAffineTransformMakeRotation(M_PI/2);//将视图旋转90
    }
    cell.imageView.image=LSPlaceholderImage;
    
    if(!tableView.isDragging && !tableView.isDecelerating)
    {
        [cell.imageView setImageWithURL:[NSURL URLWithString:[_stillArray objectAtIndex:indexPath.row]] placeholderImage:LSPlaceholderImage];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_delegate!=nil)
    {
        [_delegate LSFilmInfoStillCell:self didSelectRowAtIndexPath:indexPath.row];
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

#pragma mark 肥皂滑代码实现
- (void)soapSmooth
{
    NSArray* cellArray=[_stillTableView visibleCells];
    for(LSFilmStillCell* cell in cellArray)
    {
        NSIndexPath* indexPath=[_stillTableView indexPathForCell:cell];
        [cell.imageView setImageWithURL:[NSURL URLWithString:[_stillArray objectAtIndex:indexPath.row]] placeholderImage:LSPlaceholderImage];
    }
}

@end
