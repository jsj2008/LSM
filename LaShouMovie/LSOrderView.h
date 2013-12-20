//
//  LSOrderView.h
//  LaShouMovie
//
//  Created by Li XiangYu on 13-9-23.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSOrder.h"

@interface LSOrderView : UIView
{
    LSOrder* _order;
    CGFloat _contentY;
}
@property(nonatomic,retain) LSOrder* order;
@property(nonatomic,assign) CGFloat contentY;

@end
