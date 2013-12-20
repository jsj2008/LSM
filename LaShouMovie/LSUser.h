//
//  LSUser.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-8-29.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>

@interface LSUser : NSObject<NSCoding>
{
//    普通登陆时返回的简易数据
//    {
//        profile = {
//            email = "2352214850@qq.com";
//            id = 1613127784;
//            name = qatest;
//        };
//    }
    
//    联合登陆时返回的数据
//    {
//        profile = {
//            email = "";
//            id = 1613127784;
//            name = qatest;
//            password = 54381fb45e52e442fe76112ade14a24b;
//            type = 3;
//        };
//    }
    
    NSString* _userID;//拉手网的用户ID
    NSString* _userName;//姓名
#warning 用户密码一定是以密文储存的
    NSString* _password;//密码
    NSString* _email;//邮箱
    NSString* _mobile;//手机号
    NSString* _otherMobile;//其他暂时使用的手机号
    NSString* _balance;//余额
    NSString* _cityID;//城市ID    
    NSString* _cityName;//城市名
    NSString* _locationCityID;//定位出得城市ID
    NSString* _locationCityName;//定位出的城市名
    LSLoginType _loginType;//登陆类型
    CLLocation* _location;//地理位置
    
    NSInteger _paidCount;//已付款订单数
    NSInteger _unpayCount;//未付款订单数
    
    BOOL _isImageOnlyWhenWifi;
    BOOL _isCreateCard;
    NetworkStatus _networkStatus;
}

@property(nonatomic,retain) NSString* userID;
@property(nonatomic,retain) NSString* userName;
@property(nonatomic,retain) NSString* password;
@property(nonatomic,retain) NSString* email;
@property(nonatomic,retain) NSString* mobile;
@property(nonatomic,retain) NSString* otherMobile;
@property(nonatomic,retain) NSString* balance;
@property(nonatomic,retain) NSString* cityID;
@property(nonatomic,retain) NSString* cityName;
@property(nonatomic,retain) NSString* locationCityID;
@property(nonatomic,retain) NSString* locationCityName;
@property(nonatomic,assign) LSLoginType loginType;
@property(nonatomic,retain) CLLocation* location;

@property(nonatomic,assign) NSInteger paidCount;
@property(nonatomic,assign) NSInteger unpayCount;

@property(nonatomic,assign) BOOL isImageOnlyWhenWifi;
@property(nonatomic,assign) BOOL isCreateCard;
@property(nonatomic,assign) NetworkStatus networkStatus;

+ (LSUser *)currentUser;
- (void)logout;
- (void)copyPreUser:(LSUser*)preUser;
- (void)completePropertyWithDictionary:(NSDictionary*)safeDic;

@end
