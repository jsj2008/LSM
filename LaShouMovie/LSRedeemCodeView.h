//
//  LSRedeemCodeView.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-30.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSOrder.h"

@interface LSRedeemCodeView : UIView
{
    LSOrder* _order;
}
@property(nonatomic,retain) LSOrder* order;

@end
