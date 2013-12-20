//
//  LSStatus.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-5.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSStatus : NSObject
{
    //status = {
    //            code = "-2";
    //            message = "";
    //        };
    
    NSInteger _code;
    NSString* _message;
}

@property(nonatomic,assign) NSInteger code;
@property(nonatomic,retain) NSString* message;

- (id)initWithDictionary:(NSDictionary*)safeDic;

@end
