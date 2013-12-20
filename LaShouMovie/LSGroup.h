//
//  LSGroup.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-10.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSGroup : NSObject<NSCoding>
{
    //影院团购
//{
//        "goods_id" = 7728628;
//        "goods_title" = "\U535a\U7eb3\U56fd\U9645\U5f71\U57ce\Uff1a\U7535\U5f71\U7968\Uff0c2D/3D\U901a\U5151";
//}
    //团购详细
//    {
//        aleadyBought = 1466;
//        endTime = 1383148799;
//        goodsDetail = "";
//        goodsTips = "这里是一个网页，需要用UIWebView来解析";
//        "goods_id" = 7599819;
//        graphicDetails = "这里是一个网页，需要用UIWebView来解析";
//        imageBig = "http://d1.lashouimg.com/zt/201305/22/136921177747637500.jpg";
//        imageMid = "http://d1.lashouimg.com/zt_mobile_220/201305/22/136921177747637500.jpg";
//        imageSmall = "http://d1.lashouimg.com/zt_mobile_110/201305/22/136921177747637500.jpg";
//        initialPrice = "120.00";
//        isAutoRefund = 0;
//        isSevenRefund = 0;
//        maxPerUserCanBuy = 50;
//        minPerUserMustBuy = 1;
//        phone = "4000-517-317";
//        price = "32.00";
//        serverTime = 1381392576;
//    }
    
    NSString* _groupID;//团ID
    NSString* _groupTitle;//团标题
    
    BOOL _isFetchDetail;//是否已经请求详情
    NSString* _bigImageURL;//大图
    NSString* _midImageURL;//中图
    NSString* _smallImageURL;//小图
    CGFloat _initialPrice;//原价
    CGFloat _price;//终价
    BOOL _isSevenRefund;//是否支持七天退款
    BOOL _isAutoRefund;//是否支持自动退款
    NSString* _aleadyBought; //已经购买数
    NSInteger _maxCanBuy;//最大购买数
    NSInteger _minMustBuy;//最小购买数
    NSDate* _endTime;//结束时间
    NSDate* _serverTime; //服务器时间
    NSString* _goodsDetail;//本单详情
    NSString* _goodsTips;//温馨提示
    NSString* _graphicDetails;//图文详情
    NSString* _phone;//客服
}

@property(nonatomic,retain) NSString* groupID;
@property(nonatomic,retain) NSString* groupTitle;

@property(nonatomic,assign) BOOL isFetchDetail;;//是否已经请求详情
@property(nonatomic,retain) NSString* bigImageURL;//大图
@property(nonatomic,retain) NSString* midImageURL;//中图
@property(nonatomic,retain) NSString* smallImageURL;//小图
@property(nonatomic,assign) CGFloat initialPrice;//原价
@property(nonatomic,assign) CGFloat price;//终价
@property(nonatomic,assign) BOOL isSevenRefund;//是否支持七天退款
@property(nonatomic,assign) BOOL isAutoRefund;//是否支持自动退款
@property(nonatomic,retain) NSString* aleadyBought; //已经购买数
@property(nonatomic,assign) NSInteger maxCanBuy;//最大购买数
@property(nonatomic,assign) NSInteger minMustBuy;//最小购买数
@property(nonatomic,retain) NSDate* endTime;//结束时间
@property(nonatomic,retain) NSDate* serverTime; //服务器时间
@property(nonatomic,retain) NSString* goodsDetail;//本单详情
@property(nonatomic,retain) NSString* goodsTips;//温馨提示
@property(nonatomic,retain) NSString* graphicDetails;//图文详情
@property(nonatomic,retain) NSString* phone;//客服

- (id)initWithDictionary:(NSDictionary*)safeDic;
- (void)completePropertyWithDictionary:(NSDictionary*)safeDic;

@end
