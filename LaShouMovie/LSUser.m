//
//  LSUser.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-8-29.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSUser.h"
#import "LSPayWay.h"

@implementation LSUser

@synthesize userID=_userID;
@synthesize userName=_userName;
@synthesize password=_password;
@synthesize email=_email;
@synthesize mobile=_mobile;
@synthesize otherMobile=_otherMobile;
@synthesize balance=_balance;
@synthesize cityID=_cityID;
@synthesize cityName=_cityName;
@synthesize locationCityID=_locationCityID;
@synthesize locationCityName=_locationCityName;
@synthesize loginType=_loginType;
@synthesize location=_location;

@synthesize paidCount=_paidCount;
@synthesize unpayCount=_unpayCount;

@synthesize isImageOnlyWhenWifi=_isImageOnlyWhenWifi;
@synthesize isCreateCard=_isCreateCard;
@synthesize networkStatus=_networkStatus;

@synthesize payWayArray=_payWayArray;

static LSUser* user=nil;

+ (LSUser *)currentUser
{
    @synchronized(self)
    {
        if (user==nil)
        {
            user=[[super allocWithZone:NULL] init];
            user.isCreateCard=YES;
        }
    }
    return user;
}
+ (id)alloc
{
    return [[self currentUser] retain];
}
+ (id)allocWithZone:(NSZone *)zone
{
    return [[self currentUser] retain];
}
- (id)copyWithZone:(NSZone *)zone;
{
    return self; //确保copy对象也是唯一
}
- (id)retain
{
    return self; //确保计数唯一
}
- (NSUInteger)retainCount
{
    return NSUIntegerMax;  //这样打印出来的计数永远为-1
}
- (oneway void)release
{
    //do nothing
}
+ (void)release
{
    //do nothing
}
- (id)autorelease
{
    return self;//确保计数唯一
}

- (NSArray*)createUserBasicPayWayArray
{
    NSMutableArray* payWayArray=[NSMutableArray arrayWithCapacity:0];
    
    LSPayWay* alipayPayWay=[[LSPayWay alloc] init];
    alipayPayWay.payWayID=0;
    alipayPayWay.payWayName=@"支付宝支付";
    alipayPayWay.information=@"推荐支付宝用户使用";
    [payWayArray addObject:alipayPayWay];
    [alipayPayWay release];
    
    return payWayArray;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_userID forKey:@"userID"];
    [aCoder encodeObject:_userName forKey:@"userName"];
    [aCoder encodeObject:_password forKey:@"password"];
    [aCoder encodeObject:_email forKey:@"email"];
    [aCoder encodeObject:_mobile forKey:@"mobile"];
    [aCoder encodeObject:_balance forKey:@"balance"];
    [aCoder encodeObject:_cityID forKey:@"cityID"];
    [aCoder encodeObject:_cityName forKey:@"cityName"];
    [aCoder encodeInt:_loginType forKey:@"loginType"];
    [aCoder encodeObject:_location forKey:@"location"];
    
    [aCoder encodeBool:_isImageOnlyWhenWifi forKey:@"isImageOnlyWhenWifi"];
    [aCoder encodeBool:_isCreateCard forKey:@"isCreateCard"];
    
    [aCoder encodeObject:_payWayArray forKey:@"payWayArray"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self.userID=[decoder decodeObjectForKey:@"userID"];
    self.userName=[decoder decodeObjectForKey:@"userName"];
    self.password=[decoder decodeObjectForKey:@"password"];
    self.email=[decoder decodeObjectForKey:@"email"];
    self.mobile=[decoder decodeObjectForKey:@"mobile"];
    self.balance=[decoder decodeObjectForKey:@"balance"];
    self.cityID=[decoder decodeObjectForKey:@"cityID"];
    self.cityName=[decoder decodeObjectForKey:@"cityName"];
    self.loginType=[decoder decodeIntForKey:@"loginType"];
    self.location=[decoder decodeObjectForKey:@"location"];
    
    self.isImageOnlyWhenWifi=[decoder decodeBoolForKey:@"isImageOnlyWhenWifi"];
    self.isCreateCard=[decoder decodeBoolForKey:@"isCreateCard"];
    
    self.payWayArray=[decoder decodeObjectForKey:@"payWayArray"];
    return self;
}

#pragma mark- 退出
- (void)logout
{
    user.userID=nil;
    user.userName=nil;
    user.email=nil;
    user.mobile=nil;
    user.balance=nil;
//    user.cityID=nil;
//    user.cityName=nil;
//    user.locationCityID=nil;
//    user.locationCityName=nil;
    user.loginType=LSLoginTypeNon;
//    user.location=nil;
       
    user.isImageOnlyWhenWifi=NO;
    user.isCreateCard=YES;
    //每个用户都是新用户
//    [LSSave saveObject:nil forKey:LSCardRemind];
}


#pragma mark- 复制原始数据
- (void)copyPreUser:(LSUser*)preUser
{
    if(preUser!=nil)
    {
        user.userID=preUser.userID;
        user.userName=preUser.userName;
        user.password=preUser.password;
        user.email=preUser.email;
        user.mobile=preUser.mobile;
        user.balance=preUser.balance;
        user.cityID=preUser.cityID;
        user.cityName=preUser.cityName;
        user.loginType=preUser.loginType;
        user.location=preUser.location;
        
        user.isImageOnlyWhenWifi=preUser.isImageOnlyWhenWifi;
        user.isCreateCard=preUser.isCreateCard;
        
        if(preUser.payWayArray.count>0)
        {
            user.payWayArray=preUser.payWayArray;
        }
        else
        {
            user.payWayArray=[user createUserBasicPayWayArray];
        }
    }
}


- (void)completePropertyWithDictionary:(NSDictionary*)safeDic
{
    user.userID=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"id"]];
    user.email=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"email"]];
    user.userName=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"name"]];
    if([safeDic objectForKey:@"password"]!=NULL && [safeDic objectForKey:@"password"]!=[NSNull null])
    {
        user.password=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"password"]];
    }
    if([safeDic objectForKey:@"type"]!=NULL && [safeDic objectForKey:@"type"]!=[NSNull null])
    {
        user.loginType=[[safeDic objectForKey:@"type"] integerValue];
    }
    if([safeDic objectForKey:@"mobile"]!=NULL && [safeDic objectForKey:@"mobile"]!=[NSNull null] && ![[safeDic objectForKey:@"mobile"] isEqualToString:LSNULL])
    {
        user.mobile=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"mobile"]];
    }
    if([safeDic objectForKey:@"balance"]!=NULL && [safeDic objectForKey:@"balance"]!=[NSNull null])
    {
        user.balance=[NSString stringWithFormat:@"%@",[safeDic objectForKey:@"balance"]];
    }
}


@end
