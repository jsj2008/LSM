//
//  LSTools.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-8-22.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTools.h"

//获取MAC地址
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#include <sys/utsname.h>

#include "pinyin.h"

//解压数据

#define kSignKeyChainServiceName @"kSignKeyChainServiceName"
#define lsUUID @"UUID"
#define PI 3.1415926

@implementation LSTools

#pragma mark-
+(BOOL)checkEmail:(NSString*)email
{
    NSString* emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
+(BOOL)checkPhone:(NSString*)phone
{
    NSString* phoneRegex = @"1+[0-9]{10,12}";
    NSPredicate* phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}


#pragma mark-
+ (NSString *)makeMacAddress
{
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    size_t              length;
    unsigned char       macAddress[6];
    struct if_msghdr    *interfaceMsgStruct;
    struct sockaddr_dl  *socketStruct;
    NSString            *errorFlag = NULL;
    
    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    
    // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
    {
        errorFlag = @"if_nametoindex failure";
    }
    else
    {
        // Get the size of the data available (store in len)
        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
        {
            errorFlag = @"sysctl mgmtInfoBase failure";
        }
        else
        {
            // Alloc memory based on above call
            if ((msgBuffer = malloc(length)) == NULL)
            {
                errorFlag = @"buffer allocation failure";
            }
            else
            {
                // Get system information, store in buffer
                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
                {
                    errorFlag = @"sysctl msgBuffer failure";
                }
            }
        }
    }
    
    // Befor going any further...
    if (errorFlag != NULL)
    {
        LSLOG(@"Error: %@", errorFlag);
        return errorFlag;
    }
    
    // Map msgbuffer to interface message structure
    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
    
    // Map to link-level socket structure
    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
    
    // Copy link layer address data in socket structure to an array
    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
    
    // Read from char array into a string object, into traditional Mac address format
    //  NSString *macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",macAddress[0], macAddress[1], macAddress[2], macAddress[3], macAddress[4], macAddress[5]];
    //  NSLog(@"Mac Address: %@", macAddressString);
    
    NSString *macAddressString = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X",macAddress[0], macAddress[1], macAddress[2],macAddress[3], macAddress[4], macAddress[5]];//使用不带分隔符的字符串
    
    // Release the buffer memory
    free(msgBuffer);
    
    return [macAddressString MD5];
}
+ (NSString*)makeOpenUDID
{
    return nil;
}


#pragma mark- 转换时间
+ (NSString*)convertTimeString:(NSString*)timeString toCustomTimeFomatter:(NSString*)fomatter
{
    NSDate* convert=[NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]];
    //时间换算格式
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:fomatter];
    NSString* targetTime=nil;
    targetTime=[dateFormatter stringFromDate:convert];
    [dateFormatter release];
    return targetTime;
}
+ (NSString*)nowTimeString
{
    NSDate* now=[NSDate date];
    NSTimeInterval interval=[now timeIntervalSince1970];
    return [NSString stringWithFormat:@"%f",interval];
}


#pragma mark- 解压缩
+ (NSData*)unzipToFilePath:(NSString *)filePath//解压文件
{
    return nil;
}


#pragma mark- 判断设备类型
+ (NSString *) platform//设备判断
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char* machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    NSLog(@"%@",platform);
    
    /*
     逗号后面数字解释：(i386是指模拟器)
     1-WiFi版
     2-GSM/WCDMA 3G版
     3-CDMA版
     
     iPhone (iPhone1,1)
     iPhone3G (iPhone1,2)
     iPhone3GS (iPhone2,1)
     iPhone4 (iPhone3,1)
     iPhone4(vz) (iPhone3,3)iPhone4 CDMA版
     iPhone4S (iPhone4,1)
     
     iPodTouch(1G) (iPod1,1)
     iPodTouch(2G) (iPod2,1)
     iPodTouch(3G) (iPod3,1)
     iPodTouch(4G) (iPod4,1)
     
     iPad (iPad1,1)
     iPad2,1 (iPad2,1)Wifi版
     iPad2,2 (iPad2,2)GSM3G版
     iPad2,3 (iPad2,3)CDMA3G版
     */
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4 CDMA";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4";
    
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad 1";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2";
    
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    return @"新设备";
}


//获取安全数据
//规则 无论是字符串、字典、数组，当为NULL、[NSNull null]的时候，统一转换为nil，可以最大程度的避免数据空问题
//注意传进来的data必须为NSMutable*类型
+ (void)makeSafeData:(id)data
{
    if([[data class] isSubclassOfClass:[NSDictionary class]])
    {
        NSMutableDictionary* dic=data;
        for (NSString* key in [[[dic allKeys] copy] autorelease])
        {
            id value=[dic objectForKey:key];
            if(value ==NULL || value==[NSNull null])
            {
                [dic setObject:nil forKey:key];
            }
            else if([[value class] isSubclassOfClass:[NSDictionary class]])
            {
                [self makeSafeData:(NSMutableDictionary*)value];
            }
            else if([[value class] isSubclassOfClass:[NSArray class]])
            {
                [self makeSafeData:(NSMutableArray*)value];
            }
        }
    }
    else if([[data class] isSubclassOfClass:[NSArray class]])
    {
        NSMutableArray* arr=(NSMutableArray*)data;
        for(int i=0;i<arr.count;i++)
        {
            id value=[arr objectAtIndex:i];
            if(value ==NULL || value==[NSNull null])
            {
                [arr removeObjectAtIndex:i];
            }
            else if([[value class] isSubclassOfClass:[NSDictionary class]])
            {
                [self makeSafeData:(NSMutableDictionary*)value];
            }
            else if([[value class] isSubclassOfClass:[NSArray class]])
            {
                [self makeSafeData:(NSMutableArray*)value];
            }
        }
    }
}


