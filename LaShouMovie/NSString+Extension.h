//
//  NSString+Extension.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-8-28.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

//计算数据唯一性值
- (NSString*)MD5;
- (NSString*)SHA1;
- (NSString*)SHA256;

- (NSString *)encodingURL;
- (NSString *)decodingURL;

- (NSData*)dataWithBase64Encode;
@end
