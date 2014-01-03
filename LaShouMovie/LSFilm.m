//
//  LSFilm.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-2.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSFilm.h"

@implementation LSFilm

//第一部分请求返回的数据
@synthesize filmID=_filmID;//电影ID
@synthesize filmName=_filmName;//电影名称
@synthesize releaseDate=_releaseDate;//上映时间
@synthesize isPresell=_isPresell;//是否预售
@synthesize duration=_duration;//时长
@synthesize brief=_brief;//简介
@synthesize grade=_grade;//评分
@synthesize starCode=_starCode;//星级
@synthesize dimensional=_dimensional;//2D、3D
@synthesize isIMAX=_isIMAX;//iMax
@synthesize showCinemasCount=_showCinemasCount;//上映影院数
@synthesize showSchedulesCount=_showSchedulesCount;//上映排期数
@synthesize imageURL=_imageURL;//主图(小)
@synthesize posterURL=_posterURL;//海报(大)
@synthesize showStatus=_showStatus;//上映状态


//第二部分请求返回的数据
@synthesize actor=_actor;//主演
@synthesize country=_country;//国家
@synthesize description=_description;//描述
@synthesize director=_director;//导演
@synthesize filmType=_filmType;//类型
@synthesize bigStillPath=_bigStillPath;//剧照路径(大)
@synthesize stillPath=_stillPath;//剧照路径(小)
@synthesize stillArray=_stillsArray;//剧照
@synthesize isFetchDetail=_isFetchDetail; //是否已经请求详情

//附加的排期字典数组
@synthesize scheduleDicArray=_scheduleDicArray;//排期字典数组

- (id)initWithDictionary:(NSDictionary*)safeDic
{
    self=[super init];
    if(self!=nil)
    {   
//        NSMutableDictionary* safeDic=[NSMutableDictionary dictionaryWithDictionary:dic];
//        [safeDic makeSafe];
//        LSLOG(@"%@",safeDic);
        
        self.filmID=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"filmId"]];
        self.filmName=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"filmName"]];
        self.releaseDate=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"releaseDate"]];
        self.duration=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"duration"]];
        self.brief=[[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"brief"]] stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        
        self.grade=[NSString stringWithFormat:@"%@", [safeDic objectForKey:@"grade"]];
        self.starCode=[[safeDic objectForKey:@"starCode"] floatValue];
        self.dimensional=[[safeDic objectForKey:@"dimensional"] intValue];
        self.isIMAX=[[safeDic objectForKey:@"imax"] boolValue];
        self.showCinemasCount=[[safeDic objectForKey:@"showCinemasCount"] intValue];
        self.showSchedulesCount=[[safeDic objectForKey:@"showSchedulesCount"] intValue];
        self.imageURL=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"imageUrl"]];
        self.posterURL=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"posterUrl"]];
        self.showStatus=[[safeDic objectForKey:@"status"] intValue];
        
        if(self.releaseDate.length>0)
        {
            NSArray* array=[self.releaseDate componentsSeparatedByString:@"-"];
            NSDate* today=[NSDate date];
            NSArray* todayArray=[[today stringValueByFormatter:@"yyyy-MM-dd"] componentsSeparatedByString:@"-"];
            if([[array objectAtIndex:0] intValue]>[[todayArray objectAtIndex:0] intValue])
            {
                if(self.showSchedulesCount>0)
                {
                    self.isPresell=YES;
                }
            }
            else if([[array objectAtIndex:0] intValue]==[[todayArray objectAtIndex:0] intValue])
            {
                if([[array objectAtIndex:1] intValue]>[[todayArray objectAtIndex:1] intValue])
                {
                    if(self.showSchedulesCount>0)
                    {
                        self.isPresell=YES;
                    }
                }
                else if([[array objectAtIndex:1] intValue]==[[todayArray objectAtIndex:1] intValue])
                {
                    if([[array objectAtIndex:2] intValue]>[[todayArray objectAtIndex:2] intValue])
                    {
                        if(self.showSchedulesCount>0)
                        {
                            self.isPresell=YES;
                        }
                    }
                }
            }
        }
    }
    return self;
}

- (void)completePropertyWithDictionary:(NSDictionary*)safeDic
{
    //第二部分请求返回的数据
//    @synthesize actor=_actor;//主演
//    @synthesize country=_country;//国家
//    @synthesize description=_description;//描述
//    @synthesize director=_director;//导演
//    @synthesize filmType=_filmType;//类型
//    @synthesize bigStillPath=_bigStillPath;//剧照路径(大)
//    @synthesize stillPath=_stillPath;//剧照路径(小)
//    @synthesize stillsArray=_stillsArray;//剧照
//    @synthesize isFetchDetail=_isFetchDetail; //是否已经请求详情

//    NSMutableDictionary* safeDic=[NSMutableDictionary dictionaryWithDictionary:dic];
//    [safeDic makeSafe];
//    LSLOG(@"%@",safeDic);

    self.isFetchDetail=YES;
    self.actor=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"actor"]];
    self.country=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"country"]];
    
    NSMutableString* mString=[NSMutableString stringWithFormat:@"%@",[safeDic objectForKey:@"description"]];
    [mString replaceOccurrencesOfString:@"<br>" withString:@"\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, mString.length)];
    [mString replaceOccurrencesOfString:@"<br/>" withString:@"\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, mString.length)];
    self.description=mString;
    
    self.director=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"director"]];
    self.filmType=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"filmType"]];
    self.bigStillPath=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"bigStillPath"]];
    self.stillPath=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"stillPath"]];
    self.stillArray=[[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"stillList"]] componentsSeparatedByString:@";"];
}


