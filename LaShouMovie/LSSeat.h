//
//  LSSeat.h
//  LaShouMovie
//
//  Created by Li XiangYu on 13-9-15.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSSeat : NSObject<NSCoding>
{
//    {
//        columnId = 10;
//        columnNum = 11;
//        isDamaged = 0;
//        rowId = 10;
//        rowNum = 10;
//        type = 0;
//    }
    
    NSString* _sectionID;
    
    //现实列编号是相对于事实的，也就是这个座位在电影院中的行编号
    NSString* _realColumnID;//现实列编号
    
    //列编号是相对于客户端成图的，也就是为了方便计算与排布的编号。
    //这里之所以使用CGFloat型，是为了以后出现座位差隔的情况
    CGFloat _columnID;//列编号
    
    NSString* _realRowID;//现实行编号
    int _rowID;//行编号
    
    BOOL _isDamage;//是否已经损坏
    LSSeatType _type;//类型
    
    //以下数据由本地生成
    BOOL _isSold;//是否已经售出
    
    LSSeatStatus _seatStatus;
    LSSeatStatus _originSeatStatus;
}
@property(nonatomic,retain) NSString* sectionID;
@property(nonatomic,retain) NSString* realColumnID;
@property(nonatomic,assign) CGFloat columnID;
@property(nonatomic,retain) NSString* realRowID;
@property(nonatomic,assign) int rowID;
@property(nonatomic,assign) BOOL isDamage;
@property(nonatomic,assign) LSSeatType type;
@property(nonatomic,assign) BOOL isSold;

@property(nonatomic,assign) LSSeatStatus seatStatus;
@property(nonatomic,assign) LSSeatStatus originSeatStatus;;

- (id)initWithDictionary:(NSDictionary*)safeDic;

- (BOOL)sortByColumnID:(LSSeat*)seat;

@end
