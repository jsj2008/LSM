//
//  LSSection.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-16.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSSection : NSObject<NSCoding>
{
//    {
//        "api_source" = 8;
//        maxTicketNum = 4;
//        seats = ();
//        sectionId = 01;
//        sectionName = "10\U53f7\U5385";
//    }
    
    LSApiSource _apiSource;//票务供应商
    NSString* _sectionID;//片区编号
    NSString* _sectionName;//片区名称
    NSInteger _maxTicketNumber;//最多购票数
    
    NSArray* _seatArray;//座位数组，用于生成座位图
    NSDictionary* _seatDictionary;//座位字典，用于判断选座规则
    
    
    //以下数据有本地生成
    CGFloat _columnNumber;//列数
    int _rowNumber;//行数
    
    NSArray* _rowIDArray;//行标数组
}
@property(nonatomic,assign) LSApiSource apiSource;//票务供应商
@property(nonatomic,retain) NSString* sectionID;//片区编号
@property(nonatomic,retain) NSString* sectionName;//片区名称
@property(nonatomic,assign) NSInteger maxTicketNumber;//最多购票数

@property(nonatomic,retain) NSArray* seatArray;//座位数组
@property(nonatomic,retain) NSDictionary* seatDictionary;//座位字典

@property(nonatomic,assign) CGFloat columnNumber;//列数
@property(nonatomic,assign) int rowNumber;//行数
@property(nonatomic,retain) NSArray* rowIDArray;//行标数组

- (id)initWithDictionary:(NSDictionary *)safeDic;
- (void)makeSeatDictionary;

@end
