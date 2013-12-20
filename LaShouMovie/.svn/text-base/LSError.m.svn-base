//
//  LSError.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-5.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSError.h"

@implementation LSError

@synthesize code=_code;
@synthesize message=_message;
@synthesize detail=_detail;

- (void)setCode:(LSErrorCode)code
{
    _code=code;
    switch (code)
    {
		case LSErrorCodeParseWrong:
			self.message = @"服务器返回数据格式不正确.";
			break;
		case LSErrorCodeResponseEmpty:
			self.message = @"服务器未返回任何数据.";
			break;
		case LSErrorCodeNetworkInterruption:
			self.message = @"网络不可用.";
			break;
		case LSErrorCodeParamatersIsNull:
			self.message = @"参数为空.";
			break;
		default:
			break;
	}
}

- (void)dealloc
{
    self.message = nil;
    self.detail = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self!=nil)
    {
        //将错误码值设为不可能的值
        self.code = -1;
    }
    
    return self;
}

+ (LSError *)errorWithCode:(NSInteger)code message:(NSString*)message detail:(NSString*)detail
{
	LSError *error = [[LSError alloc] init];
	error.code = code;
	error.message = message;
	error.detail = detail;
	return [error autorelease];
}


- (NSString *)description
{
	return [NSString stringWithFormat:@"LSError:{\n Code:'%d',\n Message:'%@',\n Detail:'%@'}",_code,_message,_detail];
}

@end
