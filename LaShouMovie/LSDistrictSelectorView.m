//
//  LSDistrictSelectorView.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-20.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSDistrictSelectorView.h"
#import "LSDistrictSelectorCell.h"

@implementation LSDistrictSelectorView

@synthesize districtDic=_districtDic;
@synthesize selectIndex=_selectIndex;
@synthesize contentSize=_contentSize;
@synthesize delegate=_delegate;

#pragma mark- 生命周期
- (void)dealloc
{
    LSRELEASE(_categoryArray)
    LSRELEASE(_districtArray)
    self.districtDic=nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = LSRGBA(0, 0, 0, 0.6);
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        _categoryArray=[[NSArray alloc] initWithObjects:@"地区分类", nil];

        _blurView=[[FXBlurView alloc] initWithFrame:CGRectZero];
        _blurView.dynamic = NO;
        _blurView.tintColor = [UIColor colorWithRed:0 green:0.5 blue:0.5 alpha:1];
        [_blurView.layer displayIfNeeded]; //force immediate redraw
        _blurView.contentMode = UIViewContentModeBottom;
        [self addSubview:_blurView];
        [_blurView release];
        
        _categoryTableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _categoryTableView.backgroundColor=LSColorBackgroundGray;
        _categoryTableView.showsHorizontalScrollIndicator=NO;
        _categoryTableView.delegate=self;
        _categoryTableView.dataSource=self;
        [self addSubview:_categoryTableView];
        [_categoryTableView release];
        
        _districtTableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _districtTableView.backgroundColor=LSColorBackgroundGray;
        _districtTableView.showsHorizontalScrollIndicator=NO;
        _districtTableView.delegate=self;
        _districtTableView.dataSource=self;
        [self addSubview:_districtTableView];
        [_districtTableView release];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _districtArray=[[NSArray alloc] initWithArray:[_districtDic allKeys]];
    
    _districtTableView.frame=CGRectMake(self.width/2, 0.f, self.width/2, _contentSize.height);
    _blurView.frame = CGRectMake(0.f, 0.f, self.width, self.height);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}


#pragma mark- UITableView的委托方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==_districtTableView)
    {
        return _districtArray.count+1;
    }
    else
    {
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==_districtTableView)
    {
        LSDistrictSelectorCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSDistrictSelectorCell"];
        if(cell==nil)
        {
            cell=[[[LSDistrictSelectorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSDistrictSelectorCell"] autorelease];
        }
        
        if(indexPath.row==0)
        {
            cell.textLabel.text=@"附近影院";
        }
        else
        {
            NSString* name=[_districtArray objectAtIndex:indexPath.row-1];
            cell.textLabel.text=[NSString stringWithFormat:@"%@(%@)",name,[_districtDic objectForKey:name]];
        }
        return cell;
    }
    else
    {
        LSDistrictSelectorCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSDistrictSelectorCell"];
        if(cell==nil)
        {
            cell=[[[LSDistrictSelectorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSDistrictSelectorCell"] autorelease];
        }
        cell.textLabel.text=[_categoryArray objectAtIndex:indexPath.row];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==_districtTableView)
    {
        [_delegate LSDistrictSelectorView:self didSelectDistrict:indexPath.row>0?[_districtArray objectAtIndex:indexPath.row-1]:nil];
        [self removeFromSuperview];
    }
}


#pragma mark- 重载触摸方法
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self removeFromSuperview];
}

@end
