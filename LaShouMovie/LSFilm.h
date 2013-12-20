//
//  LSFilm.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-2.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSFilm : NSObject<NSCoding>
{
//第一部分请求返回的数据
//    {
//        brief = "<null>";
//        dimensional = 1;
//        duration = 107;
//        filmId = 4529;
//        filmName = "\U5468\U6069\U6765\U7684\U56db\U4e2a\U663c\U591c";
//        grade = "4.0";
//        imageUrl = "http://d1.lashouimg.com/";
//        imax = 0;
//        posterUrl = "http://d1.lashouimg.com/";
//        releaseDate = "2099-12-12";
//        showCinemasCount = 0;
//        showSchedulesCount = 0;
//        starCode = "4.5";
//        status = 0;
//    }
    
    NSString* _filmID;//电影ID
    NSString* _filmName;//电影名称
    NSString* _releaseDate;//上映时间
    BOOL _isPresell;//是否预售
    NSString* _duration;//时长
    NSString* _brief;//简介
    NSString* _grade;//评分
    CGFloat _starCode;//星级
    LSFilmDimensional _dimensional;//2D、3D
    BOOL _isIMAX;//iMax
    int _showCinemasCount;//上映影院数
    int _showSchedulesCount;//上映排期数
    NSString* _imageURL;//主图(小)
    NSString* _posterURL;//海报(大)
    LSFilmShowStatus _showStatus;//上映状态

//第二部分请求返回的数据
//    {
//        actor = "<null>";
//        bigStillPath = "cinema/film/580";
//        country = "<null>";
//        description = "<null>";
//        director = "<null>";
//        filmId = 4431;
//        filmType = "<null>";
//        stillList = "<null>";
//        stillPath = "cinema/film/100";
//    }
    BOOL _isFetchDetail;//是否已经请求详情
    NSString* _actor;//主演
    NSString* _country;//国家
    NSString* _description;//描述
    NSString* _director;//导演
    NSString* _filmType;//类型
    NSString* _bigStillPath;//剧照路径(大)
    NSString* _stillPath;//剧照路径(小)
    NSArray* _stillArray;//剧照
    
//附加的排期字典数组
    NSArray* _scheduleDicArray;//排期字典数组
}

//第一部分请求返回的数据
@property(nonatomic, retain) NSString* filmID;//电影ID
@property(nonatomic, retain) NSString* filmName;//电影名称
@property(nonatomic, retain) NSString* releaseDate;//上映时间
@property(nonatomic, assign) BOOL isPresell;//是否预售
@property(nonatomic, retain) NSString* duration;//时长
@property(nonatomic, retain) NSString* brief;//简介
@property(nonatomic, retain) NSString* grade;//评分
@property(nonatomic, assign) CGFloat starCode;//星级
@property(nonatomic, assign) LSFilmDimensional dimensional;//2D、3D
@property(nonatomic, assign) BOOL isIMAX;//iMax
@property(nonatomic, assign) int showCinemasCount;//上映影院数
@property(nonatomic, assign) int showSchedulesCount;//上映排期数
@property(nonatomic, retain) NSString* imageURL;//主图(小)
@property(nonatomic, retain) NSString* posterURL;//海报(大)
@property(nonatomic, assign) LSFilmShowStatus showStatus;//状态


//第二部分请求返回的数据
@property(nonatomic, assign) BOOL isFetchDetail; //是否已经请求详情
@property(nonatomic, retain) NSString* actor;//主演
@property(nonatomic, retain) NSString* country;//国家
@property(nonatomic, retain) NSString* description;//描述
@property(nonatomic, retain) NSString* director;//导演
@property(nonatomic, retain) NSString* filmType;//类型
@property(nonatomic, retain) NSString* bigStillPath;//剧照路径(大)
@property(nonatomic, retain) NSString* stillPath;//剧照路径(小)
@property(nonatomic, retain) NSArray* stillArray;//剧照


//附加的排期字典数组
@property(nonatomic, retain) NSArray* scheduleDicArray;//排期字典数组


- (id)initWithDictionary:(NSDictionary*)dic;
- (void)completePropertyWithDictionary:(NSDictionary*)safeDic;

@end
