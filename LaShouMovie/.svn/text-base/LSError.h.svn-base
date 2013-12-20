//
//  LSError.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-5.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    LSErrorCodeParseWrong=0,//数据格式错误
    LSErrorCodeResponseEmpty,//响应空
    LSErrorCodeNetworkInterruption,//网络中断
    LSErrorCodeParamatersIsNull//参数空
}LSErrorCode;

@interface LSError : NSObject
{
    LSErrorCode _code;
    NSString* _message;
    NSString* _detail;
}

@property(nonatomic,assign) LSErrorCode code;
@property(nonatomic,retain) NSString* message;
@property(nonatomic,retain) NSString* detail;

+ (LSError *)errorWithCode:(NSInteger)code message:(NSString*)message detail:(NSString*)detail;

@end
