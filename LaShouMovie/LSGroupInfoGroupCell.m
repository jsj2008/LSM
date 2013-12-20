//
//  LSGroupInfoGroupCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-11.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSGroupInfoGroupCell.h"
#import "LSGroupInfoCell.h"
#import "LSGroup.h"

@implementation LSGroupInfoGroupCell

@synthesize groupArray=_groupArray;
@synthesize isOpen=_isOpen;
@synthesize delegate=_delegate;

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
        self.backgroundView=nil;
        self.backgroundColor=[UIColor clearColor];
        self.clipsToBounds=YES;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        _groupTableView=[[UITableView alloc] initWithFrame:CGRectZero];
        _groupTableView.backgroundColor=[UIColor clearColor];
        _groupTableView.backgroundView=nil;
        _groupTableView.delegate=self;
        _groupTableView.dataSource=self;
        _groupTableView.scrollEnabled=NO;
        _groupTableView.showsVerticalScrollIndicator=NO;
        _groupTableView.bounces=NO; 
        _groupTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self addSubview:_groupTableView];
        [_groupTableView release];
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
    _groupTableView.center=CGPointMake(self.width/2, self.height/2);
    _groupTableView.bounds=CGRectMake(0, 0, self.width, self.height);
    LSLOG(@"%f %f",_groupTableView.width,_groupTableView.height);
    [_groupTableView reloadData];
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 54.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    LSGroupInfoSectionHeader* groupInfoSectionHeader=[[[LSGroupInfoSectionHeader alloc] init] autorelease];
    groupInfoSectionHeader.isOpen=_isOpen;
    groupInfoSectionHeader.delegate=self;
    return groupInfoSectionHeader;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _groupArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSGroupInfoCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSGroupInfoCell"];
    if(cell==nil)
    {
        cell=[[[LSGroupInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSGroupInfoCell"] autorelease];
    }
    LSGroup* group=[_groupArray objectAtIndex:indexPath.row];
    cell.text=group.groupTitle;
    
    if(indexPath.row!=_groupArray.count-1)//最后一个
    {
        cell.bottomRadius=0.f;
    }
    else
    {
        cell.bottomRadius=3.f;
    }
    [cell setNeedsDisplay];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([_delegate respondsToSelector:@selector(LSGroupInfoGroupCell: didSelectRowAtIndexPath:)])
    {
        [_delegate LSGroupInfoGroupCell:self didSelectRowAtIndexPath:indexPath.row];
    }
}

#pragma mark- LSGroupInfoSectionHeader的委托
- (void)LSGroupInfoSectionHeader:(LSGroupInfoSectionHeader *)groupInfoSectionHeader isOpen:(BOOL)isOpen
{
    _isOpen=isOpen;
    if([_delegate respondsToSelector:@selector(LSGroupInfoGroupCell: isOpen:)])
    {
        [_delegate LSGroupInfoGroupCell:self isOpen:_isOpen];
    }
}

@end
