//
//  LSCinema.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-10.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSCinema.h"
#import "LSGroup.h"

@implementation LSCinema

@synthesize cinemaID=_cinemaID;//影院ID
@synthesize cinemaName=_cinemaName;//影院名称
@synthesize districtID=_districtID;//行政区ID
@synthesize districtName=_districtName;//行政区名称
@synthesize areaID=_areaID;//子区ID
@synthesize areaName=_areaName;//子区名称
@synthesize featuresID=_featuresID;
@synthesize latitude=_latitude;//纬度
@synthesize longitude=_longitude;//经度
@synthesize filmCount=_filmCount;//在线影片数
@synthesize todayScheduleCount=_todayScheduleCount;//今日排期数
@synthesize totalScheduleCount=_totalScheduleCount;//全部排期数
@synthesize phone=_phone;//电话
@synthesize address=_address;//地址
@synthesize imageURL=_imageURL;//图片路径
@synthesize buyType=_buyType;//购买状态 0只可以选座 1只可以团购 2即可选座也可团购 3不能选座也不能团购
@synthesize groupArray=_groupArray;//团购信息
@synthesize distance=_distance;//与用户当前距离

- (id)initWithDictionary:(NSDictionary*)safeDic
{
    self=[super init];
    if(self!=nil)
    {
        self.cinemaID=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"cinemaId"]];//影院ID
        self.cinemaName=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"cinemaName"]];//影院名称
        self.districtID=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"districtId"]];//行政区ID
        self.districtName=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"districtName"]];//行政区名称
        if([_districtName isEqualToString:@""] || [_districtName isEqualToString:LSNULL])
        {
            self.districtName=@"其他";
        }
        self.areaID=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"areaId"]];//子区ID
        self.areaName=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"areaName"]];//子区名称
        if([_areaName isEqualToString:@""] || [_areaName isEqualToString:LSNULL])
        {
            self.areaName=@"其他";
        }
        self.featuresID=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"featuresId"]];
        
        //获取经纬度，如果有谷歌坐标，那么使用谷歌坐标，否则使用百度坐标
        if([safeDic objectForKey:@"glatitude"]!=NULL && [safeDic objectForKey:@"glatitude"]!=[NSNull null] && ![[safeDic objectForKey:@"glatitude"] isEqual:LSNULL] && [[safeDic objectForKey:@"glatitude"] doubleValue]!=0.f)
        {
            self.latitude=[[safeDic objectForKey:@"glatitude"] doubleValue];//纬度
        }
        else
        {
            self.latitude=[[safeDic objectForKey:@"latitude"] doubleValue];//纬度
        }
        if([safeDic objectForKey:@"glongitude"]!=NULL && [safeDic objectForKey:@"glongitude"]!=[NSNull null] && ![[safeDic objectForKey:@"glongitude"] isEqual:LSNULL] && [[safeDic objectForKey:@"glongitude"] doubleValue]!=0.f)
        {
            self.longitude=[[safeDic objectForKey:@"glongitude"] doubleValue];//经度
        }
        else
        {
            self.longitude=[[safeDic objectForKey:@"longitude"] doubleValue];//经度
        }

        self.filmCount=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"numFilmOnLine"]];//在线影片数
        self.todayScheduleCount=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"restScheduleCount"]];//今日排期数
        self.totalScheduleCount=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"totalScheduleCount"]];//全部排期数
        self.phone=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"phone"]];//电话
        self.address=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"address"]];//地址
        self.imageURL=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"firstImg"]];//图片路径
        self.buyType=[[safeDic objectForKey:@"buyType"] intValue];//购买状态 0只可以选座 1只可以团购 2即可选座也可团购 3不能选座也不能团购
        
        if((_buyType==LSCinemaBuyTypeOnlyGroup || _buyType==LSCinemaBuyTypeSeatGroup) && [[safeDic objectForKey:@"groupBuy"] isKindOfClass:[NSArray class]])
        {
            NSMutableArray* groupMArray=[NSMutableArray arrayWithCapacity:0];
            
            NSArray* tmpArray=[safeDic objectForKey:@"groupBuy"];
            for (id object in tmpArray)
            {
                if([object isKindOfClass:[NSDictionary class]])
                {
                    LSGroup* group=[[LSGroup alloc] initWithDictionary:object];
                    [groupMArray addObject:group];
                    [group release];
                }
            }
            if(groupMArray.count>1)
            {
                //为模拟循环滚动
                [groupMArray addObject:[groupMArray objectAtIndex:0]];
            }

            self.groupArray=groupMArray;
        }
        
        if([safeDic objectForKey:@"distance"]!=NULL && [safeDic objectForKey:@"distance"]!=[NSNull null])
        {
            self.distance=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"distance"]];
        }
        else
        {
            self.distance=LSNULL;
        }
