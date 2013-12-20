//
//  LSCinema.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-10.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSCinema : NSObject<NSCoding>
{
//    {
//        address = "\U65b0\U987a\U5357\U5927\U885718\U53f7\U65b0\U4e16\U754c\U767e\U8d27\U4e03\U5c42
//        \n";
//        areaId = 1;
//        areaName = "\U987a\U4e49";
//        buyType = 2;
//        cinemaId = 3842;
//        cinemaName = "\U5317\U4eac\U535a\U7eb3\U56fd\U9645\U5f71\U57ce(\U987a\U4e49\U5e97)";
//        districtId = 1537;
//        districtName = "\U987a\U4e49";
//        featuresId = "1001,";
//        firstImg = "cinema/logo/300/201212/03/15-46451.jpg";
//        groupBuy =             (
//                                {
//                                    "goods_id" = 7728628;
//                                    "goods_title" = "\U535a\U7eb3\U56fd\U9645\U5f71\U57ce\Uff1a\U7535\U5f71\U7968\Uff0c2D/3D\U901a\U5151";
//                                }
//                                );
//        glatitude = "39.927530";//谷歌坐标（优先使用）
//        glongitude = "116.447114";
//        latitude = "40.133125";//百度坐标
//        longitude = "116.657917";
//        numFilmOnLine = 9;
//        phone = "010-60406018";
//        restScheduleCount = 17;
//        totalScheduleCount = 27;
//        didtance="100"
//    }
    
    NSString* _cinemaID;//影院ID
    NSString* _cinemaName;//影院名称
    NSString* _districtID;//行政区ID
    NSString* _districtName;//行政区名称
    NSString* _areaID;//子区ID
    NSString* _areaName;//子区名称
    NSString* _featuresID;
    double _latitude;//纬度
    double _longitude;//经度
    NSString* _filmCount;//在线影片数
    NSString* _todayScheduleCount;//今日排期数
    NSString* _totalScheduleCount;//全部排期数
    NSString* _phone;//电话
    NSString* _address;//地址
    NSString* _imageURL;//图片路径
    LSCinemaBuyType _buyType;//购买状态 0只可以选座 1只可以团购 2即可选座也可团购 3不能选座也不能团购
    NSArray* _groupArray;//团购信息
    NSString* _distance;//与用户当前距离
}

@property(nonatomic,retain) NSString* cinemaID;//影院ID
@property(nonatomic,retain) NSString* cinemaName;//影院名称
@property(nonatomic,retain) NSString* districtID;//行政区ID
@property(nonatomic,retain) NSString* districtName;//行政区名称
@property(nonatomic,retain) NSString* areaID;//子区ID
@property(nonatomic,retain) NSString* areaName;//子区名称
@property(nonatomic,retain) NSString* featuresID;
@property(nonatomic,assign) double latitude;//纬度
@property(nonatomic,assign) double longitude;//经度
@property(nonatomic,retain) NSString* filmCount;//在线影片数
@property(nonatomic,retain) NSString* todayScheduleCount;//今日排期数
@property(nonatomic,retain) NSString* totalScheduleCount;//全部排期数
@property(nonatomic,retain) NSString* phone;//电话
@property(nonatomic,retain) NSString* address;//地址
@property(nonatomic,retain) NSString* imageURL;//图片路径
@property(nonatomic,assign) LSCinemaBuyType buyType;//购买状态 0只可以选座 1只可以团购 2即可选座也可团购 3不能选座也不能团购
@property(nonatomic,retain) NSArray* groupArray;//团购信息

@property(nonatomic,retain) NSString* distance;//与用户当前距离

- (id)initWithDictionary:(NSDictionary*)safeDic;
- (BOOL)distanceSort:(LSCinema*)cinema;

@end
