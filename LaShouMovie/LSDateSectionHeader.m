//
//  LSDateSectionHeader.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-12.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSDateSectionHeader.h"
#import "LSDateCell.h"
#import "LSScheduleDictionary.h"

@implementation LSDateSectionHeader

@synthesize title=_title;
@synthesize today=_today;
@synthesize date=_date;
@synthesize scheduleDicArray=_scheduleDicArray;
@synthesize delegate=_delegate;

#pragma mark- 属性方法

- (void)makeTimeArray:(NSString*)day
{
    if(!day)
        return;
    
    //today = "2013-09-12";
    NSDateFormatter* dateFormatter=[[NSDateFormatter alloc] init];
    dateFormatter.dateFormat=@"yyyy-MM-dd";
    NSDate* today=[dateFormatter dateFromString:day];
    [dateFormatter release];

    NSCalendar* calendar=[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents* dateComponents=[[NSDateComponents alloc] init];
    _dateMArray=[[NSMutableArray alloc] initWithCapacity:0];
    _dateTagMArray=[[NSMutableArray alloc] initWithCapacity:0];
    
    for(LSScheduleDictionary* dic in _scheduleDicArray)
    {
        [_dateTagMArray addObject:[NSNumber numberWithInt:dic.scheduleDate]];
        
        [dateComponents setDay:dic.scheduleDate];
        NSDate* day = [calendar dateByAddingComponents:dateComponents toDate:today options:0];
        
        if(dic.scheduleDate==LSScheduleDateToday)
        {
            NSString* todayStr=[day stringValueByFormatter:@"MM月dd 今天"];
            [_dateMArray addObject:todayStr];
        }
        else if(dic.scheduleDate==LSScheduleDateTomorrow)
        {
            NSString* tomorrowStr=[day stringValueByFormatter:@"MM月dd 明天"];
            [_dateMArray addObject:tomorrowStr];
        }
        else if(dic.scheduleDate==LSScheduleDateTheDayAfterTomorrow)
        {
            NSString* theDayAfterTomorrowStr=[day stringValueByFormatter:@"MM月dd 后天"];
            [_dateMArray addObject:theDayAfterTomorrowStr];
        }
        else
        {
            NSString* dayStr=[day stringValueByFormatter:@"MM月dd日"];
            [_dateMArray addObject:dayStr];
        }
    }
    
    [dateComponents release];
    [calendar release];

    [_tableView reloadData];
    for(int i=0;i<_dateTagMArray.count;i++)
    {
        int j=[[_dateTagMArray objectAtIndex:i] intValue];
        if(j==_date)
        {
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            break;
        }
    }
}


#pragma mark- 生命周期

- (void)dealloc
{
    LSRELEASE(_dateMArray)
    LSRELEASE(_dateTagMArray)
    self.title=nil;
    self.today=nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor whiteColor];
        
        _tableView=[[UITableView alloc] initWithFrame:CGRectZero];
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
    _tableView.center=CGPointMake(self.width/2, _title.length>0?(41+44/2):(44/2));
    _tableView.bounds=CGRectMake(0.f, 0.f, 44.f, 300.f);
    _tableView.hidden=(_today==nil);
    
    LSRELEASE(_dateMArray)
    LSRELEASE(_dateTagMArray)
    [self makeTimeArray:_today];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code 
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(contextRef, LSColorBlackRedColor.CGColor);
//    NSString* title = nil;
//    if (_title.length==0)
//    {
//        title = @"电影排期";
//    }
//    else
//    {
//        if (_title.length>12)
//        {
//            title=[_title substringFromIndex:12];
//        }
//        else
//        {
//            title=_title;
//        }
//    }

//    CGSize size=[title sizeWithFont:LSFont18];
//    [title drawInRect:CGRectMake(10.f, 10.f, rect.size.width, size.height) withFont:LSFont18 lineBreakMode:NSLineBreakByClipping];
    
    if(_title.length>0)
    {
        CGSize size=[_title sizeWithFont:LSFont18];
        [_title drawInRect:CGRectMake(10.f, 10.f, rect.size.width, size.height) withFont:LSFont18];
    }
}


#pragma mark- UITableView委托方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dateMArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_dateMArray.count>3)
    {
        return 90.f;
    }
    else
    {
        return 300.f/_dateMArray.count;
    }
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSDateCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSDateCell"];
    if(cell==nil)
    {
        cell=[[[LSDateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSDateCell"] autorelease];
        cell.tag=[[_dateTagMArray objectAtIndex:indexPath.row] intValue];//设置tag值使回调不再依赖于indexPath
        cell.transform=CGAffineTransformMakeRotation(M_PI/2);//将视图旋转90
    }
    cell.time=[_dateMArray objectAtIndex:indexPath.row];
    if(cell.tag==_date)
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
    UITableViewCell* cell=[tableView cellForRowAtIndexPath:indexPath];
    if(cell.tag!=_date)
    {
        _date=cell.tag;
        
        for(LSDateCell* cell in tableView.visibleCells)
        {
            cell.isSelect=NO;
            [cell setNeedsDisplay];
        }
        
        LSDateCell* cell=(LSDateCell*)[tableView cellForRowAtIndexPath:indexPath];
        cell.isSelect=YES;
        [cell setNeedsDisplay];
        
        if([_delegate respondsToSelector:@selector(LSDateSectionHeader: didSelectRowAtIndexPath:)])
        {
            [_delegate LSDateSectionHeader:self didSelectRowAtIndexPath:_date];
        }
    }
}

@end
