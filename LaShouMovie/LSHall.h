//
//  LSHall.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-16.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSHall : NSObject
{
//        hall =                     {
//            hallId = 5;
//            hallName = "5\U53f7\U5385";
//        };
    NSString* _hallID;//放映厅ID
    NSString* _hallName;//放映厅名称
}

@property(nonatomic,retain) NSString* hallID;//放映厅ID
@property(nonatomic,retain) NSString* hallName;//放映厅名称

- (id)initWithDictionary:(NSDictionary*)dic;

@end
