//
//  NSData+Extension.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-8-28.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "NSData+Extension.h"

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
//获取MD5
#import <CommonCrypto/CommonDigest.h>

@implementation NSData (Extension)

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
    
    CC_MD5(self.bytes,self.length,output);
    return [self toHexString:output length:outputLength];
}
- (NSString*)SHA1
{
	unsigned int outputLength = CC_SHA1_DIGEST_LENGTH;
	unsigned char output[outputLength];
	
	CC_SHA1(self.bytes,self.length,output);
	return [self toHexString:output length:outputLength];
}
- (NSString*)SHA256
{
	unsigned int outputLength = CC_SHA256_DIGEST_LENGTH;
	unsigned char output[outputLength];
	
	CC_SHA256(self.bytes,self.length,output);
	return [self toHexString:output length:outputLength];
}

- (NSString *)base64Encode
{
	if ([self length] == 0)
		return @"";
	
    char *characters = malloc((([self length] + 2) / 3) * 4);
	if (characters == NULL)
		return nil;
	NSUInteger length = 0;
	
	NSUInteger i = 0;
	while (i < [self length])
	{
		char buffer[3] = {0,0,0};
		short bufferLength = 0;
		while (bufferLength < 3 && i < [self length])
			buffer[bufferLength++] = ((char *)[self bytes])[i++];
		
		//  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
		characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
		characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
		if (bufferLength > 1)
			characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
		else characters[length++] = '=';
		if (bufferLength > 2)
			characters[length++] = encodingTable[buffer[2] & 0x3F];
		else characters[length++] = '=';
	}
	
	return [[[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES] autorelease];
}

@end