//        LSUser* user=[LSUser currentUser];
//        if(user.location!=nil)
//        {
//            self.distance=[LSTools distanceWithLongitude1:user.location.coordinate.longitude latitude1:user.location.coordinate.latitude longitude2:_longitude latitude2:_latitude];
//        }
//        else
//        {
//            self.distance=LSNULL;
//        }
    }
    return self;
}

- (void)dealloc
{
    self.cinemaID=nil;//影院ID
    self.cinemaName=nil;//影院名称
    self.districtID=nil;//行政区ID
    self.districtName=nil;//行政区名称
    self.areaID=nil;//子区ID
    self.areaName=nil;//子区名称
    self.featuresID=nil;
//    self.latitude=nil;//纬度
//    self.longitude=nil;//经度
    self.filmCount=nil;//在线影片数
    self.todayScheduleCount=nil;//今日排期数
    self.totalScheduleCount=nil;//全部排期数
    self.phone=nil;//电话
    self.address=nil;//地址
    self.imageURL=nil;//图片路径
    //self.buyType=nil;//购买状态 0只可以选座 1只可以团购 2即可选座也可团购 3不能选座也不能团购
    self.groupArray=nil;//团购信息
    self.distance=nil;
    [super dealloc];
}

- (BOOL)distanceSort:(LSCinema*)cinema
{
    if([self.distance isEqualToString:LSNULL] || [cinema.distance isEqualToString:LSNULL])
    {
        return YES;
    }
    else
    {
        if([self.distance rangeOfString:@"km"].location==NSNotFound || [cinema.distance rangeOfString:@"km"].location==NSNotFound)
        {
            return YES;
        }
        else
        {
            return  [[self.distance substringToIndex:self.distance.length-2] floatValue]>[[cinema.distance substringToIndex:cinema.distance.length-2] floatValue];
        }
    }
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_cinemaID forKey:@"cinemaID"];
    [aCoder encodeObject:_cinemaName forKey:@"cinemaName"];
    [aCoder encodeObject:_districtID forKey:@"districtID"];
    [aCoder encodeObject:_districtName forKey:@"districtName"];
    [aCoder encodeObject:_areaID forKey:@"areaID"];
    [aCoder encodeObject:_areaName forKey:@"areaName"];
    [aCoder encodeObject:_featuresID forKey:@"featuresID"];
    [aCoder encodeDouble:_latitude forKey:@"latitude"];
    [aCoder encodeDouble:_longitude forKey:@"longitude"];
    [aCoder encodeObject:_filmCount forKey:@"filmCount"];
    [aCoder encodeObject:_todayScheduleCount forKey:@"todayScheduleCount"];
    [aCoder encodeObject:_totalScheduleCount forKey:@"totalScheduleCount"];
    [aCoder encodeObject:_phone forKey:@"phone"];
    [aCoder encodeObject:_address forKey:@"address"];
    [aCoder encodeObject:_imageURL forKey:@"imageURL"];
    [aCoder encodeInt:_buyType forKey:@"buyType"];
    [aCoder encodeObject:_groupArray forKey:@"groupArray"];
    [aCoder encodeObject:_distance forKey:@"distance"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self.cinemaID=[decoder decodeObjectForKey:@"cinemaID"];//影院ID
    self.cinemaName=[decoder decodeObjectForKey:@"cinemaName"];//影院名称
    self.districtID=[decoder decodeObjectForKey:@"districtID"];//行政区ID
    self.districtName=[decoder decodeObjectForKey:@"districtName"];//行政区名称
    self.areaID=[decoder decodeObjectForKey:@"areaID"];//子区ID
    self.areaName=[decoder decodeObjectForKey:@"areaName"];//子区名称
    self.featuresID=[decoder decodeObjectForKey:@"featuresID"];
    self.latitude=[decoder decodeDoubleForKey:@"latitude"];//纬度
    self.longitude=[decoder decodeDoubleForKey:@"longitude"];//经度
    self.filmCount=[decoder decodeObjectForKey:@"filmCount"];//在线影片数
    self.todayScheduleCount=[decoder decodeObjectForKey:@"todayScheduleCount"];//今日排期数
    self.totalScheduleCount=[decoder decodeObjectForKey:@"totalScheduleCount"];//全部排期数
    self.phone=[decoder decodeObjectForKey:@"phone"];//电话
    self.address=[decoder decodeObjectForKey:@"address"];//地址
    self.imageURL=[decoder decodeObjectForKey:@"imageURL"];//图片路径
    self.buyType=[decoder decodeIntForKey:@"buyType"];//购买状态 0只可以选座 1只可以团购 2即可选座也可团购 3不能选座也不能团购
    self.groupArray=[decoder decodeObjectForKey:@"groupArray"];//团购信息
    self.distance=[decoder decodeObjectForKey:@"distance"];//距离
    return self;
}

@end
