//
//  LSDistrictSelectorView.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-20.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSDistrictSelectorView.h"

@implementation LSDistrictSelectorView

@synthesize positionArray=_positionArray;
@synthesize selectIndex=_selectIndex;
@synthesize contentFrame=_contentFrame;
@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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

#pragma mark- 生命周期
- (void)dealloc
{
    self.positionArray=nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = LSRGBA(0, 0, 0, 0.6);
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        _tableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        //_tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.backgroundColor=[UIColor clearColor];
        _tableView.backgroundView=nil;
        _tableView.showsVerticalScrollIndicator=NO;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.delegate=self;
        _tableView.dataSource=self;
        [self addSubview:_tableView];
        [_tableView release];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_selectorViewType == LSSelectorViewTypeSection)
    {
        _tableView.scrollEnabled=NO;
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    if (_selectorViewType == LSSelectorViewTypeLocation)
    {
        [[UIImage stretchableImageWithImage:[UIImage lsImageNamed:@"cinemas_sections_bg.png"] top:8 left:8 bottom:8 right:8]  drawInRect:CGRectMake(_contentFrame.origin.x-5, _contentFrame.origin.y-5, _contentFrame.size.width+10, _contentFrame.size.height+10)];
    }
    else if (_selectorViewType == LSSelectorViewTypeSection)
    {
        [[UIImage stretchableImageWithImage:[UIImage lsImageNamed:@"sections_bg.png"] top:8 left:8 bottom:8 right:8] drawInRect:CGRectMake(_contentFrame.origin.x-5, _contentFrame.origin.y-5, _contentFrame.size.width+10, _contentFrame.size.height+10)];
    }
}


#pragma mark- UITableView的委托方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _positionArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_selectorViewType==LSSelectorViewTypeLocation)
    {
        return 30.f;
    }
    else
    {
        return 44.f;
    }
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSSelectorCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSSelectorCell"];
    if(cell==nil)
    {
        cell=[[[LSSelectorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSSelectorCell"] autorelease];
    }
    cell.type=_selectorViewType;
    cell.isInitial=(indexPath.row==_selectIndex);
    cell.infoLabel.text=[_positionArray objectAtIndex:indexPath.row];
    [cell setNeedsLayout];
    [cell setNeedsDisplay];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([_delegate respondsToSelector:@selector(LSSelectorView: didSelectRowAtIndexPath:)])
    {
        [_delegate LSSelectorView:self didSelectRowAtIndexPath:indexPath.row];
    }
    
    [self removeFromSuperview];
}


#pragma mark- 重载触摸方法
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self removeFromSuperview];
}

@end