#pragma mark- 用于强制升级,辅助方法不暴露(与原有方法有重复)
+ (NSString *)stid
{
    LSUser* user=[LSUser currentUser];
    NSString *stid = [NSString stringWithFormat:@"/STID/movies_%@_iphone_%@_%@_%@_%@_%@_%@",
                     [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"],
                     lsChannelID,
                     [[LSTools UUID] stringByReplacingOccurrencesOfString:@"_" withString:@"-"],
                      (user.userID!=nil?user.userID:@"0"),
                      (user.cityID!=nil?user.cityID:@"NULL"),
                     [[LSTools deviceType] stringByReplacingOccurrencesOfString:@"_" withString:@"-"],
                     [LSTools iOSVersion]];
        //软件英文别名_软件版本_设备名称_推广渠道_设备ID_用户ID_城市ID_设备类型_OS版本
    
    return stid;
}
+ (NSString *)deviceType
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
	return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}
+ (NSString *)iOSVersion
{
    return [UIDevice currentDevice].systemVersion;
}
+ (NSString *)UUID
{
    NSInteger mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;

    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *macaddress = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                            *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    
    
    if (macaddress)
    {
        NSString *uniqueIdentifier = [macaddress stringByReplacingOccurrencesOfString:@":" withString:@""];
        return uniqueIdentifier;
    }
    else
    {
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        NSString* UUID = (NSString *)[userDefaults objectForKey:lsUUID];
        
        if (NULL == UUID || 46 > UUID.length)//如果还没有，或者错误
        {
            //这种获取UUID的方式是否安全？
            
            CFUUIDRef uuid = CFUUIDCreate(NULL);
            CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
            
            UUID = [NSString stringWithFormat:@"%@", uuidStr];
            CFRelease(uuidStr);
            CFRelease(uuid);
            
            [userDefaults setObject:UUID forKey:lsUUID];
            [userDefaults synchronize];
        }
        
        return UUID;
    }
}


//计算距离
/*
 东西半球的坐标范围是-180到180
 负坐标代表西半球，正坐标代表东半球
 
 南北半球的坐标范围是-90到90
 负坐标代表南半球，正坐标代表北半球
 */
//返回值单位：米
+ (NSString*)distanceWithLongitude1:(double)lon1 latitude1:(double)lat1 longitude2:(double)lon2 latitude2:(double)lat2
{
    double er = 6378137; // 6378700.0f;
	double radlat1 = PI*lat1/180.0f;
	double radlat2 = PI*lat2/180.0f;
	double radlong1 = PI*lon1/180.0f;
	double radlong2 = PI*lon2/180.0f;
	
	if( radlat1 < 0 ) radlat1 = PI/2 + fabs(radlat1);// south
	if( radlat1 > 0 ) radlat1 = PI/2 - fabs(radlat1);// north
	if( radlong1 < 0 ) radlong1 = PI*2 - fabs(radlong1);//west
	if( radlat2 < 0 ) radlat2 = PI/2 + fabs(radlat2);// south
	if( radlat2 > 0 ) radlat2 = PI/2 - fabs(radlat2);// north
    if( radlong2 < 0 ) radlong2 = PI*2 - fabs(radlong2);// west
    
	//spherical coordinates x=r*cos(ag)sin(at), y=r*sin(ag)*sin(at), z=r*cos(at)
	//zero ag is up so reverse lat
	double x1 = er * cos(radlong1) * sin(radlat1);
	double y1 = er * sin(radlong1) * sin(radlat1);
	double z1 = er * cos(radlat1);
	double x2 = er * cos(radlong2) * sin(radlat2);
	double y2 = er * sin(radlong2) * sin(radlat2);
	double z2 = er * cos(radlat2);
	double d = sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)+(z1-z2)*(z1-z2));
	
	//side, side, side, law of cosines and arccos
	double theta = acos((er*er+er*er-d*d)/(2*er*er));
	double distance = theta*er;

    NSString *distanceString = nil;
	
	if(distance > 10000000)
    {
		distanceString = [NSString stringWithFormat:@"%.0lf万公里",(double)((double)distance / 10000000.0f)];
	}
    else if(distance > 1000000)
    {
		distanceString = [NSString stringWithFormat:@"%.0f千公里",(float)((double)distance / 1000000.0f)];
	}
    else if(distance > 1000)
    {
		distanceString = [NSString stringWithFormat:@"%.1f公里",(float)((double)distance / 1000.0f)];
	}
    else
    {
		distanceString = [NSString stringWithFormat:@"%.1f米",(float)distance];
	}
	
	return distanceString;
}

@end
