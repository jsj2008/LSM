//
//  LSSection.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-16.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSSection.h"
#import "LSSeat.h"

@implementation LSSection

@synthesize apiSource=_apiSource;//票务供应商
@synthesize sectionID=_sectionID;//片区编号
@synthesize sectionName=_sectionName;//片区名称
@synthesize maxTicketNumber=_maxTicketNumber;//最多购票数

@synthesize seatArray=_seatArray;//座位数组
@synthesize seatDictionary=_seatDictionary;//座位字典

//本地生成
@synthesize columnNumber=_columnNumber;
@synthesize rowNumber=_rowNumber;
@synthesize rowIDArray=_rowIDArray;

- (id)copyWithZone:(NSZone *)zone
{
    LSSection* section=[[LSSection allocWithZone:zone] init];
    section.apiSource=_apiSource;//票务供应商
    section.sectionID=_sectionID;//片区编号
    section.sectionName=_sectionName;//片区名称
    section.maxTicketNumber=_maxTicketNumber;//最多购票数
    
    section.seatArray=[[[NSArray alloc] initWithArray:_seatArray copyItems:YES] autorelease];//座位数组
    
    //本地生成
    section.columnNumber=_columnNumber;
    section.rowNumber=_rowNumber;
    section.rowIDArray=_rowIDArray;
    
    return section;
}

- (id)initWithDictionary:(NSDictionary *)safeDic
{
    self=[super init];
    if(self!=nil)
    {
        self.apiSource=[[safeDic objectForKey:@"api_source"] intValue];
        self.sectionID=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"sectionId"]];
        self.sectionName=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"sectionName"]];
        self.maxTicketNumber=[[safeDic objectForKey:@"maxTicketNum"] intValue];
        
        if([[safeDic objectForKey:@"seats"] isKindOfClass:[NSArray class]])
        {
            //记录屏幕行列的最大值
            CGFloat columns=0.f;
            int rows=0;
            
            //记录屏幕行列的最小值，以下两个参数不对外(因为没有意义)，只用于开发调试查看
            CGFloat minColumns=MAXFLOAT;
            int minRows=INT_MAX;
            
            NSArray* tmpArray=[safeDic objectForKey:@"seats"];
            
            NSMutableArray* seatMArray=[NSMutableArray arrayWithCapacity:0];
            //NSMutableDictionary* seatMDictionary=[NSMutableDictionary dictionaryWithCapacity:0];
            
            //realRowIDArray是影院提供的真实行号，可能是1、2、3，也可能是A、B、C
            NSMutableArray* realRowIDArray=[NSMutableArray arrayWithCapacity:0];
            //rowIDArray用于收集所有的屏幕行号
            NSMutableArray* rowIDArray=[NSMutableArray arrayWithCapacity:0];
            
            for(NSDictionary* dic in tmpArray)
            {
                LSSeat* seat=[[LSSeat alloc] initWithDictionary:dic];
                [seatMArray addObject:seat];
                [seat release];
                
                //////////
                //if([seatMDictionary objectForKey:[NSNumber numberWithInt:seat.rowID]]==NULL)
                //{
                    //NSMutableDictionary* rowSeatMDictionary=[NSMutableDictionary dictionaryWithCapacity:0];
                    //[seatMDictionary setObject:rowSeatMDictionary forKey:[NSNumber numberWithInt:seat.rowID]];
                //}
                
                //NSMutableDictionary* rowSeatMDictionary=[seatMDictionary objectForKey:[NSNumber numberWithInt:seat.rowID]];
                //[rowSeatMDictionary setObject:seat forKey:[NSNumber numberWithFloat:seat.columnID]];
                //////////
                
                //寻找屏幕行列坐标的最大值，就可以判定到底划分多少行多少列
                if(seat.columnID>columns)
                {
                    columns=seat.columnID;
                }
                if(seat.rowID>rows)
                {
                    rows=seat.rowID;
                }
                
                //寻找屏幕行列坐标的最小值，就可以确定从第几行第几列开始显示
                if(seat.columnID<minColumns)
                {
                    minColumns=seat.columnID;
                }
                if(seat.rowID<minRows)
                {
                    minRows=seat.rowID;
                }
                
                if(![rowIDArray containsObject:[NSNumber numberWithFloat:seat.rowID]])
                {
                    [rowIDArray addObject:[NSNumber numberWithFloat:seat.rowID]];
                    [realRowIDArray addObject:seat.realRowID];
                }
            }
            self.seatArray=seatMArray;
            //self.seatDictionary=seatMDictionary;
            
            //LSLOG(@"最大列数%f     最大行数%d     最小列数%f     最小行数%d",columns,rows,minColumns,minRows);
            
            self.columnNumber=columns;
            self.rowNumber=rows;
            
            //以下算法非常重要
            //确保在正确的位置插入空行
            [rowIDArray sortUsingSelector:@selector(compare:)];
            for(int i=0;i<rowIDArray.count;i++)
            {
                if([[rowIDArray objectAtIndex:i] intValue]>i+1)
                {
                    [rowIDArray insertObject:@"space" atIndex:i];
                    [realRowIDArray insertObject:@"space" atIndex:i];
                }
            }
            
            self.rowIDArray=realRowIDArray;
        }
    }
    return self;
}

