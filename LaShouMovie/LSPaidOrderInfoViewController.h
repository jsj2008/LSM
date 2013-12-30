//
//  LSPaidOrderInfoViewController.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-27.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSViewController.h"
#include "LSOrder.h"
#import "LSPaidWrongView.h"

@interface LSPaidOrderInfoViewController : LSViewController
<
LSPaidWrongViewDelegate
>
{
    LSOrder* _order;
}
@property(nonatomic,retain) LSOrder* order;

@end
