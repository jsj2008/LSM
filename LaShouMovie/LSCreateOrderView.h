//
//  LSCreateOrderView.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-26.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSOrder.h"

@interface LSCreateOrderView : UIView
{
    LSOrder* _order;
    CGFloat _contentY;
}
@property(nonatomic,retain) LSOrder* order;
@property(nonatomic,assign) CGFloat contentY;

@end
