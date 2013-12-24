//
//  LSSchedule.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-12.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSHall.h"

@interface LSSchedule : NSObject<NSCoding>
{
//    {
//        campaignSign = 0;
//        dimensional = 1;
//        expectEndTime = "18:45";
//        hall =                     {
//            hallId = 5;
//            hallName = "5\U53f7\U5385";
//        };
//        imax = 0;
//        initialPrice = "65.00";
//        language = "\U82f1\U8bed";
//        price = "65.00";
//        seqNo = 1417285;
//        startDate = "2013-09-12";
//        startTime = "17:00";
//    }

    
    NSString* _scheduleID;//排期ID
    LSFilmDimensional _dimensional;//2D、3D
    BOOL _isIMAX;//iMax
    NSString* _language;//语言
    LSHall* _hall;//放映厅
    NSString* _initialPrice;//原价
    NSString* _price;//终价
    BOOL _isOnSale;//是否特价
    NSString* _startDate;//开始日期
    NSString* _startTime;//开始时间
    NSString* _expectEndTime;//预计结束时间
}


@property(nonatomic,retain) NSString* scheduleID;//排期ID
@property(nonatomic,assign) LSFilmDimensional dimensional;//2D、3D
@property(nonatomic,assign) BOOL isIMAX;//iMax
@property(nonatomic,retain) NSString* language;//语言
@property(nonatomic,retain) LSHall* hall;;//放映厅
@property(nonatomic,retain) NSString* initialPrice;//原价
@property(nonatomic,retain) NSString* price;//终价
@property(nonatomic,assign) BOOL isOnSale;//是否特价
@property(nonatomic,retain) NSString* startDate;//开始日期
@property(nonatomic,retain) NSString* startTime;//开始时间
@property(nonatomic,retain) NSString* expectEndTime;//预计结束时间

- (id)initWithDictionary:(NSDictionary*)safeDic;

@end
