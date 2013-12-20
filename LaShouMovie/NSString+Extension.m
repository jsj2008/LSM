//
//  NSString+Extension.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-8-28.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "NSString+Extension.h"

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
//获取MD5
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Extension)

- (unsigned int)UTF8Length
{
	return (unsigned int)[self lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
}
- (NSString*)toHexString:(unsigned char*)data length:(unsigned int)length
{
	NSMutableString* hash = [NSMutableString stringWithCapacity:length * 2];
	for (unsigned int i = 0; i < length; i++)
    {
		[hash appendFormat:@"%02x", data[i]];
		data[i] = 0;
	}
	return hash;
}

- (NSString*)MD5
{
	unsigned int outputLength = CC_MD5_DIGEST_LENGTH;
	unsigned char output[outputLength];
	
	CC_MD5(self.UTF8String, [self UTF8Length], output);
	return [self toHexString:output length:outputLength];
}
- (NSString*)SHA1
{
	unsigned int outputLength = CC_SHA1_DIGEST_LENGTH;
	unsigned char output[outputLength];
	
	CC_SHA1(self.UTF8String, [self UTF8Length], output);
	return [self toHexString:output length:outputLength];
}
- (NSString*)SHA256
{
	unsigned int outputLength = CC_SHA256_DIGEST_LENGTH;
	unsigned char output[outputLength];
	
	CC_SHA256(self.UTF8String, [self UTF8Length], output);
	return [self toHexString:output length:outputLength];
}

- (NSString *)encodingURL
{
	return [(NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)self,NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8) autorelease];
}

- (NSString *)decodingURL
{
    NSString *result = [NSString stringWithString:self];
    result = [result stringByReplacingOccurrencesOfString:@"+" withString:@"%20"];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return result;
}

- (NSData*)dataWithBase64Encode
{
	if (self == nil)
		[NSException raise:NSInvalidArgumentException format:nil, nil];
	if ([self length] == 0)
		return [NSData data];
	
	static char *decodingTable = NULL;
	if (decodingTable == NULL)
	{
		decodingTable = malloc(256);
		if (decodingTable == NULL)
			return nil;
		memset(decodingTable, CHAR_MAX, 256);
		NSUInteger i;
		for (i = 0; i < 64; i++)
			decodingTable[(short)encodingTable[i]] = i;
	}
	
	const char *characters = [self cStringUsingEncoding:NSASCIIStringEncoding];
	if (characters == NULL)     //  Not an ASCII string!
		return nil;
	char *bytes = malloc((([self length] + 3) / 4) * 3);
	if (bytes == NULL)
		return nil;
	NSUInteger length = 0;
	
	NSUInteger i = 0;
	while (YES)
	{
		char buffer[4];
		short bufferLength;
		for (bufferLength = 0; bufferLength < 4; i++)
		{
			if (characters[i] == '\0')
				break;
			if (isspace(characters[i]) || characters[i] == '=')
				continue;
			buffer[bufferLength] = decodingTable[(short)characters[i]];
			if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
			{
				free(bytes);
				return nil;
			}
		}
		
		if (bufferLength == 0)
			break;
		if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
		{
			free(bytes);
			return nil;
		}
		
		//  Decode the characters in the buffer to bytes.
		bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
		if (bufferLength > 2)
			bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
		if (bufferLength > 3)
			bytes[length++] = (buffer[2] << 6) | buffer[3];
	}
	
	realloc(bytes, length);
	return [NSData dataWithBytesNoCopy:bytes length:length];
}

@end
