//
//  LSAlipay.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-29.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

//
//本单例存在的主要原因是，支付宝的accessToken为一次性使用
//

#import <Foundation/Foundation.h>

@interface LSAlipay : NSObject
{
    NSString* _accessToken;
}
@property(nonatomic,retain) NSString* accessToken;

+ (LSAlipay *)currentAlipay;

@end