- (void)dealloc
{
    self.filmID=nil;
    self.filmName=nil;
    self.releaseDate=nil;
//    self.isPresell=nil;
    self.duration=nil;
    self.brief=nil;
    self.grade=nil;
//    self.starCode=nil;
//    self.dimensional=nil;
//    self.imax=nil;
//    self.showCinemasCount=nil;
//    self.showSchedulesCount=nil;
    self.imageURL=nil;
    self.posterURL=nil;
//    self.showStatus=nil;
    
  
    
//    self.isFetchDetail=nil;    
    self.actor=nil;
    self.country=nil;
    self.description=nil;
    self.director=nil;
    self.filmType=nil;
    self.bigStillPath=nil;
    self.stillPath=nil;
    self.stillArray=nil;

    
    
    self.scheduleDicArray=nil;
    
    [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_filmID forKey:@"filmID"];
    [aCoder encodeObject:_filmName forKey:@"filmName"];
    [aCoder encodeObject:_releaseDate forKey:@"releaseDate"];
    [aCoder encodeBool:_isPresell forKey:@"isPresell"];
    [aCoder encodeObject:_duration forKey:@"duration"];
    [aCoder encodeObject:_brief forKey:@"brief"];
    [aCoder encodeObject:_grade forKey:@"grade"];
    [aCoder encodeFloat:_starCode forKey:@"starCode"];
    [aCoder encodeInt:_dimensional forKey:@"dimensional"];
    [aCoder encodeBool:_isIMAX forKey:@"isIMAX"];
    [aCoder encodeInt:_showCinemasCount forKey:@"showCinemasCount"];
    [aCoder encodeInt:_showSchedulesCount forKey:@"showSchedulesCount"];
    [aCoder encodeObject:_imageURL forKey:@"imageURL"];
    [aCoder encodeObject:_posterURL forKey:@"posterURL"];
    [aCoder encodeInt:_showStatus forKey:@"showStatus"];
    
    
    
    [aCoder encodeBool:_isFetchDetail forKey:@"isFetchDetail"];
    [aCoder encodeObject:_actor forKey:@"actor"];
    [aCoder encodeObject:_country forKey:@"country"];
    [aCoder encodeObject:_description forKey:@"description"];
    [aCoder encodeObject:_director forKey:@"director"];
    [aCoder encodeObject:_filmType forKey:@"filmType"];
    [aCoder encodeObject:_bigStillPath forKey:@"bigStillPath"];
    [aCoder encodeObject:_stillPath forKey:@"stillPath"];
    [aCoder encodeObject:_stillArray forKey:@"stillArray"];
    
    
    
    [aCoder encodeObject:_scheduleDicArray forKey:@"scheduleDicArray"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self.filmID=[decoder decodeObjectForKey:@"filmID"];
    self.filmName=[decoder decodeObjectForKey:@"filmName"];
    self.releaseDate=[decoder decodeObjectForKey:@"releaseDate"];
    self.isPresell=[decoder decodeBoolForKey:@"isPresell"];
    self.duration=[decoder decodeObjectForKey:@"duration"];
    self.brief=[decoder decodeObjectForKey:@"brief"];
    self.grade=[decoder decodeObjectForKey:@"grade"];
    self.starCode=[decoder decodeFloatForKey:@"starCode"];
    self.dimensional=[decoder decodeIntForKey:@"dimensional"];
    self.isIMAX=[decoder decodeBoolForKey:@"isIMAX"];
    self.showCinemasCount=[decoder decodeIntForKey:@"showCinemasCount"];
    self.showSchedulesCount=[decoder decodeIntForKey:@"showSchedulesCount"];
    self.imageURL=[decoder decodeObjectForKey:@"imageURL"];
    self.posterURL=[decoder decodeObjectForKey:@"posterURL"];
    self.showStatus=[decoder decodeIntForKey:@"showStatus"];
    
    
    
    self.isFetchDetail=[decoder decodeBoolForKey:@"isFetchDetail"];
    self.actor=[decoder decodeObjectForKey:@"actor"];
    self.country=[decoder decodeObjectForKey:@"country"];
    self.description=[decoder decodeObjectForKey:@"description"];
    self.director=[decoder decodeObjectForKey:@"director"];
    self.filmType=[decoder decodeObjectForKey:@"filmType"];
    self.bigStillPath=[decoder decodeObjectForKey:@"bigStillPath"];
    self.stillPath=[decoder decodeObjectForKey:@"stillPath"];
    self.stillArray=[decoder decodeObjectForKey:@"stillArray"];
    

    self.scheduleDicArray=[decoder decodeObjectForKey:@"scheduleDicArray"];

    return self;
}

@end