- (void)makeSeatDictionary
{
    NSMutableDictionary* seatMDictionary=[NSMutableDictionary dictionaryWithCapacity:0];
    for(LSSeat* seat in _seatArray)
    {
        if([seatMDictionary objectForKey:[NSNumber numberWithInt:seat.rowID]]==NULL)
        {
            NSMutableDictionary* rowSeatMDictionary=[NSMutableDictionary dictionaryWithCapacity:0];
            [seatMDictionary setObject:rowSeatMDictionary forKey:[NSNumber numberWithInt:seat.rowID]];
        }
        
        NSMutableDictionary* rowSeatMDictionary=[seatMDictionary objectForKey:[NSNumber numberWithInt:seat.rowID]];
        [rowSeatMDictionary setObject:seat forKey:[NSNumber numberWithFloat:seat.columnID]];
    }
    self.seatDictionary=seatMDictionary;
}

- (void)dealloc
{
//    self.apiSource=nil;
    self.sectionID=nil;
    self.sectionName=nil;
//    self.maxTicketNumber=nil;
    self.seatArray=nil;
    
//    self.columnNumber=nil;
//    self.rowNumber=nil;
    self.rowIDArray=nil;
    
    [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:_apiSource forKey:@"apiSource"];
    [aCoder encodeObject:_sectionID forKey:@"sectionID"];
    [aCoder encodeObject:_sectionName forKey:@"sectionName"];
    [aCoder encodeInt:_maxTicketNumber forKey:@"maxTicketNumber"];
    [aCoder encodeObject:_seatArray forKey:@"seatArray"];
    
    [aCoder encodeFloat:_columnNumber forKey:@"columnNumber"];
    [aCoder encodeFloat:_rowNumber forKey:@"rowNumber"];
    [aCoder encodeObject:_rowIDArray forKey:@"rowIDArray"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self.apiSource=[decoder decodeIntForKey:@"apiSource"];
    self.sectionID=[decoder decodeObjectForKey:@"sectionID"];
    self.sectionName=[decoder decodeObjectForKey:@"sectionName"];
    self.maxTicketNumber=[decoder decodeIntForKey:@"maxTicketNumber"];
    self.seatArray=[decoder decodeObjectForKey:@"seatArray"];
    
    self.columnNumber=[decoder decodeFloatForKey:@"columnNumber"];
    self.rowNumber=[decoder decodeFloatForKey:@"rowNumber"];
    self.rowIDArray=[decoder decodeObjectForKey:@"rowIDArray"];
    
    return self;
}

@end
